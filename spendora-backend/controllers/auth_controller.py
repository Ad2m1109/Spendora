from flask import Blueprint, request, jsonify
from models.user import User
import bcrypt

auth_blueprint = Blueprint('auth', __name__)

@auth_blueprint.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    name = data['name']
    email = data['email']
    password = data['password']
    user_id = User.create_user(name, email, password)
    return jsonify({"message": "User registered successfully", "userId": user_id}), 201

@auth_blueprint.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data['email']
    password = data['password']
    user = User.get_user_by_email(email)
    if user and bcrypt.checkpw(password.encode('utf-8'), user['password'].encode('utf-8')):
        return jsonify({"message": "Login successful", "userId": user['userId']}), 200
    return jsonify({"message": "Invalid credentials"}), 401
