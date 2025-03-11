from flask import Blueprint, request, jsonify
from models.user import User
import bcrypt
import jwt  # Ensure this is PyJWT
import datetime
import os

auth_blueprint = Blueprint('auth', __name__)

@auth_blueprint.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')

    # Input validation
    if not all([name, email, password]):
        return jsonify({"message": "Missing required fields"}), 400

    # Check if user already exists
    existing_user = User.get_user_by_email(email)
    if existing_user:
        return jsonify({"message": "User already exists"}), 400
    
    try:
        user_id = User.create_user(name, email, password)
        return jsonify({"message": "User registered successfully", "userId": user_id}), 201
    except Exception as e:
        return jsonify({"message": f"Registration failed: {str(e)}"}), 500

@auth_blueprint.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    # Input validation
    if not all([email, password]):
        return jsonify({"message": "Missing email or password"}), 400

    try:
        # Retrieve user by email
        user = User.get_user_by_email(email)
        print(f'User retrieved: {user}')  # Debug print

        # Check if user exists and password is correct
        if user and bcrypt.checkpw(password.encode('utf-8'), user['password'].encode('utf-8')):
            # Generate JWT token
            token = jwt.encode({
                'user_id': user['userId'],
                'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)
            }, os.environ.get('SECRET_KEY', 'fallback_secret_key'), algorithm='HS256')

            return jsonify({
                "message": "Login successful", 
                "userId": user['userId'],
                "name": user['name'],  
                "email": user['email'], 
                "token": token
            }), 200
        else:
            return jsonify({"message": "Invalid credentials"}), 401

    except Exception as e:
        return jsonify({"message": f"Login failed: {str(e)}"}), 500