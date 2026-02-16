"""
setup_mongo.py

MongoDB database initialization + seed data for HEALIX.

What it does:
- Connects to MongoDB using MONGODB_URI + MONGODB_DB (from backend/.env)
- Creates collections (idempotent)
- Creates indexes (idempotent)
- Inserts demo/seed data (idempotent upserts + a few inserts)

Run:
    cd backend
    python setup_mongo.py
"""
from __future__ import annotations

import os
from datetime import datetime, timezone, timedelta
from typing import Any, Dict, List, Tuple

from dotenv import load_dotenv
from pymongo import MongoClient, ASCENDING, DESCENDING
from pymongo.errors import CollectionInvalid, OperationFailure


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


def get_env(name: str, default: str | None = None) -> str:
    val = os.getenv(name, default)
    if not val:
        raise SystemExit(f"{name} is not set. Put it in backend/.env (or set it in your shell).")
    return val


def safe_create_collection(db, name: str, validator: Dict[str, Any] | None = None) -> None:
    """
    Create collection if it doesn't exist.

    If you don't have permissions for validators (common on some managed setups),
    we fall back to creating without a validator.
    """
    if name in db.list_collection_names():
        return

    try:
        if validator:
            db.create_collection(name, validator=validator)
        else:
            db.create_collection(name)
    except CollectionInvalid:
        # Created by a parallel process
        return
    except OperationFailure:
        # Validator might require extra privileges; create without validator
        db.create_collection(name)


def ensure_indexes(db) -> None:
    # users
    db.users.create_index([("email", ASCENDING)], unique=True)
    db.users.create_index([("role", ASCENDING)])

    # profiles
    db.profiles.create_index([("user_id", ASCENDING)], unique=True)

    # sessions
    db.sessions.create_index([("user_id", ASCENDING), ("created_at", DESCENDING)])
    db.sessions.create_index([("expires_at", ASCENDING)], expireAfterSeconds=0)  # TTL cleanup

    # password resets (TTL)
    db.password_reset_tokens.create_index([("expires_at", ASCENDING)], expireAfterSeconds=0)
    db.password_reset_tokens.create_index([("user_id", ASCENDING), ("created_at", DESCENDING)])

    # provider-patient relationships
    db.provider_patient_relationships.create_index(
        [("provider_id", ASCENDING), ("patient_id", ASCENDING)],
        unique=True
    )

    # devices
    db.devices.create_index([("user_id", ASCENDING), ("created_at", DESCENDING)])

    # biomarker readings
    db.biomarker_readings.create_index([("user_id", ASCENDING), ("recorded_at", DESCENDING)])
    db.biomarker_readings.create_index([("biomarker_type", ASCENDING), ("recorded_at", DESCENDING)])
    db.biomarker_readings.create_index([("is_faulty", ASCENDING)])

    # appointments
    db.appointments.create_index([("patient_id", ASCENDING), ("scheduled_at", ASCENDING)])
    db.appointments.create_index([("provider_id", ASCENDING), ("scheduled_at", ASCENDING)])
    db.appointments.create_index([("status", ASCENDING)])

    # prescriptions
    db.prescriptions.create_index([("patient_id", ASCENDING), ("created_at", DESCENDING)])
    db.prescriptions.create_index([("provider_id", ASCENDING), ("created_at", DESCENDING)])
    db.prescriptions.create_index([("status", ASCENDING)])

    # goals (aka thresholds)
    db.goals.create_index([("user_id", ASCENDING), ("is_active", ASCENDING)])
    db.goals.create_index([("biomarker_type", ASCENDING)])

    # alerts
    db.alerts.create_index([("user_id", ASCENDING), ("created_at", DESCENDING)])
    db.alerts.create_index([("severity", ASCENDING), ("status", ASCENDING)])

    # notifications
    db.notifications.create_index([("user_id", ASCENDING), ("created_at", DESCENDING)])
    db.notifications.create_index([("is_read", ASCENDING)])

    # audit logs
    db.audit_logs.create_index([("user_id", ASCENDING), ("created_at", DESCENDING)])
    db.audit_logs.create_index([("event_type", ASCENDING), ("created_at", DESCENDING)])


