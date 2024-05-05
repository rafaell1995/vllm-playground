from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)

@app.route('/analyze-text', methods=['POST'])
def analyze_text():
    data = request.get_json()
    text = data.get('text')
    if text:
        # Supondo que 'analyze' seja um método fornecido por vllm
        analysis = vllm.analyze(text)
        return jsonify(analysis)
    return jsonify({"error": "No text provided"}), 400

if __name__ == '__main__':
    app.run(debug=True)