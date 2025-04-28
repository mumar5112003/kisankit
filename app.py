from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
import numpy as np
from PIL import Image
import io

app = Flask(__name__)

# Load the trained model
model = load_model("trained_model.keras")

# Load class labels
with open("labels.txt", "r") as f:
    labels = f.read().splitlines()

# Preprocessing function
def preprocess_image(image_bytes):
    img = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    img = img.resize((150, 150))
    img = np.array(img)  # NOTE: do NOT normalize unless training used rescale=1./255
    return np.expand_dims(img, axis=0)  # Shape: (1, 150, 150, 3)

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400

    try:
        # Read image
        image_bytes = request.files['image'].read()
        processed_image = preprocess_image(image_bytes)

        # Predict
        prediction = model.predict(processed_image)[0]  # Get first (and only) batch

        # Find top class
        top_index = int(np.argmax(prediction))
        confidence = float(prediction[top_index])
        label = labels[top_index]

        return jsonify({
            'label': label,
            'confidence': round(confidence * 100, 2)  # percentage
        })

    except Exception as e:
        return jsonify({'error': f'Prediction failed: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(host='192.168.100.176', port=5000, debug=True)
