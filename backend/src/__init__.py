# src/__init__.py
from flask import Flask
from flask_jwt_extended import JWTManager
from flask_cors import CORS
from pymongo import MongoClient
from src.config.settings import config

jwt = JWTManager()

def create_app(config_name='development'):
    """Application factory function"""
    app = Flask(__name__)

    # Load configuration
    app.config.from_object(config[config_name])

    # Initialize extensions
    CORS(app)
    jwt.init_app(app)

    # Initialize MongoDB client and attach to app
    mongo_uri = app.config.get("MONGODB_URI")
    mongo_db_name = app.config.get("MONGODB_DB")
    client = MongoClient(mongo_uri, serverSelectionTimeoutMS=5000)
    # Fail fast if connection is bad
    client.admin.command("ping")
    app.mongo_client = client
    app.mongo_db = client[mongo_db_name]

    @app.teardown_appcontext
    def close_mongo(exception=None):
        try:
            client.close()
        except Exception:
            pass

    # Register routes
    from src.routes import (
        auth_routes,
        biomarker_routes,
        appointment_routes,
        admin_routes,
        export_routes,
    )
    app.register_blueprint(auth_routes.bp)
    app.register_blueprint(biomarker_routes.bp)
    app.register_blueprint(appointment_routes.bp)
    app.register_blueprint(admin_routes.bp)
    app.register_blueprint(export_routes.bp)

    # Error handlers
    from src.middleware.error_handler import register_error_handlers
    register_error_handlers(app)

    return app
