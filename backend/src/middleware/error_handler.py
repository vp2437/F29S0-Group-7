"""src/middleware/error_handler.py

Centralized error handling.

Right now the project is focused on database + schema work. These handlers keep the
API responses consistent and ensure the app boots even before all routes are fully
implemented.
"""

from __future__ import annotations

from flask import Flask, jsonify


def register_error_handlers(app: Flask) -> None:
    """Register basic JSON error handlers."""

    @app.errorhandler(404)
    def not_found(_err):
        return jsonify({"error": "not_found"}), 404

    @app.errorhandler(405)
    def method_not_allowed(_err):
        return jsonify({"error": "method_not_allowed"}), 405

    @app.errorhandler(500)
    def internal_error(_err):
        return jsonify({"error": "internal_server_error"}), 500
