from flask import Blueprint, request, jsonify
from models.user import User
from models import db
import jwt
import datetime
import os
from services.google_auth_service import verify_google_token
from services.email_service import send_verification_email
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

    if User.find_by_email(email):
        return jsonify({"message": "User already exists"}), 400

    try:
        new_user = User(name=name, email=email, password=password)
        new_user.save_to_db()
        
        verification_code = ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))
        send_verification_email(email, verification_code)
        
        return jsonify({
            "message": "User registered successfully. Verification email sent.",
            "userId": new_user.userId,
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

    if code == expected_code:
        return jsonify({"message": "Email verified successfully"}), 200
    else:
        return jsonify({"message": "Invalid verification code"}), 400

@auth_blueprint.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not all([email, password]):
        return jsonify({"message": "Missing email or password"}), 400

    try:
        user = User.find_by_email(email)
        if not user or not user.check_password(password):
            return jsonify({"message": "Invalid credentials"}), 401

        token = jwt.encode({
            'user_id': user.userId,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)
        }, os.environ.get('SECRET_KEY', 'fallback_secret_key'), algorithm='HS256')

        return jsonify({
            "message": "Login successful",
            "userId": user.userId,
            "name": user.name,
            "email": user.email,
            "token": token
        }), 200
    except Exception as e:
        return jsonify({"message": f"Login failed: {str(e)}"}), 500

@auth_blueprint.route('/google-login', methods=['POST'])
def google_login():
    data = request.json
    token = data.get('token')
    password = data.get('password')

    if not token:
        return jsonify({'error': 'Google token is required'}), 400

    google_user = verify_google_token(token)
    if not google_user:
        return jsonify({'error': 'Invalid Google token'}), 400

    email = google_user['email']
    name = google_user['name']

    user = User.find_by_email(email)
    if user:
        jwt_token = jwt.encode({
            'user_id': user.userId,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)
        }, os.environ.get('SECRET_KEY', 'fallback_secret_key'), algorithm='HS256')

        return jsonify({
            'userId': user.userId,
            'name': user.name,
            'email': user.email,
            'token': jwt_token
        }), 200
    else:
        if not password:
            return jsonify({'error': 'Password is required for new accounts'}), 400

        try:
            new_user = User(name=name, email=email, password=password)
            new_user.save_to_db()
            
            jwt_token = jwt.encode({
                'user_id': new_user.userId,
                'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)
            }, os.environ.get('SECRET_KEY', 'fallback_secret_key'), algorithm='HS256')

            return jsonify({
                'userId': new_user.userId,
                'name': new_user.name,
                'email': new_user.email,
                'token': jwt_token
            }), 201
        except Exception as e:
            return jsonify({'error': f'Failed to create user: {str(e)}'}), 500

@auth_blueprint.route('/check-user-exists', methods=['POST'])
def check_user_exists():
    data = request.json
    email = data.get('email')

    if not email:
        return jsonify({'error': 'Email is required'}), 400

    user = User.find_by_email(email)
    return jsonify({'exists': bool(user)}), 200

@auth_blueprint.route('/send-verification-email', methods=['POST'])
def send_verification_email_route():
    data = request.get_json()
    email = data.get('email')
    code = data.get('code')

    if not all([email, code]):
        return jsonify({"message": "Missing email or code"}), 400

    try:
        send_verification_email(email, code)
        return jsonify({"message": "Verification email sent successfully"}), 200
    except Exception as e:
        print(f"Error in send-verification-email: {str(e)}")
        return jsonify({"message": f"Failed to send verification email: {str(e)}"}), 500
