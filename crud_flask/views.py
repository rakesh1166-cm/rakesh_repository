import uuid
from flask_bcrypt import Bcrypt
from flask import Blueprint, jsonify, render_template, request, redirect, url_for
from extensions import db
from models import Task, Student, User, EntityHighlight
import spacy
from flask import current_app
from textblob import TextBlob
from nltk.tokenize import sent_tokenize
import nltk
import numpy as np
import openai

bcrypt = Bcrypt()
main = Blueprint('main', __name__)

nltk.download('punkt')
nlp = spacy.load("en_core_web_sm")

# OpenAI API setup
openai.api_key = "YOUR_OPENAI_API_KEY"

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

@main.route('/text-tools/trim_whitespace', methods=['POST'])
def split_into_paragraphs():
    data = request.json
    text = data.get("text", "")  # Expecting raw text to be sent in the request body
    
    if not text:
        return jsonify({"error": "Text input is required"}), 400

    # Trim whitespace from both ends of the input text
    processed_text = text.strip()

    # Split the text into paragraphs by double newlines
    paragraphs = processed_text.split("\n\n")

    # Print the paragraphs list for debugging
    print(f"Paragraphs split: {paragraphs}")

    return jsonify({"processed_text": paragraphs}), 200
@main.route('/text-tools/line_numbering', methods=['POST'])


def line_numbering():
    data = request.json
    text = data.get("text", "")
    
    print(f"Received text: {text}")  # Print the received text for debugging
    
    if not text:
        print("Error: No text input provided")  # Print an error message if no text is provided
        return jsonify({"error": "Text input is required"}), 400

    # Split the text into paragraphs by looking for double newlines (\n\n)
    paragraphs = text.split("\n\n")
    print(f"Paragraphs split: {paragraphs}")  # Print the list of paragraphs after splitting the text

    # Initialize line counter to apply sequential numbering to non-empty lines
    numbered_lines = []
    line_number = 1

    for paragraph in paragraphs:
        # Split each paragraph into lines (we'll ignore empty lines within paragraphs)
        lines = paragraph.splitlines()

        # Filter and number non-empty lines in each paragraph
        for line in lines:
            if line.strip():  # Only process non-empty lines
                numbered_lines.append(f"{line_number}: {line.strip()}")
                line_number += 1  # Increment the line number for each non-empty line

    print(f"Numbered lines: {numbered_lines}")  # Print the list of numbered lines

    processed_text = "\n".join(numbered_lines)


    return jsonify({"Numbered lines": numbered_lines}), 200



@main.route('/text-tools/remove_duplicate_lines_sort', methods=['POST'])
def remove_duplicate_lines_sort():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400

    # Split lines and preserve the original order while removing duplicates
    seen = set()
    unique_lines = []
    for line in text.splitlines():
        if line not in seen:
            seen.add(line)
            unique_lines.append(line)

    # Sort the unique lines based on the order of appearance
    processed_text = "\n".join(unique_lines)
    return jsonify({"processed_text": unique_lines}), 200


@main.route('/text-tools/remove_spaces_each_line', methods=['POST'])
def remove_spaces_each_line():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400

    lines = [line.replace(" ", "") for line in text.splitlines()]
    processed_text = "\n".join(lines)
    return jsonify({"processed_text": lines}), 200


@main.route('/text-tools/replace_space_with_dash', methods=['POST'])
def replace_space_with_dash():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400

    # Split the text into a list of lines
    lines = text.splitlines()

    # Replace spaces with dashes in each line
    processed_lines = [line.replace(" ", "-") for line in lines]

    # Return the processed list as JSON
    return jsonify({"processed_text": processed_lines}), 200


@main.route('/text-tools/ascii_unicode_conversion', methods=['POST'])
def ascii_unicode_conversion():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400

    # Create a list of Unicode values for each character
    unicode_values = [f"{char}: {ord(char)}" for char in text]

    # Return the list directly in the JSON response
    return jsonify({"processed_text": unicode_values}), 200

@main.route('/text-tools/count_words_characters', methods=['POST'])
def count_words_characters():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400

    # Count words and characters
    word_count = len(text.split())
    char_count = len(text)

    # Convert the output to a list format
    processed_text = [
        f"Words: {word_count}",
        f"Characters: {char_count}"
    ]

    # Return the list in the response
    return jsonify({"processed_text": processed_text}), 200


@main.route('/text-tools/reverse_lines_words', methods=['POST'])
def reverse_lines_words():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400

    lines = text.splitlines()
    reversed_lines = [" ".join(line.split()[::-1]) for line in lines]
    processed_text = "\n".join(reversed_lines)
    return jsonify({"processed_text": reversed_lines}), 200


@main.route('/text-tools/remove_blank_lines', methods=['POST'])
def remove_blank_lines():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400

    lines = [line for line in text.splitlines() if line.strip()]
    processed_text = "\n".join(lines)
    return jsonify({"processed_text": lines}), 200
