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
    __tablename__ = 'users'  # Ensure the table name matches
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)

    def __repr__(self):
        return f"<User {self.username}>"   
class EntityHighlight(db.Model):
    __tablename__ = 'entity_highlight'
    id = db.Column(db.Integer, primary_key=True, nullable=False)  # Auto-increment primary key
    text = db.Column(db.Text, nullable=False)  # Main text field
    org = db.Column(db.JSON, nullable=False)   # JSON data for organization
    sentence = db.Column(db.Text, nullable=False)  # Sentence field
    textid = db.Column(db.String(200), nullable=False)  # Unique identifier for text

    def __repr__(self):
        return f"<EntityHighlight ID: {self.id}, TextID: {self.textid}>"