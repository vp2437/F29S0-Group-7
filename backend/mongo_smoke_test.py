"""
mongo_smoke_test.py

Quick read-only check that MongoDB is reachable and your collections have data.

Run:
    cd backend
    python mongo_smoke_test.py
"""
import os
from dotenv import load_dotenv
from pymongo import MongoClient

load_dotenv()

uri = os.getenv("MONGODB_URI")
db_name = os.getenv("MONGODB_DB", "healix_db")

if not uri:
    raise SystemExit("MONGODB_URI not set. Add it to backend/.env")

client = MongoClient(uri, serverSelectionTimeoutMS=5000)
client.admin.command("ping")
db = client[db_name]

print("✅ Connected")
print("DB:", db_name)
print("Collections:", sorted(db.list_collection_names()))
print("users:", db.users.count_documents({}))
print("biomarker_readings:", db.biomarker_readings.count_documents({}))
print("sample user:", db.users.find_one({}, {"password_hash": 0}))
client.close()
