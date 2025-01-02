import os
class Config:
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:root@localhost:5433/flask_database'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = 'your_secret_key'
    
    # Route to render the index page password="root"