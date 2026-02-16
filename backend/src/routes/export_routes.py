"""src/routes/export_routes.py

Minimal export routes placeholder.
"""

from flask import Blueprint, jsonify


bp = Blueprint("export", __name__, url_prefix="/api/export")


@bp.get("/ping")
def ping_export():
    return jsonify({"ok": True, "service": "export"})
