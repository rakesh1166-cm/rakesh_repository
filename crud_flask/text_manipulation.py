from flask import Flask, render_template, request, jsonify
import re

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/replace_text', methods=['POST'])
def replace_text():
    data = request.json
    text = data.get("text", "")
    find_text = data.get("find_text", "")
    replace_text = data.get("replace_text", "")
    processed_text = text.replace(find_text, replace_text)
    return jsonify({"processed_text": processed_text})

@app.route('/trim_whitespace', methods=['POST'])
def trim_whitespace():
    data = request.json
    text = data.get("text", "")
    processed_text = "\n".join(line.strip() for line in text.splitlines())
    return jsonify({"processed_text": processed_text})

@app.route('/extract_information', methods=['POST'])
def extract_information():
    data = request.json
    text = data.get("text", "")
    emails = re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', text)
    urls = re.findall(r'(https?://[^\s]+)', text)
    return jsonify({"emails": emails, "urls": urls})

@app.route('/line_numbering', methods=['POST'])
def line_numbering():
    data = request.json
    text = data.get("text", "")
    numbered_lines = "\n".join(f"{i+1}: {line}" for i, line in enumerate(text.splitlines()))
    return jsonify({"processed_text": numbered_lines})

@app.route('/split_text_by_characters', methods=['POST'])
def split_text_by_characters():
    data = request.json
    text = data.get("text", "")
    char_count = data.get("char_count", 100)
    chunks = [text[i:i+char_count] for i in range(0, len(text), char_count)]
    return jsonify({"chunks": chunks})

@app.route('/ascii_unicode_conversion', methods=['POST'])
def ascii_unicode_conversion():
    data = request.json
    text = data.get("text", "")
    ascii_values = [ord(char) for char in text]
    unicode_representation = text.encode('unicode_escape').decode('utf-8')
    return jsonify({"ascii_values": ascii_values, "unicode_representation": unicode_representation})

@main.route('/count_words_characters', methods=['POST'])
def count_words_characters():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    word_count = len(text.split())
    character_count = len(text)
    
    return jsonify({"word_count": word_count, "character_count": character_count})
@main.route('/reverse_text', methods=['POST'])
def reverse_text():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    reversed_lines = "\n".join(line[::-1] for line in text.splitlines())
    reversed_words = " ".join(text.split()[::-1])
    
    return jsonify({"reversed_lines": reversed_lines, "reversed_words": reversed_words})
