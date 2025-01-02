from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable Cross-Origin Resource Sharing

# Dummy functions for reordering logic
def nlp_reordering(text, criteria, custom_criteria=None):
    # NLP-based reordering logic
    if criteria == "importance":
        return "NLP-based importance reordering result"
    elif criteria == "coherence":
        return "NLP-based coherence reordering result"
    elif criteria == "chronological":
        return "NLP-based chronological reordering result"
    elif criteria == "custom" and custom_criteria:
        return f"NLP-based reordering with custom criteria: {custom_criteria}"
    return "NLP-based reordering default result"

def rule_based_reordering(text, criteria, custom_criteria=None):
    # Rule-based reordering logic
    return f"Rule-based reordering for {criteria}"

def ml_reordering(text, criteria, custom_criteria=None):
    # Machine learning-based reordering logic
    return f"Machine learning reordering for {criteria}"

@app.route('/')
def home():
    return jsonify({"message": "Welcome to the Text Processing API!"})

# Sentence Reordering API
@app.route('/api/sentence-reordering', methods=['POST'])
def sentence_reordering():
    data = request.json
    text = data.get("text", "")
    reordering_criteria = data.get("reordering_criteria", "")
    reordering_method = data.get("reordering_method", "")
    custom_criteria = data.get("custom_criteria", "")

    if not text or not reordering_criteria or not reordering_method:
        return jsonify({"error": "Text, reordering criteria, and reordering method are required"}), 400

    reordered_text = ""

    if reordering_method == "nlp":
        reordered_text = nlp_reordering(text, reordering_criteria, custom_criteria)
    elif reordering_method == "rule_based":
        reordered_text = rule_based_reordering(text, reordering_criteria, custom_criteria)
    elif reordering_method == "machine_learning":
        reordered_text = ml_reordering(text, reordering_criteria, custom_criteria)
    else:
        return jsonify({"error": "Invalid reordering method"}), 400

    return jsonify({"reordered_text": reordered_text})

# Placeholder for other features (e.g., Text Classification, Sentiment Analysis, etc.)