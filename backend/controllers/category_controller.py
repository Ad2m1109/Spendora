from flask import Blueprint, jsonify, request
from models.category import Category

category_blueprint = Blueprint('category', __name__)

# Route to get all categories
@category_blueprint.route('', methods=['GET'])
def get_categories():
    try:
        categories = Category.get_all_categories()
        return jsonify(categories), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Route to add a new category
@category_blueprint.route('', methods=['POST'])
def add_category():
    try:
        data = request.get_json()
        category_name = data['categoryName']
        category_id = Category.create_category(category_name)
        return jsonify({"message": "Category added successfully", "categoryId": category_id}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Route to delete a category by ID
@category_blueprint.route('/<int:category_id>', methods=['DELETE'])
def delete_category(category_id):
    try:
        rows_deleted = Category.delete_category(category_id)
        if rows_deleted > 0:
            return jsonify({"message": "Category deleted successfully"}), 200
        return jsonify({"message": "Category not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500