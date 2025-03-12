from flask import Flask
from flask_cors import CORS
from config import Config
from controllers.auth_controller import auth_blueprint  
from controllers.transaction_controller import transaction_blueprint

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes
app.config.from_object(Config)
# Register blueprints with URL prefixes
app.register_blueprint(auth_blueprint, url_prefix='/auth')
app.register_blueprint(transaction_blueprint, url_prefix='/transactions') 

if __name__ == "__main__":
    # Run the app in debug mode during development
    # In production, set debug=False and use a production-ready server (e.g., Gunicorn)
    app.run(debug=True, host='0.0.0.0', port=5000)