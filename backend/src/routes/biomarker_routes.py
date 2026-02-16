"""src/routes/biomarker_routes.py

Minimal biomarker routes placeholder.
"""

from flask import Blueprint, jsonify


bp = Blueprint("biomarkers", __name__, url_prefix="/api/biomarkers")


@bp.get("/ping")
def ping_biomarkers():
    return jsonify({"ok": True, "service": "biomarkers"})
