"""src/routes/auth_routes.py

Minimal authentication routes placeholder.

The project is currently focused on database creation/migrations.
These routes are intentionally minimal so the Flask app can start.
"""

from flask import Blueprint, jsonify


bp = Blueprint("auth", __name__, url_prefix="/api/auth")


@bp.get("/ping")
def ping_auth():
    return jsonify({"ok": True, "service": "auth"})
