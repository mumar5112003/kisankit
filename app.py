# from flask import Flask, request, jsonify
# from tensorflow.keras.models import load_model
# import numpy as np
# from PIL import Image
# import io

# app = Flask(__name__)

# # Load the trained model
# model = load_model("trained_model.keras")

# # Load class labels
# with open("labels.txt", "r") as f:
#     labels = f.read().splitlines()

# # Preprocessing function
# def preprocess_image(image_bytes):
#     img = Image.open(io.BytesIO(image_bytes)).convert('RGB')
#     img = img.resize((150, 150))
#     img = np.array(img)  # NOTE: do NOT normalize unless training used rescale=1./255
#     return np.expand_dims(img, axis=0)  # Shape: (1, 150, 150, 3)

# @app.route('/predict', methods=['POST'])
# def predict():
#     if 'image' not in request.files:
#         return jsonify({'error': 'No image uploaded'}), 400

#     try:
#         # Read image
#         image_bytes = request.files['image'].read()
#         processed_image = preprocess_image(image_bytes)

#         # Predict
#         prediction = model.predict(processed_image)[0]  # Get first (and only) batch

#         # Find top class
#         top_index = int(np.argmax(prediction))
#         confidence = float(prediction[top_index])
#         label = labels[top_index]
#         # if confidence < 0.50:
#         #     return jsonify({
#         #     'label': "Tungro",
#         #     'confidence': round(0.7638 * 100, 2)  # percentage
#         # })

#         return jsonify({
#             'label': label,
#             'confidence': round(confidence * 100, 2)  # percentage
#         })

#     except Exception as e:
#         return jsonify({'error': f'Prediction failed: {str(e)}'}), 500

# if __name__ == '__main__':
#     app.run(host='10.135.64.167', port=5000, debug=True)
from flask import Flask, request, jsonify
import torch
import torch.nn as nn
from PIL import Image
import io
import numpy as np
from torchvision import transforms, models

app = Flask(__name__)

# Load class labels to determine number of classes
with open("labels.txt", "r") as f:
    labels = f.read().splitlines()
num_classes = len(labels)

# Initialize the ResNet50 model
model = models.resnet50(pretrained=False)  # Load without pre-trained weights
model.fc = nn.Linear(model.fc.in_features, num_classes)  # Adjust final layer for num_classes

# Load the state dictionary
state_dict = torch.load("best_model.pth", map_location=torch.device('cpu'))
model.load_state_dict(state_dict)
model.eval()  # Set model to evaluation mode
device = torch.device('cpu')  # Use CPU explicitly
model.to(device)

# Preprocessing function
def preprocess_image(image_bytes):
    img = Image.open(io.BytesIO(image_bytes)).convert('RGB')
    img = img.resize((150, 150))
    
    # Define PyTorch transforms
    transform = transforms.Compose([
        transforms.ToTensor(),  # Converts to (C, H, W) and normalizes to [0, 1]
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])  # Standard ImageNet normalization
    ])
    
    # Apply transforms
    img = transform(img)
    return img.unsqueeze(0)  # Add batch dimension: (1, C, H, W)

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400

    try:
        # Read image
        image_bytes = request.files['image'].read()
        processed_image = preprocess_image(image_bytes).to(device)

        # Predict
        with torch.no_grad():  # Disable gradient computation for inference
            prediction = model(processed_image)
            prediction = torch.softmax(prediction, dim=1)[0]  # Apply softmax to get probabilities

        # Find top class
        top_index = int(torch.argmax(prediction).item())
        confidence = float(prediction[top_index].item())
        label = labels[top_index]

        return jsonify({
            'label': label,
            'confidence': round(confidence * 100, 2)  # percentage
        })

    except Exception as e:
        return jsonify({'error': f'Prediction failed: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(host='10.135.80.139', port=5000, debug=True)