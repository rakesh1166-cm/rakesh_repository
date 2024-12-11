import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'sentiment_analysis_project.settings')
django.setup()

from .models import SentimentAnalysisModel

def create_training_data():
    data = [
        {'text': 'I love this product!', 'label': 'positive'},
        {'text': 'This movie is terrible.', 'label': 'negative'},
        {'text': 'The service was excellent!', 'label': 'positive'},
        # Add more training data as needed
    ]

    for item in data:
        SentimentAnalysisModel.objects.create(text=item['text'], label=item['label'])

if __name__ == '__main__':
    create_training_data()