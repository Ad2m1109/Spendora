from flask import Blueprint, jsonify, request
from models.category import Category

category_blueprint = Blueprint('category', __name__)

# Route to get all categories
@category_blueprint.route('/categories', methods=['GET'])
def get_categories():
    try:
        categories = Category.get_all_categories()
        return jsonify(categories), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Route to add a new category
@category_blueprint.route('/categories', methods=['POST'])
def add_category():
    try:
        data = request.get_json()
        category_name = data['categoryName']
        category_id = Category.create_category(category_name)
        return jsonify({"message": "Category added successfully", "categoryId": category_id}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Route to delete a category by ID
@category_blueprint.route('/categories/<int:category_id>', methods=['DELETE'])
def delete_category(category_id):
    try:
        # Add logic to delete a category (you'll need to implement this in the Category model)
        return jsonify({"message": "Category deleted successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500