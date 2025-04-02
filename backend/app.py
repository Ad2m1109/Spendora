from flask import Flask
from flask_cors import CORS
from config import Config
from controllers.auth_controller import auth_blueprint  
from controllers.transaction_controller import transaction_blueprint
from controllers.category_controller import category_blueprint 
from controllers.user_controller import user_blueprint 
from controllers.goal_controller import goal_blueprint 
import os
from dotenv import load_dotenv  # Import load_dotenv

# Explicitly load the .env file
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '../.env'))

# DEBUG: Print environment variable
print(f"DEBUG: EMAIL_APP_PASSWORD={os.getenv('EMAIL_APP_PASSWORD')}")

# Initialize Flask app
app = Flask(__name__)
CORS(app)
app.config.from_object(Config)
app.config['UPLOAD_FOLDER'] = Config.UPLOAD_FOLDER
app.static_folder = os.path.join(os.path.dirname(__file__), 'static')
app.register_blueprint(auth_blueprint, url_prefix='/auth')
app.register_blueprint(transaction_blueprint, url_prefix='/transactions')
app.register_blueprint(category_blueprint, url_prefix='/categories')
app.register_blueprint(user_blueprint, url_prefix='/users') 
app.register_blueprint(goal_blueprint, url_prefix='/goals')

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)