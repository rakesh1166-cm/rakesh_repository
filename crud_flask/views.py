import uuid
from flask_bcrypt import Bcrypt
from flask import Blueprint, jsonify, render_template, request, redirect, url_for
from extensions import db
from models import Task, Student, User, EntityHighlight
import spacy
from flask import current_app


bcrypt = Bcrypt()
main = Blueprint('main', __name__)

nlp = spacy.load("en_core_web_sm")
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
#//////////////////////////////////NLP============================================
# Define the custom component
def sentence_entity_highlighter(doc):
    result = []
    for sent in doc.sents:
        sent_data = {
            "sentence": sent.text,
            "entities": [
                {"text": ent.text, "label": ent.label_} for ent in sent.ents
            ],
        }
        result.append(sent_data)
    return result

# Create a Blueprint for the main routes


@main.route('/highlight-entity', methods=['POST'])  # Update to match the frontend URL
def process_entity_highlighter():
    # Get the input text from the request
    print("highlightmee")
    data = request.json
    print(data)
    text = data.get("text", "")

    if not text:
        return jsonify({"error": "Text input is required"}), 400

    # Generate a unique textid for the entire paragraph
    textid = str(uuid.uuid4())  # Same textid for the entire paragraph
    print(f"Generated textid: {textid}")

    # Process the text with SpaCy
    doc = nlp(text)
    result = sentence_entity_highlighter(doc)
    print("result coming")
    print(result)

    # Save data to the database
    try:
        for sent in result:
            sentence_text = sent["sentence"]
            entities = sent["entities"]

            # Collect all entities for the current sentence into a single JSON object
            entities_json = [{"entity_text": entity["text"], "entity_label": entity["label"]} for entity in entities]

            # Create a new record for the sentence
            entity_highlight = EntityHighlight(
                text=text,  # The full paragraph
                sentence=sentence_text,  # Current sentence
                org=entities_json,  # JSON array of entities for this sentence
                textid=textid  # Unique identifier for the entire paragraph
            )

            db.session.add(entity_highlight)  # Add to the session

        db.session.commit()  # Commit all changes to the database
        print("Data successfully saved to the database.")
    except Exception as e:
        db.session.rollback()  # Rollback in case of an error
        print("Error saving to the database:", e)
        return jsonify({"error": "Failed to save data to the database"}), 500

    return jsonify(result)
@main.route('/fetch-all-entities', methods=['GET'])
def fetch_all_entities():
    try:
        # Query all rows from the EntityHighlight table
        all_entities = EntityHighlight.query.all()

        # Convert the rows into a JSON-friendly format
        result = [
            {
                "id": entity.id,
                "text": entity.text,
                "sentence": entity.sentence,
                "org": entity.org,
                "textid": entity.textid,
            }
            for entity in all_entities
        ]
        print("all data here") 
        print(result)
        return jsonify(result), 200
    except Exception as e:
        print(f"Error fetching all entities: {e}")
        return jsonify({"error": "Failed to fetch entities"}), 500
def long_sentence_detector(doc):
    print("Debug: Entered long_sentence_detector function")  # Debug log
    max_length = 10  # Customize the length threshold
    long_sentences = []

    for sent in doc.sents:
        print(f"Debug: Analyzing sentence: {sent.text}")  # Debug log
        if len(sent) > max_length:
            print(f"Debug: Long sentence detected: {sent.text}")  # Debug log
            long_sentences.append({"sentence": sent.text, "length": len(sent)})

    print(f"Debug: Long sentences found: {long_sentences}")  # Debug log
    return {"long_sentences": long_sentences}

# Create a Blueprint


@main.route('/long_sentence', methods=['POST'])
def process_sentence_detector():
    print("Debug: Received a POST request at /long_sentences")  # Debug log
    data = request.json
    print(f"Debug: Received data: {data}")  # Debug log

    text = data.get("text", "")
    if not text:
        print("Debug: No text provided in the request")  # Debug log
        return jsonify({"error": "Text input is required"}), 400

    print(f"Debug: Processing text: {text}")  # Debug log
    # Process the text with SpaCy
    doc = nlp(text)
    print("Debug: SpaCy document created")  # Debug log

    result = long_sentence_detector(doc)
    print(f"Debug: Result generated: {result}")  # Debug log

    return jsonify(result)
def keyword_extractor(doc):
    keywords = {"AI", "machine learning", "data", "neural networks"}  # Define keywords
    keyword_count = {keyword: 0 for keyword in keywords}

    for token in doc:
        if token.text in keywords:
            keyword_count[token.text] += 1

    return {"keyword_counts": keyword_count}

# Create a Blueprint


@main.route('/extract_keywords', methods=['POST'])
def process_keyword_extractor():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400

    # Process the text with SpaCy
    doc = nlp(text)
    result = keyword_extractor(doc)

    return jsonify(result)    
def blacklist_detector(doc):
    print("Debug: Entered blacklist_detector function")  # Debug log
    blacklist = {"spam", "fake", "scam"}  # Define blacklist
    flagged = [token.text for token in doc if token.text.lower() in blacklist]
    
    if flagged:
        print(f"Blacklisted words detected: {', '.join(flagged)}")  # Debug log
    else:
        print("No blacklisted words detected.")  # Debug log

    return {"flagged_words": flagged}

# Create a Flask Blueprint


@main.route('/detect_blacklist', methods=['POST'])
def process_blacklist_detector():
    print("Debug: Received a POST request at /detect_blacklist")  # Debug log
    data = request.json
    print(f"Debug: Received data: {data}")  # Debug log

    text = data.get("text", "")
    if not text:
        print("Debug: No text provided in the request")  # Debug log
        return jsonify({"error": "Text input is required"}), 400

    print(f"Debug: Processing text: {text}")  # Debug log
    # Process the text with SpaCy
    doc = nlp(text)
    print("Debug: SpaCy document created")  # Debug log

    result = blacklist_detector(doc)
    print(f"Debug: Result generated: {result}")  # Debug log

    return jsonify(result)   
