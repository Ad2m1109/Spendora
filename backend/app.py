from flask import Flask
from flask_cors import CORS
from sqlalchemy_utils import database_exists, create_database
from config import Config
from controllers.auth_controller import auth_blueprint  
from controllers.transaction_controller import transaction_blueprint
from controllers.category_controller import category_blueprint 
from controllers.user_controller import user_blueprint 
from controllers.goal_controller import goal_blueprint 
from models import db
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '../.env'))

# Create and configure the app
app = Flask(__name__)
CORS(app)
app.config.from_object(Config)

# --- Database and Table Auto-Creation ---
# 1. Create database if it does not exist
db_uri = app.config['SQLALCHEMY_DATABASE_URI']
if not database_exists(db_uri):
    try:
        create_database(db_uri)
        print(f"Database '{Config.MYSQL_DB}' created.")
    except Exception as e:
        print(f"Error creating database: {e}")

# 2. Initialize SQLAlchemy
db.init_app(app)

# 3. Register Blueprints
app.config['UPLOAD_FOLDER'] = Config.UPLOAD_FOLDER
app.static_folder = os.path.join(os.path.dirname(__file__), 'static')
app.register_blueprint(auth_blueprint, url_prefix='/auth')
app.register_blueprint(transaction_blueprint, url_prefix='/transactions')
app.register_blueprint(category_blueprint, url_prefix='/categories')
app.register_blueprint(user_blueprint, url_prefix='/users') 
app.register_blueprint(goal_blueprint, url_prefix='/goals')

# 4. Create tables from models if they don't exist
with app.app_context():
    try:
        db.create_all()
        print("Tables created successfully (if they didn't exist).")
    except Exception as e:
        print(f"Error creating tables: {e}")

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)