@main.route('/add_prefix_suffix', methods=['POST'])
def add_prefix_suffix():
    data = request.json
    text = data.get("text", "")
    prefix = data.get("prefix", "")
    suffix = data.get("suffix", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    processed_lines = "\n".join(f"{prefix}{line}{suffix}" for line in text.splitlines())
    
    return jsonify({"processed_text": processed_lines})
@main.route('/remove_blank_lines', methods=['POST'])
def remove_blank_lines():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    non_blank_lines = "\n".join(line for line in text.splitlines() if line.strip())
    
    return jsonify({"processed_text": non_blank_lines})
import re
def extract_information():
    data = request.json
    text = data.get("text_to_extract", "")
    method = data.get("extraction_method", "regex")

    emails = []
    urls = []

    if method == "regex":
        # Extract using regex
        emails = re.findall(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}", text)
        urls = re.findall(r"https?://[^\s]+", text)
    elif method == "nlp":
        # Use NLP for extraction (e.g., SpaCy)
        import spacy
        nlp = spacy.load("en_core_web_sm")
        doc = nlp(text)
        emails = [ent.text for ent in doc.ents if ent.label_ == "EMAIL"]
        urls = [ent.text for ent in doc.ents if ent.label_ == "URL"]
    elif method == "heuristics":
        # Custom heuristics for extraction
        words = text.split()
        emails = [word for word in words if "@" in word and "." in word]
        urls = [word for word in words if word.startswith("http")]
    elif method == "ai":
        # Use AI/ML for extraction (example placeholder)
        emails = ["ai_detected_email@example.com"]
        urls = ["https://ai-detected-url.com"]

@main.route('/extract_emails_urls', methods=['POST'])
def extract_emails_urls():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    emails = re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', text)
    urls = re.findall(r'(https?://[^\s]+)', text)
    
    return jsonify({"emails": emails, "urls": urls})
@main.route('/find_replace', methods=['POST'])
def find_replace():
    data = request.json
    text = data.get("text", "")
    find_text = data.get("find", "")
    replace_text = data.get("replace", "")
    if not text or not find_text:
        return jsonify({"error": "Text and text to find are required"}), 400
    
    replaced_text = text.replace(find_text, replace_text)
    
    return jsonify({"processed_text": replaced_text})
@main.route('/line_numbering', methods=['POST'])
def line_numbering():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    numbered_lines = "\n".join(f"{i+1}: {line}" for i, line in enumerate(text.splitlines()))
    
    return jsonify({"processed_text": numbered_lines})
@main.route('/trim_whitespace', methods=['POST'])
def trim_whitespace():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    trimmed_lines = "\n".join(line.strip() for line in text.splitlines())
    
    return jsonify({"processed_text": trimmed_lines})
@main.route('/split_text', methods=['POST'])
def split_text():
    data = request.json
    text = data.get("text", "")
    chunk_size = data.get("chunk_size", 100)
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    chunks = [text[i:i+chunk_size] for i in range(0, len(text), chunk_size)]
    
    return jsonify({"chunks": chunks})
@main.route('/convert_ascii_unicode', methods=['POST'])
def convert_ascii_unicode():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    ascii_values = [ord(char) for char in text]
    unicode_representation = text.encode('unicode_escape').decode('utf-8')
    
    return jsonify({"ascii_values": ascii_values, "unicode_representation": unicode_representation})
@main.route('/remove_duplicates_sort', methods=['POST'])
def remove_duplicates_sort():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    lines = list(set(text.splitlines()))
    sorted_lines = sorted(lines)
    
    return jsonify({"processed_text": "\n".join(sorted_lines)})
@main.route('/change_case', methods=['POST'])
def change_case():
    data = request.json
    text = data.get("text", "")
    case_type = data.get("case", "uppercase")  # "uppercase", "lowercase", or "capitalize"
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    if case_type == "uppercase":
        processed_text = text.upper()
    elif case_type == "lowercase":
        processed_text = text.lower()
    elif case_type == "capitalize":
        processed_text = text.title()
    else:
        return jsonify({"error": "Invalid case type provided"}), 400
    
    return jsonify({"processed_text": processed_text})
@main.route('/remove_spaces', methods=['POST'])
def remove_spaces():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    processed_lines = "\n".join(line.replace(" ", "") for line in text.splitlines())
    
    return jsonify({"processed_text": processed_lines})
@main.route('/replace_space_with_dash', methods=['POST'])
def replace_space_with_dash():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    processed_text = text.replace(" ", "-")
    
    return jsonify({"processed_text": processed_text})
@main.route('/reverse_entire_text', methods=['POST'])
def reverse_entire_text():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    reversed_text = text[::-1]
    
    return jsonify({"processed_text": reversed_text})
@main.route('/remove_duplicate_lines', methods=['POST'])
def remove_duplicate_lines():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    lines = text.splitlines()
    unique_lines = list(dict.fromkeys(lines))  # Preserves the order of lines
    
    return jsonify({"processed_text": "\n".join(unique_lines)})
@main.route('/sort_text', methods=['POST'])
def sort_text():
    data = request.json
    text = data.get("text", "")
    sort_type = data.get("sort_type", "alphabetical")  # "alphabetical" or "numerical"
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    lines = text.splitlines()
    if sort_type == "numerical":
        try:
            sorted_lines = sorted(lines, key=lambda x: float(x.strip()))
        except ValueError:
            return jsonify({"error": "Cannot sort text numerically. Ensure the input contains numbers."}), 400
    else:
        sorted_lines = sorted(lines)
    
    return jsonify({"processed_text": "\n".join(sorted_lines)})
@main.route('/capitalize_first_char', methods=['POST'])
def capitalize_first_char():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    processed_lines = "\n".join(line.capitalize() for line in text.splitlines())
    
    return jsonify({"processed_text": processed_lines})
@main.route('/split_text_by_lines', methods=['POST'])
def split_text_by_lines():
    data = request.json
    text = data.get("text", "")
    lines_per_chunk = data.get("lines_per_chunk", 10)
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    lines = text.splitlines()
    chunks = [lines[i:i+lines_per_chunk] for i in range(0, len(lines), lines_per_chunk)]
    chunks_as_text = ["\n".join(chunk) for chunk in chunks]
    
    return jsonify({"chunks": chunks_as_text})
@main.route('/split_text_by_delimiter', methods=['POST'])
def split_text_by_delimiter():
    data = request.json
    text = data.get("text", "")
    delimiter = data.get("delimiter", ",")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    chunks = text.split(delimiter)
    
    return jsonify({"chunks": chunks})
from textblob import TextBlob

@main.route('/detect_sentiment', methods=['POST'])
def detect_sentiment():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    blob = TextBlob(text)
    sentiment = {
        "polarity": blob.sentiment.polarity,
        "subjectivity": blob.sentiment.subjectivity
    }
    
    return jsonify({"sentiment": sentiment})
@main.route('/detect_long_words', methods=['POST'])
def detect_long_words():
    data = request.json
    text = data.get("text", "")
    length_threshold = data.get("length_threshold", 10)
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    long_words = [word for word in text.split() if len(word) > length_threshold]
    
    return jsonify({"long_words": long_words})
@main.route('/detect_keyword_lines', methods=['POST'])
def detect_keyword_lines():
    data = request.json
    text = data.get("text", "")
    keywords = data.get("keywords", [])
    if not text or not keywords:
        return jsonify({"error": "Text and keywords are required"}), 400
    
    lines_with_keywords = [line for line in text.splitlines() if any(keyword in line for keyword in keywords)]
    
    return jsonify({"lines_with_keywords": lines_with_keywords})
from collections import Counter

@main.route('/word_frequency', methods=['POST'])
def word_frequency():
    data = request.json
    text = data.get("text", "")
    if not text:
        return jsonify({"error": "Text input is required"}), 400
    
    words = text.split()
    word_count = Counter(words)
    
    return jsonify({"word_frequency": dict(word_count)})






































if __name__ == '__main__':
    app.run(debug=True)
