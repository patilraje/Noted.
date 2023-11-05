# -*- coding: utf-8 -*-
"""trainmodel.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/15CjmGomAMOPAW803CwJgEBg_LefdMtv0
"""

import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import accuracy_score, classification_report

from google.colab import drive
drive.mount('/content/drive')

# Step 1: Load and combine your datasets
chemistry_df = pd.read_csv('/content/drive/MyDrive/chemistry - Sheet1.csv')
physics_df = pd.read_csv('/content/drive/MyDrive/physics - Sheet1.csv')
#computer_science_df = pd.read_csv("computer_science_notes.csv")
#history_df = pd.read_csv("history_notes.csv")
#music_df = pd.read_csv("music_notes.csv")

# Concatenate the datasets into one comprehensive dataset
combined_df = pd.concat([chemistry_df, physics_df]) #,computer_science_df, history_df, music_df])

print(combined_df.head())
print(combined_df.columns)

X = combined_df['Keywords']  # Input features (notes)
y = combined_df['Subject']   # Target labels (subjects)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42) #test size is 20% for now

X_train.fillna('', inplace=True)  # Replace NaN values with empty strings

# Handle missing values in X_test
X_test.fillna('', inplace=True)  # Replace NaN values with empty strings

# Perform TF-IDF vectorization
X_test_tfidf = tfidf_vectorizer.transform(X_test)

# Step 3: Text Vectorization using TF-IDF
tfidf_vectorizer = TfidfVectorizer(max_features=5000, stop_words='english')
X_train_tfidf = tfidf_vectorizer.fit_transform(X_train)
X_test_tfidf = tfidf_vectorizer.transform(X_test)

# Step 4: Train a Multinomial Naive Bayes Classifier
classifier = MultinomialNB()
classifier.fit(X_train_tfidf, y_train)

# Step 5: Make predictions on the test set
y_pred = classifier.predict(X_test_tfidf)

# Step 6: Evaluate the model
accuracy = accuracy_score(y_test, y_pred)
print("Accuracy:", accuracy)

# Generate a classification report for detailed metrics
report = classification_report(y_test, y_pred, target_names=combined_df['Subject'].unique())
print(report)

# Step 7: Predict the subject of a new note
new_note = ["Learn about general relativity and black holes."]
new_note_tfidf = tfidf_vectorizer.transform(new_note)
predicted_subject = classifier.predict(new_note_tfidf)
print("Predicted Subject:", predicted_subject[0])