def create_collections(db) -> None:
    """
    Collections are created implicitly on first insert in MongoDB.
    We still create them explicitly so indexes/validators can be applied cleanly.
    """
    # Minimal validators (kept intentionally permissive)
    user_validator = {
        "$jsonSchema": {
            "bsonType": "object",
            "required": ["email", "role", "created_at"],
            "properties": {
                "email": {"bsonType": "string"},
                "role": {"bsonType": "string"},
                "created_at": {"bsonType": "date"},
            },
        }
    }

    reading_validator = {
        "$jsonSchema": {
            "bsonType": "object",
            "required": ["user_id", "biomarker_type", "value", "recorded_at"],
            "properties": {
                "user_id": {},
                "biomarker_type": {"bsonType": "string"},
                "value": {"bsonType": ["int", "double", "decimal"]},
                "unit": {"bsonType": "string"},
                "recorded_at": {"bsonType": "date"},
                "is_faulty": {"bsonType": "bool"},
                "fault_reason": {"bsonType": "string"},
            },
        }
    }

    safe_create_collection(db, "users", validator=user_validator)
    safe_create_collection(db, "profiles")
    safe_create_collection(db, "sessions")
    safe_create_collection(db, "password_reset_tokens")
    safe_create_collection(db, "provider_patient_relationships")
    safe_create_collection(db, "devices")
    safe_create_collection(db, "biomarker_readings", validator=reading_validator)
    safe_create_collection(db, "appointments")
    safe_create_collection(db, "prescriptions")
    safe_create_collection(db, "goals")
    safe_create_collection(db, "alerts")
    safe_create_collection(db, "notifications")
    safe_create_collection(db, "audit_logs")


def upsert_user(db, email: str, role: str, full_name: str) -> Any:
    now = utcnow()
    # fake hash for now; you can swap to bcrypt in auth implementation
    user_doc = {
        "email": email.lower(),
        "role": role,
        "password_hash": "fake_hash_password123",
        "created_at": now,
        "updated_at": now,
        "is_active": True,
    }
    db.users.update_one({"email": user_doc["email"]}, {"$setOnInsert": user_doc}, upsert=True)
    user = db.users.find_one({"email": user_doc["email"]}, {"_id": 1, "email": 1, "role": 1})
    user_id = user["_id"]

    profile_doc = {
        "user_id": user_id,
        "full_name": full_name,
        "timezone": "UTC",
        "created_at": now,
        "updated_at": now,
        "preferences": {
            "units": {"weight": "kg", "height": "cm"},
            "notifications": {"email": True, "push": True},
        },
    }
    db.profiles.update_one({"user_id": user_id}, {"$setOnInsert": profile_doc}, upsert=True)
    return user_id


