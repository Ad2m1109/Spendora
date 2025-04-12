from flask import Blueprint, request, jsonify
from models.user import User
import bcrypt
import jwt
import datetime
import os
from services.google_auth_service import verify_google_token
from services.email_service import send_verification_email  # Ensure this is the correct import
import random
import string

auth_blueprint = Blueprint('auth', __name__)

@auth_blueprint.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')

    if not all([name, email, password]):
        return jsonify({"message": "Missing required fields"}), 400

    existing_user = User.get_user_by_email(email)
    if existing_user:
        return jsonify({"message": "User already exists"}), 400

    try:
        user_id = User.create_user(name, email, password)
        verification_code = ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))
        send_verification_email(email, verification_code)
        return jsonify({
            "message": "User registered successfully. Verification email sent.",
            "userId": user_id,
            "verificationCode": verification_code 
        }), 201
    except Exception as e:
        return jsonify({"message": f"Registration failed: {str(e)}"}), 500

@auth_blueprint.route('/verify-email', methods=['POST'])
def verify_email():
    data = request.get_json()
    email = data.get('email')
    code = data.get('code')
    expected_code = data.get('expectedCode') 

    if not all([email, code, expected_code]):
        return jsonify({"message": "Missing email, code, or expected code"}), 400

    # Verify the code
    if code == expected_code:
        return jsonify({"message": "Email verified successfully"}), 200
    else:
        return jsonify({"message": "Invalid verification code"}), 400

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
        if not user:
            return jsonify({"message": "Invalid credentials"}), 401

        # Check if password matches
        if not bcrypt.checkpw(password.encode('utf-8'), user['password'].encode('utf-8')):
            return jsonify({"message": "Invalid credentials"}), 401

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
    except Exception as e:
        return jsonify({"message": f"Login failed: {str(e)}"}), 500

@auth_blueprint.route('/google-login', methods=['POST'])
def google_login():
    data = request.json
    token = data.get('token')
    password = data.get('password')  # Accept password from the frontend

    if not token:
        return jsonify({'error': 'Google token is required'}), 400

    # Verify Google token
    google_user = verify_google_token(token)
    if not google_user:
        return jsonify({'error': 'Invalid Google token'}), 400

    email = google_user['email']
    name = google_user['name']

    # Check if user exists
    user = User.get_user_by_email(email)
    if user:
        # Generate JWT token for existing user
        token = jwt.encode({
            'user_id': user['userId'],
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)
        }, os.environ.get('SECRET_KEY', 'fallback_secret_key'), algorithm='HS256')

        return jsonify({
            'userId': user['userId'],
            'name': user['name'],
            'email': user['email'],
            'token': token
        }), 200
    else:
        # Create a new user with the provided password
        if not password:
            return jsonify({'error': 'Password is required for new accounts'}), 400

        try:
            user_id = User.create_user(name, email, password)
            token = jwt.encode({
                'user_id': user_id,
                'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)
            }, os.environ.get('SECRET_KEY', 'fallback_secret_key'), algorithm='HS256')

            return jsonify({
                'userId': user_id,
                'name': name,
                'email': email,
                'token': token
            }), 201
        except Exception as e:
            return jsonify({'error': f'Failed to create user: {str(e)}'}), 500

@auth_blueprint.route('/check-user-exists', methods=['POST'])
def check_user_exists():
    data = request.json
    email = data.get('email')

    if not email:
        return jsonify({'error': 'Email is required'}), 400

    # Use the database method to check if the user exists
    user = User.get_user_by_email(email)
    return jsonify({'exists': bool(user)}), 200

@auth_blueprint.route('/send-verification-email', methods=['POST'])
def send_verification_email_route():  # Renamed to avoid conflict
    data = request.get_json()
    email = data.get('email')
    code = data.get('code')

    if not all([email, code]):
        return jsonify({"message": "Missing email or code"}), 400

    try:
        send_verification_email(email, code)  # Call the imported function
        return jsonify({"message": "Verification email sent successfully"}), 200
    except Exception as e:
        print(f"Error in send-verification-email: {str(e)}")
        return jsonify({"message": f"Failed to send verification email: {str(e)}"}), 500