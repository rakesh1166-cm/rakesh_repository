from flask import Flask
from flask_cors import CORS  # Import CORS
from config import Config  # Import configuration class
from extensions import db  # Import the database instance
from views import main  # Import the `main` blueprint

def create_app():
    """Application Factory Pattern"""
    # Create a Flask app instance
    app = Flask(__name__)

    # Load configuration from Config class
    app.config.from_object(Config)

    # Initialize extensions
    db.init_app(app)

    # Enable CORS for the app
    CORS(app)

    # Register blueprints
    app.register_blueprint(main)  # Register `main` blueprint

    return app