from flask import Flask
from flask_cors import CORS
from config import Config
from controllers.auth_controller import auth_blueprint  
from controllers.transaction_controller import transaction_blueprint
from controllers.category_controller import category_blueprint  # Import the category blueprint
from controllers.user_controller import user_blueprint  # Import the user blueprint
import os

# Initialize Flask app
app = Flask(__name__)
CORS(app)
app.config.from_object(Config)
app.config['UPLOAD_FOLDER'] = Config.UPLOAD_FOLDER  # Use the UPLOAD_FOLDER configuration

# Ensure the static folder is configured for serving default images
app.static_folder = os.path.join(os.path.dirname(__file__), 'static')

# Register blueprints with URL prefixes
app.register_blueprint(auth_blueprint, url_prefix='/auth')
app.register_blueprint(transaction_blueprint, url_prefix='/transactions')
app.register_blueprint(category_blueprint, url_prefix='/categories')  # Register the category blueprint
app.register_blueprint(user_blueprint, url_prefix='/users')  # Register the user blueprint

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)