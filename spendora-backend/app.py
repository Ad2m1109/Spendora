from flask import Flask
from flask_cors import CORS
from config import Config
from controllers.category_controller import category_blueprint

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Load configuration
app.config.from_object(Config)

# Register blueprints
app.register_blueprint(category_blueprint)

# Run the Flask app
if __name__ == "__main__":
    app.run(debug=True)