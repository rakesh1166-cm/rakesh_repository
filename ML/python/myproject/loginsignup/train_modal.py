import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.linear_model import LinearRegression

# Load the dataset
data = pd.read_csv('data/dataset.csv')

# Split the dataset into input (X) and target (y)
X = data['text']
y = data['summary']

# Create a vectorizer to convert text into numerical features
vectorizer = CountVectorizer()
X_vectorized = vectorizer.fit_transform(X)

# Train the linear regression model
model = LinearRegression()
model.fit(X_vectorized, y)

# Save the trained model and vectorizer for future use
model.save('data/model.pt')
vectorizer.save('data/vectorizer.pkl')