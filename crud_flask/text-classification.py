from flask import Flask, request, jsonify
from flask_cors import CORS
from textblob import TextBlob
import spacy
from transformers import pipeline
import openai
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB
import fasttext

app = Flask(__name__)
CORS(app)

# Initialize libraries
nlp_spacy = spacy.load("en_core_web_sm")
openai.api_key = "your-openai-api-key"

# Pre-trained FastText model (optional)
fasttext_model = fasttext.load_model("cc.en.300.bin")

# Text Classification Functions
def textblob_classification(text, classification_type):
    # TextBlob doesn't directly support classification; placeholder
    return f"TextBlob Classification: {classification_type} - Not Implemented"

def spacy_classification(text, classification_type):
    doc = nlp_spacy(text)
    return f"SpaCy Classification: {classification_type} - {doc.cats}"

def nltk_classification(text, classification_type):
    # Placeholder for NLTK-based classification logic
    return f"NLTK Classification: {classification_type} - Not Implemented"

def huggingface_classification(text, classification_type):
    classifier = pipeline("zero-shot-classification", model="facebook/bart-large-mnli")
    labels = ["spam", "ham"] if classification_type == "spam_detection" else ["topic1", "topic2"]
    result = classifier(text, candidate_labels=labels)
    return result

def openai_classification(text, classification_type):
    prompt = f"Classify the following text into {classification_type}: {text}"
    response = openai.Completion.create(
        engine="text-davinci-003", prompt=prompt, max_tokens=500
    )
    return response["choices"][0]["text"].strip()

def scikit_learn_classification(text, classification_type):
    vectorizer = CountVectorizer()
    classifier = MultinomialNB()

    # Training data (replace with actual data)
    train_texts = ["spam text", "ham text"]
    train_labels = ["spam", "ham"]

    # Fit the model
    vectors = vectorizer.fit_transform(train_texts)
    classifier.fit(vectors, train_labels)

    # Predict
    prediction = classifier.predict(vectorizer.transform([text]))
    return prediction[0]

def fasttext_classification(text, classification_type):
    prediction = fasttext_model.predict(text)
    return prediction[0]

@app.route("/text_classification", methods=["POST"])
def text_classification():
    data = request.json
    text = data.get("text")
    classification_type = data.get("classification_type")
    classification_method = data.get("classification_method")

    if not text or not classification_type or not classification_method:
        return jsonify({"error": "Text, classification_type, and classification_method are required"}), 400

    try:
        result = ""
        if classification_method == "textblob":
            result = textblob_classification(text, classification_type)
        elif classification_method == "spacy":
            result = spacy_classification(text, classification_type)
        elif classification_method == "nltk":
            result = nltk_classification(text, classification_type)
        elif classification_method == "huggingface":
            result = huggingface_classification(text, classification_type)
        elif classification_method == "openai":
            result = openai_classification(text, classification_type)
        elif classification_method == "scikit_learn":
            result = scikit_learn_classification(text, classification_type)
        elif classification_method == "fasttext":
            result = fasttext_classification(text, classification_type)
        else:
            return jsonify({"error": "Invalid classification method"}), 400

        return jsonify({"result": result})

    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"}), 500

if __name__ == "__main__":
    app.run(debug=True)
