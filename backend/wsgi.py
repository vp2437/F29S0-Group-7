# wsgi.py
"""
Production WSGI entry point for deployment
"""
import os
from src import create_app

app = create_app(os.getenv('FLASK_ENV', 'production'))

if __name__ == "__main__":
    app.run()
