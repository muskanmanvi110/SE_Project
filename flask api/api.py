from flask import Flask, request, jsonify
import pandas as pd

app = Flask(__name__)

df = pd.read_csv(r'/Users/muskanmanvi/Desktop/data.csv')

def recommend_books(title, df):
    if title not in df['title'].values:
        return f"Book with title '{title}' not found in the dataset."
    book_category = df.loc[df['title'] == title, 'categories'].iloc[0]
    same_category_books = df[df['categories'] == book_category]
    sorted_books = same_category_books.sort_values(
        by=['ratings_count', 'average_rating'], ascending=[False, False]
    )
    input_book = df[df['title'] == title].iloc[0]
    top_books = sorted_books.head(9)
    top_books = pd.concat([input_book.to_frame().T , top_books], ignore_index=True)
    
    return top_books

@app.route('/recommendations', methods=['GET'])
def get_recommendations():
    title = request.args.get('title')
    if title:
        recommendations = recommend_books(title, df)
        return recommendations.to_json(orient="records") 
    return jsonify({"error": "No title provided"}), 400
@app.route('/')
def home():
    return "Welcome to the Book Recommendation API!"

if __name__ == '__main__':
    app.run(debug=True)
