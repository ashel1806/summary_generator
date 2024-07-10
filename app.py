from flask import Flask, request, jsonify
from summary_generator import generate_summary

app = Flask(__name__)

@app.route('/resumir', methods=['POST'])
def resumir():
    data = request.get_json()
    text = data.get('texto')
    num_sentences = data.get('num_sentences', 3)
    summary = generate_summary(text, num_sentences)
    return jsonify({'resumen': summary})

if __name__ == '__main__':
    app.run(debug=True)
