"""src/routes/appointment_routes.py

Minimal appointment routes placeholder.
"""

from flask import Blueprint, jsonify


bp = Blueprint("appointments", __name__, url_prefix="/api/appointments")


@bp.get("/ping")
def ping_appointments():
    return jsonify({"ok": True, "service": "appointments"})