def seed_data(db) -> None:
    now = utcnow()

    admin_id = upsert_user(db, "admin@healix.demo", "admin", "Admin User")
    provider1_id = upsert_user(db, "dr.singh@healix.demo", "provider", "Dr. Singh")
    provider2_id = upsert_user(db, "dr.chen@healix.demo", "provider", "Dr. Chen")

    patient1_id = upsert_user(db, "patient1@healix.demo", "patient", "Patient One")
    patient2_id = upsert_user(db, "patient2@healix.demo", "patient", "Patient Two")
    patient3_id = upsert_user(db, "patient3@healix.demo", "patient", "Patient Three")

    # relationships
    for provider_id, patient_id in [
        (provider1_id, patient1_id),
        (provider1_id, patient2_id),
        (provider2_id, patient3_id),
    ]:
        db.provider_patient_relationships.update_one(
            {"provider_id": provider_id, "patient_id": patient_id},
            {"$setOnInsert": {"provider_id": provider_id, "patient_id": patient_id, "created_at": now}},
            upsert=True
        )

    # devices
    devices = [
        {"user_id": patient1_id, "device_type": "smartwatch", "device_name": "Demo Watch A", "status": "connected"},
        {"user_id": patient2_id, "device_type": "fitness_tracker", "device_name": "Demo Tracker B", "status": "connected"},
        {"user_id": patient3_id, "device_type": "blood_pressure_cuff", "device_name": "BP Cuff C", "status": "disconnected"},
    ]
    for d in devices:
        db.devices.update_one(
            {"user_id": d["user_id"], "device_name": d["device_name"]},
            {"$setOnInsert": {**d, "created_at": now, "updated_at": now}},
            upsert=True
        )

    # goals (thresholds)
    goals = [
        {
            "user_id": patient1_id,
            "biomarker_type": "heart_rate",
            "target_min": 55,
            "target_max": 90,
            "unit": "bpm",
            "is_active": True,
            "created_at": now,
        },
        {
            "user_id": patient2_id,
            "biomarker_type": "blood_pressure_systolic",
            "target_min": 90,
            "target_max": 120,
            "unit": "mmHg",
            "is_active": True,
            "created_at": now,
        },
    ]
    for g in goals:
        db.goals.update_one(
            {"user_id": g["user_id"], "biomarker_type": g["biomarker_type"]},
            {"$setOnInsert": g},
            upsert=True
        )

    # biomarker readings (some faulty)
    def add_reading(user_id, biomarker_type, value, unit, days_ago, is_faulty=False, fault_reason=None):
        doc = {
            "user_id": user_id,
            "biomarker_type": biomarker_type,
            "value": value,
            "unit": unit,
            "recorded_at": now - timedelta(days=days_ago),
            "source": "seed",
            "is_faulty": bool(is_faulty),
            "created_at": now,
        }
        # Only include fault_reason when the reading is marked faulty (schema disallows null)
        if is_faulty:
            doc["fault_reason"] = str(fault_reason or "unknown")
        db.biomarker_readings.insert_one(doc)

    add_reading(patient1_id, "heart_rate", 76, "bpm", 2)
    add_reading(patient1_id, "heart_rate", 180, "bpm", 1, True, "out_of_range_spike")
    add_reading(patient2_id, "blood_pressure_systolic", 118, "mmHg", 3)
    add_reading(patient2_id, "blood_pressure_diastolic", 78, "mmHg", 3)
    add_reading(patient3_id, "blood_pressure_systolic", 145, "mmHg", 1)

    # appointments
    db.appointments.update_one(
        {"patient_id": patient1_id, "provider_id": provider1_id, "scheduled_at": now + timedelta(days=3)},
        {"$setOnInsert": {
            "patient_id": patient1_id,
            "provider_id": provider1_id,
            "scheduled_at": now + timedelta(days=3),
            "status": "scheduled",
            "reason": "Routine check-in",
            "created_at": now,
        }},
        upsert=True
    )

    # prescriptions
    db.prescriptions.update_one(
        {"patient_id": patient2_id, "provider_id": provider1_id, "medication": "Atorvastatin"},
        {"$setOnInsert": {
            "patient_id": patient2_id,
            "provider_id": provider1_id,
            "medication": "Atorvastatin",
            "dosage": "10mg",
            "frequency": "once_daily",
            "status": "active",
            "created_at": now,
        }},
        upsert=True
    )

    # alerts
    db.alerts.insert_one({
        "user_id": patient3_id,
        "severity": "high",
        "status": "open",
        "title": "High systolic blood pressure",
        "message": "Recent reading indicates elevated systolic blood pressure.",
        "created_at": now,
        "source": "seed",
    })

    # notifications
    db.notifications.insert_one({
        "user_id": patient1_id,
        "type": "reminder",
        "title": "Upcoming appointment",
        "message": "You have an appointment scheduled in 3 days.",
        "is_read": False,
        "created_at": now,
    })

    # sessions (TTL on expires_at)
    db.sessions.insert_one({
        "user_id": patient1_id,
        "refresh_token_hash": "seed_refresh_hash",
        "created_at": now,
        "expires_at": now + timedelta(days=7),
        "ip": "127.0.0.1",
        "user_agent": "seed",
    })

    # audit logs
    db.audit_logs.insert_many([
        {"user_id": admin_id, "event_type": "seed_init", "message": "Seed initialized", "created_at": now},
        {"user_id": patient1_id, "event_type": "reading_ingest", "message": "Seeded reading", "created_at": now},
    ])


def smoke_test(db) -> None:
    print("\nSmoke test:")
    print(" users:", db.users.count_documents({}))
    print(" profiles:", db.profiles.count_documents({}))
    print(" devices:", db.devices.count_documents({}))
    print(" biomarker_readings:", db.biomarker_readings.count_documents({}))
    sample = db.biomarker_readings.find_one({}, {"_id": 0})
    print(" sample biomarker_reading:", sample)


def main() -> None:
    load_dotenv()

    uri = get_env("MONGODB_URI", "mongodb://localhost:27017")
    db_name = get_env("MONGODB_DB", "healix_db")

    client = MongoClient(uri, serverSelectionTimeoutMS=5000)
    # Force a connection now (throws early if not reachable)
    client.admin.command("ping")

    db = client[db_name]

    print(f"✅ Connected to MongoDB: {uri}")
    print(f"Using database: {db_name}")

    create_collections(db)
    ensure_indexes(db)
    seed_data(db)
    smoke_test(db)

    client.close()
    print("\n✅ MongoDB setup complete.")


if __name__ == "__main__":
    main()
