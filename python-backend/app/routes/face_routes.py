from app import app

@app.route('/recognize-face', methods=['POST'])
def recognize_face():
    # ...existing code...
    return "Face recognized"