@main.route('/text-tools/extract_information', methods=['POST'])
def extract_information():
    import re
   

    # Retrieve input data
    data = request.json
    text = data.get("text", "")
    extraction_method = data.get("extraction_method", "regex")

    # Validate text input
    if not text:
        return jsonify({"error": "Text input is required"}), 400

    # Regex patterns for emails and URLs
    email_pattern = r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
    url_pattern = r"https?://[^\s]+"

    # Extract emails and URLs
    emails = re.findall(email_pattern, text)
    urls = re.findall(url_pattern, text)

    # Combine results with bold headers
    processed_data = ["**Email:**"] + emails + ["**URL:**"] + urls

    return jsonify({"processed_text": processed_data}), 200

# Feature: Split Text by Characters
@main.route('/text-tools/split_text_by_characters', methods=['POST'])
def split_text_by_characters():
    data = request.json
    text = data.get("text", "")
    char_count = data.get("char_count", 100)  # Default split size

    if not text:
        return jsonify({"error": "Text input is required"}), 400

    split_text = [text[i:i + char_count] for i in range(0, len(text), char_count)]
    return jsonify({"processed_text": split_text}), 200

# Feature: Change Case
@main.route('/text-tools/change_case', methods=['POST'])
def change_case():
 

    data = request.json
    text = data.get("text", "")
    case_option = data.get("case_option", "lowercase")

    if not text:
        return jsonify({"error": "Text input is required"}), 400

    # Apply the specified case transformation to the whole text
    if case_option == "uppercase":
        processed_text = [text.upper()]  # Whole text in uppercase
    elif case_option == "capitalize":
        processed_text = [text.title()]  # Whole text in title case
    else:  # Default to lowercase
        processed_text = [text.lower()]  # Whole text in lowercase

    return jsonify({"processed_text": processed_text}), 200

# Feature: Change Case by Find
@main.route('/text-tools/change_case_find', methods=['POST'])
def change_case_find():
 
    import re

    data = request.json
    text = data.get("text", "")
    target_text = data.get("target_text", "")
    case_option = data.get("case_option", "uppercase")

    if not text or not target_text:
        return jsonify({"error": "Text and Target Text are required"}), 400

    # Function to apply case transformation to matches
    def change_case_function(match):
        if case_option == "uppercase":
            return match.group().upper()
        elif case_option == "lowercase":
            return match.group().lower()
        elif case_option == "capitalize":
            return match.group().capitalize()

    # Regex pattern to find target text
    pattern = re.compile(re.escape(target_text), re.IGNORECASE)

    # Process the text and collect matches
    matches = pattern.findall(text)  # Get all matches
    processed_text = pattern.sub(change_case_function, text)  # Modify the text

    # Return processed text in list format
    result = [processed_text] + matches  # Processed text followed by matches
    return jsonify({"processed_text": result}), 200

# Feature: Count Words by Find
@main.route('/text-tools/count_words_find', methods=['POST'])
def count_words_find():
    data = request.json
    text = data.get("text", "")
    target_text = data.get("target_text", "")

    if not text or not target_text:
        return jsonify({"error": "Text and Target Text are required"}), 400

    count = text.lower().count(target_text.lower())
    return jsonify({"processed_text": [f"Occurrences of '{target_text}': {count}"]}), 200

# Feature: Add Prefix/Suffix to Lines (already implemented in previous code)
@main.route('/text-tools/add_prefix_suffix', methods=['POST'])
def add_prefix_suffix():
    data = request.json
    text = data.get("text", "")
    prefix = data.get("prefix", "")
    suffix = data.get("suffix", "")

    if not text:
        return jsonify({"error": "Text input is required"}), 400

    lines = [f"{prefix}{line}{suffix}" for line in text.splitlines()]
    return jsonify({"processed_text": lines}), 200

@main.route('/text-tools/add_custom_prefix_suffix', methods=['POST'])
def add_custom_prefix_suffix():
    # Log raw input data
    print(f"Raw request data: {request.json}")

    data = request.json
    text = data.get("text", "")
    prefix = data.get("prefix", "")
    suffix = data.get("suffix", "")
    find_text_prefix = data.get("find_text_prefix", "")
    find_text_suffix = data.get("find_text_suffix", "")

    # Debugging individual fields
    print(f"text: {text}")
    print(f"prefix: {prefix}")
    print(f"suffix: {suffix}")
    print(f"find_text_prefix: {find_text_prefix}")
    print(f"find_text_suffix: {find_text_suffix}")

    if not text:
        return jsonify({"error": "Text input is required"}), 400

    lines = []
    for line in text.splitlines():
        modified_line = line
        if find_text_prefix.lower() in line.lower():
            modified_line = f"{prefix}{modified_line}"
        if find_text_suffix.lower() in line.lower():
            modified_line = f"{modified_line}{suffix}"
        lines.append(modified_line)

    return jsonify({"processed_text": lines}), 200
