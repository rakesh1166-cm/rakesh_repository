from flask_bcrypt import Bcrypt  # Import only Bcrypt from flask_bcrypt
from flask import Blueprint, jsonify, render_template, request, redirect, url_for
from extensions import db
from models import Task, Student, User  # Import Task, Student, and User models
import jwt

bcrypt = Bcrypt()
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
    try:
        # Debugging: Print the incoming JSON request
        print("Request Headers:", request.headers)  # Check if correct headers are sent
        print("Request JSON:", request.json)  # Debug print to check the received payload

        # Extract data from the request
        data = request.json
        if not data:
            print("Error: No JSON payload received.")
            return jsonify({"error": "Invalid JSON payload"}), 400

        username = data.get('username')
        email = data.get('email')
        password = data.get('password')
        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
        # Debugging: Print extracted data
        print(f"Extracted Data - Username: {username}, Email: {email}, Password: {password}")

        # Validate data
        if not username or not email or not password:
            print("Error: Missing required fields.")
            return jsonify({"error": "Username, Email, and Password are required"}), 400

        # Debugging: Check if the database session is accessible
        print("Proceeding to save the user in the database...")

        # Proceed with saving the data
        new_user = User(username=username, email=email, password=hashed_password)
        db.session.add(new_user)
        db.session.commit()

        # Debugging: Confirm successful database commit
        print("User successfully saved in the database.")

        # Return success response
        return jsonify({"message": "User registered successfully!", "user": {"username": username, "email": email}}), 201

    except Exception as e:
        # Debugging: Log the exception
        print("Error occurred:", str(e))
        return jsonify({"error": "An error occurred on the server.", "details": str(e)}), 500
# @main.route('/login', methods=['POST'])
# def login_user():
#     try:
#         # Get the JSON data from the request
#         data = request.json

#         # Extract email and password from the request
#         email = data.get('email')
#         password = data.get('password')

#         # Validate input
#         if not email or not password:
#             return jsonify({'error': 'Email and password are required'}), 400

#         # Find the user in the database
#         user = User.query.filter_by(email=email).first()

#         # Check if the user exists and the password matches
#         if user and bcrypt.check_password_hash(user.password_hash, password):
#             # Generate and return authentication token
#             token = generate_auth_token(user)
#             return jsonify({'token': token}), 200
#         else:
#             return jsonify({'error': 'Invalid email or password'}), 401

#     except Exception as e:
#         print(f"Error during login: {str(e)}")
#         return jsonify({'error': 'An error occurred during login'}), 500
    
@main.route('/login', methods=['POST'])
def login():
    try:
        # Get the JSON data from the request
        data = request.json

        # Extract email and password from the request
        email = data.get('email')
        password = data.get('password')

        # Validate input
        if not email or not password:
            return jsonify({'error': 'Email and password are required'}), 400

        # Trim the password to remove unwanted whitespace or tab characters
        password = password.strip()

        print(f"Request data: {data}")
        print(f"Processed password: {repr(password)}")  # Print raw password after strip()

        # Find the user in the database
        user = User.query.filter_by(email=email).first()

        print(f"Found user: {user}")

        # Check if the user exists and the password matches
        if user and bcrypt.check_password_hash(user.password, password):
            # Return user information
            print("Login successful")
            print(user)
            return jsonify({'user': {'id': user.id, 'email': user.email}}), 200
        else:
            print("Login failed: Invalid email or password")
            return jsonify({'error': 'Invalid email or password'}), 401

    except Exception as e:
        print(f"Error during login: {str(e)}")
        return jsonify({'error': 'An error occurred during login'}), 500
# def generate_auth_token(user):
#     token = jwt.encode(
#         {'user_id': user.id, 'email': user.email},
#         current_app.config['SECRET_KEY'],
#         algorithm='HS256'
#     )
#     return token 
@main.route('/users/')
def list_users():
    """List all users."""
    users = User.query.all()
    user_list = [{"id": user.id, "username": user.username, "email": user.email} for user in users]
    return jsonify({"users": user_list})
