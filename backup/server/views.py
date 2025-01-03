from flask import Blueprint, jsonify, render_template, request, redirect, url_for
from extensions import db
from models import Task, Student, User  # Import Task, Student, and User models

main = Blueprint('main', __name__)

# --- Task CRUD (Existing Code) ---
@main.route('/')
def index():
    items = Task.query.all()
    return render_template('index.html', items=items)

@main.route('/add', methods=['GET', 'POST'])
def add_item():
    if request.method == 'POST':
        name = request.form['name']  # Field name from the HTML form
        description = request.form.get('description')
        new_item = Task(title=name, description=description)
        db.session.add(new_item)
        db.session.commit()
        return redirect(url_for('main.index'))
    return render_template('add.html')

@main.route('/edit/<int:id>', methods=['GET', 'POST'])
def edit_item(id):
    item = Task.query.get_or_404(id)
    if request.method == 'POST':
        item.title = request.form['name']
        item.description = request.form.get('description')
        db.session.commit()
        return redirect(url_for('main.index'))
    return render_template('edit.html', item=item)

@main.route('/delete/<int:id>', methods=['POST'])
def delete_item(id):
    item = Task.query.get_or_404(id)
    db.session.delete(item)
    db.session.commit()
    return redirect(url_for('main.index'))

# --- Student CRUD (New Code for CRUD2) ---
@main.route('/students/')
def students_index():
    """List all students"""
    students = Student.query.all()
    return render_template('students/index.html', students=students)

@main.route('/student/')
def student_index():
    """List all students in JSON format"""
    students = Student.query.all()
    # Include the email field in the response
    student_list = [{"id": student.id, "name": student.name, "email": student.email} for student in students]
    return jsonify({"items": student_list})

@main.route('/student/add', methods=['POST'])
def store_student():
    data = request.json
    name = data.get('name')
    email = data.get('email')
    if not name or not email:
        return jsonify({"error": "Name and Email are required"}), 400

    new_student = Student(name=name, email=email)
    db.session.add(new_student)
    db.session.commit()
    return jsonify({"id": new_student.id, "name": new_student.name, "email": new_student.email}), 201

@main.route('/student/<int:id>/', methods=['PUT'])
def update_student(id):
    data = request.json  # Get the JSON payload from the request
    if not data:
        return jsonify({"error": "Invalid input"}), 400

    student = Student.query.get_or_404(id)  # Retrieve the student by ID
    # Update the student's name and email
    student.name = data.get('name', student.name)  # Update if provided, otherwise keep current
    student.email = data.get('email', student.email)
    db.session.commit()  # Commit changes to the database

    # Return the updated student
    return jsonify({"id": student.id, "name": student.name, "email": student.email}), 200

@main.route('/student/delete/<int:id>/', methods=['DELETE'])
def delete_student(id):
    # Query the student by ID or return a 404 error if not found
    student = Student.query.get_or_404(id)

    # Delete the student from the database
    db.session.delete(student)
    db.session.commit()

    # Return a success message
    return jsonify({"message": f"Student with ID {id} deleted successfully"}), 200

# --- User Routes ---
@main.route('/register', methods=['POST'])
def register():
    data = request.json
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    if not username or not email or not password:
        return jsonify({"error": "Username, Email, and Password are required"}), 400

    # Proceed with saving the data if validation passes
    new_user = User(username=username, email=email, password=password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully!", "user": {"username": username, "email": email}}), 201

@main.route('/users/')
def list_users():
    """List all users."""
    users = User.query.all()
    user_list = [{"id": user.id, "username": user.username, "email": user.email} for user in users]
    return jsonify({"users": user_list})
