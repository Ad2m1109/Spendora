from flask import Blueprint, jsonify, request
from models.category import Category
from models import db

category_blueprint = Blueprint('category', __name__)

@category_blueprint.route('', methods=['GET'])
def get_categories():
    try:
        categories = Category.get_all()
        return jsonify([category.json() for category in categories]), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@category_blueprint.route('', methods=['POST'])
def add_category():
    data = request.get_json()
    if not data or 'categoryName' not in data:
        return jsonify({"error": "Missing categoryName"}), 400

    category_name = data['categoryName']

    if Category.find_by_name(category_name):
        return jsonify({"error": "Category with this name already exists"}), 400

    try:
        new_category = Category(category_name=category_name)
        new_category.save_to_db()
        return jsonify({"message": "Category added successfully", "category": new_category.json()}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500

@category_blueprint.route('/<int:category_id>', methods=['DELETE'])
def delete_category(category_id):
    try:
        category = Category.find_by_id(category_id)
        if category:
            category.delete_from_db()
            return jsonify({"message": "Category deleted successfully"}), 200
        return jsonify({"message": "Category not found"}), 404
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500
