import requests

image_path = "test.jpg"  # Replace with your image filename

try:
    with open(image_path, 'rb') as img:
        response = requests.post(
            "https://kisankit-backend.onrender.com/predict",
            files={"image": img},
            timeout=30
        )
    
    print("Status Code:", response.status_code)
    print("Response Text:", response.text)
    try:
        print("Response JSON:", response.json())
    except requests.exceptions.JSONDecodeError:
        print("Error: Response is not valid JSON")

except requests.exceptions.ConnectTimeout:
    print("Error: Connection timed out. Check if the server is running and accessible.")
except requests.exceptions.RequestException as e:
    print(f"Error: Request failed: {e}")
except FileNotFoundError:
    print(f"Error: Image file {image_path} not found.")