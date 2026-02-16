# app.py
"""
HEALIX Backend - Main Application Entry Point
"""
import os
from src import create_app

# Determine environment
env = os.getenv('FLASK_ENV', 'development')

# Create Flask app
app = create_app(env)

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('FLASK_DEBUG', True)
    app.run(
        host='0.0.0.0',
        port=port,
        debug=debug
    )
