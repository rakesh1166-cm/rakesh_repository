import os
import django
import nltk
import random
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.classify import NaiveBayesClassifier
from .models import SentimentAnalysisModel


os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
django.setup()

def preprocess_data(text):
    stop_words = set(stopwords.words('english'))
    words = word_tokenize(text.lower())
    filtered_words = [word for word in words if word.isalpha() and word not in stop_words]
    return dict([(word, True) for word in filtered_words])

def get_training_data():
    print("get_training_data is here")
    positive_data = [(preprocess_data(item.text), 'positive') for item in SentimentAnalysisModel.objects.filter(label='positive')]
    negative_data = [(preprocess_data(item.text), 'negative') for item in SentimentAnalysisModel.objects.filter(label='negative')]
    training_data = positive_data + negative_data
    random.shuffle(training_data)
    return training_data

def train_classifier():
    print("train_classifier is here")
    training_data = get_training_data()
    
    classifier = NaiveBayesClassifier.train(training_data)
    print("NaiveBayesClassifier is here")
    return classifier

def perform_sentiment_analysis(text):
    print(text)
    print("perform_sentiment_analysis data is here")
    classifier = train_classifier()
    preprocessed_text = preprocess_data(text)
    sentiment = classifier.classify(preprocessed_text)
    return sentiment

if __name__ == '__main__':
    nltk.download('punkt')
    nltk.download('stopwords')
    sentiment = perform_sentiment_analysis('This product is amazing!')
    print(sentiment)