@main.route('/text-tools/replace_text', methods=['POST'])      
def find_replace():
    print('inside find replace')
    data = request.json
    text = data.get("text", "")
    find_text = data.get("find_text", "")
    replace_text = data.get("replace_text", "")
    method = data.get("method", "simple")  # Optional, default to "simple"

    if not text or not find_text:
        return jsonify({"error": "Text and Find Text are required"}), 400

    # Perform replacement based on the method
    if method == "case_insensitive":
        import re
        pattern = re.compile(re.escape(find_text), re.IGNORECASE)
        processed_text = pattern.sub(replace_text, text)
    else:
        processed_text = text.replace(find_text, replace_text)

    # Convert the processed text into a list of lines
    processed_lines = processed_text.splitlines()
    print("process text")
    print(processed_lines)
    return jsonify({"processed_text": processed_lines}), 200     

@main.route('/text-tools/summarization', methods=['POST'])
def summarization():
    try:
        print("DEBUG: Received a POST request at /text-tools/summarization")

        # Step 1: Retrieve input data
        data = request.json
        print(f"DEBUG: Request JSON: {data}")
        text = data.get("text", "")
        method = data.get("method", "all")  # Default to "all" methods
        method1 = data.get("summarization_method", "all")  # Default to "all" methods
        print("method us k")
        print(method)

        max_length = int(data.get("max_length", 100))

        # Step 2: Validate input
        if not text:
            print("DEBUG: No text input provided")
            return jsonify({"error": "Text input is required"}), 400

        results = []

        # Step 3: Spacy Summarization
        if method in ["all", "SpaCy"]:
            print("DEBUG: Starting Spacy summarization")
            doc = nlp(text)
            sentences = [sent.text for sent in doc.sents]
            results.append(f"Spacy: {' '.join(sentences[:max_length])}")

        # Step 4: NLTK Summarization
        if method1 in ["all", "nltk"]:
            print("DEBUG: Starting NLTK summarization")
            nltk_sentences = sent_tokenize(text)
            results.append(f"NLTK: {' '.join(nltk_sentences[:max_length])}")

        

        print("DEBUG: Summarization results:", results)
        return jsonify({"processed_text": results}), 200

    except Exception as e:
        print(f"ERROR: An exception occurred: {e}")
        return jsonify({"error": "An internal server error occurred.", "details": str(e)}), 5

@main.route('/text-tools/text_similarity', methods=['POST'])
def text_similarity():
    data = request.json
    text = data.get("text", "")
    second_text = data.get("second_text", "")
    method = data.get("method", "all")  # Default to "all" methods

    if not text or not second_text:
        return jsonify({"error": "Both text inputs are required"}), 400

    results = []

    if method in ["all", "spacy"]:
        # Spacy Similarity
        doc1 = nlp(text)
        doc2 = nlp(second_text)
        spacy_similarity = doc1.similarity(doc2)
        results.append(f"Spacy: Similarity score = {spacy_similarity:.2f}")

    if method in ["all", "textblob"]:
        # TextBlob Similarity (Jaccard Index Example)
        blob1 = set(TextBlob(text).words)
        blob2 = set(TextBlob(second_text).words)
        jaccard_similarity = len(blob1 & blob2) / len(blob1 | blob2)
        results.append(f"TextBlob: Jaccard similarity = {jaccard_similarity:.2f}")

    if method in ["all", "nltk"]:
        # NLTK Similarity
        nltk_tokens1 = set(text.lower().split())
        nltk_tokens2 = set(second_text.lower().split())
        nltk_similarity = len(nltk_tokens1 & nltk_tokens2) / len(nltk_tokens1 | nltk_tokens2)
        results.append(f"NLTK: Similarity score = {nltk_similarity:.2f}")

   

    return jsonify({"processed_text": results}), 200

@main.route('/text-tools/sentiment_analysis', methods=['POST'])
def sentiment_analysis():
    data = request.json
    text = data.get("text", "")
    method = data.get("method", "all")  # Default to "all" methods

    if not text:
        return jsonify({"error": "Text input is required"}), 400

    results = []

    if method in ["all", "nltk"]:
        # NLTK Sentiment Analysis
        nltk_sentiment = sentiment_analyzer.polarity_scores(text)
        sentiment = "positive" if nltk_sentiment['compound'] > 0 else "negative" if nltk_sentiment['compound'] < 0 else "neutral"
        results.append(f"NLTK: Sentiment = {sentiment}")

    if method in ["all", "textblob"]:
        # TextBlob Sentiment Analysis
        blob = TextBlob(text)
        sentiment = "positive" if blob.sentiment.polarity > 0 else "negative" if blob.sentiment.polarity < 0 else "neutral"
        results.append(f"TextBlob: Sentiment = {sentiment}")

    

@main.route('/text-tools/translation', methods=['POST'])
def translation():
    data = request.json
    text = data.get("text", "")
    target_language = data.get("target_language", "fr")
    method = data.get("method", "openai")  # Default to "openai"

    if not text:
        return jsonify({"error": "Text input is required"}), 400

    results = []

    if method in ["all", "openai"]:
        # OpenAI Translation
        openai_response = openai.Completion.create(
            engine="text-davinci-003",
            prompt=f"Translate the following text to {target_language}:\n{text}",
            max_tokens=100
        )
        results.append(f"OpenAI: {openai_response.choices[0].text.strip()}")

    return jsonify({"processed_text": results}), 200
