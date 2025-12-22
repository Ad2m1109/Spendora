from flask import Blueprint, jsonify, request, current_app, send_from_directory
from models.user import User
from models import db
import os
from werkzeug.utils import secure_filename
import logging

logger = logging.getLogger(__name__)

user_blueprint = Blueprint('user', __name__)

@user_blueprint.route('/<int:user_id>', methods=['GET'])
def get_user_profile(user_id):
    try:
        user = User.find_by_id(user_id)
        if user:
            return jsonify(user.json()), 200
        return jsonify({"message": "User not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@user_blueprint.route('/<int:user_id>', methods=['PUT'])
def update_user_profile(user_id):
    data = request.get_json()
    name = data.get('name')
    email = data.get('email')

    if not all([name, email]):
        return jsonify({"message": "Missing required fields"}), 400

    try:
        user = User.find_by_id(user_id)
        if not user:
            return jsonify({"message": "User not found"}), 404

        user.name = name
        user.email = email
        user.save_to_db()
        
        return jsonify({"message": "User profile updated successfully"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

@user_blueprint.route('/<int:user_id>/upload', methods=['POST'])
def upload_profile_picture(user_id):
    if 'file' not in request.files:
        return jsonify({"message": "No file part"}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({"message": "No selected file"}), 400
    if file:
        filename = secure_filename(f"profile_{user_id}.jpg")
        upload_folder = os.path.join(current_app.root_path, 'uploads')
        logger.info(f"Saving file to: {os.path.join(upload_folder, filename)}")
        
        if not os.path.exists(upload_folder):
            os.makedirs(upload_folder)
        file.save(os.path.join(upload_folder, filename))
        return jsonify({"message": "Profile picture uploaded successfully"}), 200

@user_blueprint.route('/uploads/<filename>', methods=['GET'])
def serve_user_image(filename):
    try:
        upload_folder = os.path.join(current_app.root_path, 'uploads')
        filepath = os.path.join(upload_folder, filename)
        
        logger.info(f"Looking for image at: {filepath}")
        
        if not os.path.exists(filepath):
            logger.error(f"Image not found at: {filepath}")
            default_image_path = os.path.join(current_app.root_path, 'static', 'default_profile.jpg')
            if os.path.exists(default_image_path):
                return send_from_directory(os.path.join(current_app.root_path, 'static'), 'default_profile.jpg', mimetype='image/jpeg')
            return jsonify({"message": "Image not found"}), 404
            
        return send_from_directory(upload_folder, filename, mimetype='image/jpeg')
    except Exception as e:
        logger.error(f"Error serving image {filename}: {str(e)}")
        return jsonify({"error": str(e)}), 500
