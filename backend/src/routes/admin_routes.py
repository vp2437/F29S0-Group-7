"""src/routes/admin_routes.py

Minimal admin routes placeholder.
"""

from flask import Blueprint, jsonify


bp = Blueprint("admin", __name__, url_prefix="/api/admin")


@bp.get("/ping")
def ping_admin():
    return jsonify({"ok": True, "service": "admin"})
