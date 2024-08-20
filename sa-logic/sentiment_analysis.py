from textblob import TextBlob
from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
import nltk

# Download the NLTK data
nltk.download('punkt')

app = Flask(__name__)
CORS(app) 

SPRING_BOOT_HEALTH_URL = "http://sa-java:8080/testHealth"

@app.route("/testHealth")
def hello():
 return "Hello from python sentiment analysis flask app!"

@app.route("/analyse/sentiment", methods=['POST'])
def analyse_sentiment():
    sentence = request.get_json()['sentence']
    polarity = TextBlob(sentence).sentences[0].polarity
    return jsonify(
     sentence=sentence, polarity=polarity
     )
# use + for spaces, i.e. http://localhost:5000/analyse?sentence=i+am+so+happy!
@app.route("/analyse", methods=['GET'])
def analyse_sentiment_get():
    #data = request.get_json()
    # #sentence = data['sentence']

    sentence = request.args.get('sentence')
    polarity = TextBlob(sentence).sentences[0].polarity
    return str(polarity)



@app.route("/testCommsLocal", methods=['GET'])
def check_frontend_health():
    try:
        response = requests.get(SPRING_BOOT_HEALTH_URL)
        if response.status_code == 200:
            return response.text
        else:
            return jsonify({"status": "Frontend is not healthy", "message": response.text}), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({"status": "Error", "message": str(e)}), 500


if __name__ == '__main__':
 app.run(host='0.0.0.0', port=8443)