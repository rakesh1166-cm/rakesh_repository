from extensions import db

# Existing Task model
class Task(db.Model):
    __tablename__ = 'task'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.String(200), nullable=True)  # Optional field
    done = db.Column(db.Boolean, default=False, nullable=False)  # Task completion status

    def __repr__(self):
        return f"<Task {self.title}>"

# New Student model
class Student(db.Model):
    __tablename__ = 'student'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)

    def __repr__(self):
        return f"<Student {self.name}>"
class User(db.Model):
    __tablename__ = 'users'  # Matches the table name in your PostgreSQL database
    id = db.Column(db.Integer, primary_key=True)  # Primary key
    username = db.Column(db.String(200), nullable=False)  # Username field
    email = db.Column(db.String(200), unique=True, nullable=False)  # Email field with uniqueness constraint
    password = db.Column(db.String(200), nullable=False)  # Password field

    def __repr__(self):
        return f"<User {self.username}>"   