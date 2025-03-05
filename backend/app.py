from flask import Flask
from flask_cors import CORS
from config import Config
from controllers.auth_controller import auth_blueprint  # Ensure the correct import

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Register the blueprint with the correct URL prefix
app.register_blueprint(auth_blueprint, url_prefix='/auth')  # Ensure the prefix is correct

# Load configuration
app.config.from_object(Config)

# Run the Flask app
if __name__ == "__main__":
    app.run(debug=True)
