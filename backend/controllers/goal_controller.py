from flask import Blueprint, request, jsonify, current_app
from models.financial_goal import FinancialGoal

goal_blueprint = Blueprint('goal', __name__)

def add_cors_headers(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type'
    return response

@goal_blueprint.after_request
def after_request(response):
    return add_cors_headers(response)

@goal_blueprint.route('', methods=['POST'])
def create_goal():
    try:
        data = request.get_json()
        current_app.logger.info(f"Received data for creating goal: {data}")  # Debug log

        if not data or 'userId' not in data or 'goalName' not in data or 'targetAmount' not in data or 'categoryId' not in data:
            current_app.logger.warning("Missing required fields in request data")
            return jsonify({"message": "Missing required fields"}), 400

        try:
            user_id = int(data['userId'])
            target_amount = float(data['targetAmount'])
            current_amount = float(data.get('currentAmount', 0))  # Default to 0 if not provided
            category_id = int(data['categoryId'])
            if user_id <= 0 or target_amount < 0 or current_amount < 0 or category_id <= 0:
                current_app.logger.warning(f"Invalid userId ({user_id}), targetAmount ({target_amount}), currentAmount ({current_amount}), or categoryId ({category_id})")
                raise ValueError
        except (ValueError, TypeError):
            return jsonify({"message": "Invalid userId, targetAmount, currentAmount, or categoryId"}), 400

        goal_name = data['goalName'].strip()
        if not goal_name:
            current_app.logger.warning("Goal name is empty")
            return jsonify({"message": "Goal name cannot be empty"}), 400

        # Check if the user exists
        if not FinancialGoal.user_exists(user_id):
            current_app.logger.warning(f"User with userId {user_id} does not exist")
            return jsonify({"message": "User does not exist"}), 400

        # Check if the category is already used
        if FinancialGoal.is_category_used(category_id):
            current_app.logger.warning(f"Category with categoryId {category_id} is already used in another goal")
            return jsonify({"message": "Category is already associated with another goal"}), 400

        goal_id = FinancialGoal.create_goal(user_id, goal_name, target_amount, current_amount, category_id)
        return jsonify({"message": "Goal created successfully", "id": goal_id}), 201

    except Exception as e:
        current_app.logger.error(f"Error creating goal: {str(e)}", exc_info=True)
        return jsonify({"message": "Failed to create goal"}), 500

@goal_blueprint.route('', methods=['GET'])
def get_goals():
    try:
        user_id = request.args.get('userId')
        if not user_id:
            return jsonify({"message": "Missing userId"}), 400

        try:
            user_id = int(user_id)
            if user_id <= 0:
                raise ValueError
        except (ValueError, TypeError):
            return jsonify({"message": "Invalid userId"}), 400

        goals = FinancialGoal.get_goals_by_user(user_id)
        return jsonify(goals), 200

    except Exception as e:
        current_app.logger.error(f"Error fetching goals: {str(e)}", exc_info=True)
        return jsonify({"message": "Failed to fetch goals"}), 500

@goal_blueprint.route('/<int:goal_id>', methods=['PUT'])
def update_goal(goal_id):
    try:
        if goal_id <= 0:
            return jsonify({"message": "Invalid goal ID"}), 400

        data = request.get_json()
        if not data or 'currentAmount' not in data:
            return jsonify({"message": "Missing required fields"}), 400

        try:
            current_amount = float(data['currentAmount'])
            if current_amount < 0:
                raise ValueError
        except (ValueError, TypeError):
            return jsonify({"message": "Invalid currentAmount"}), 400

        rows_updated = FinancialGoal.update_goal_progress(goal_id, current_amount)
        if rows_updated > 0:
            return jsonify({"message": "Goal updated successfully"}), 200
        return jsonify({"message": "Goal not found"}), 404

    except Exception as e:
        current_app.logger.error(f"Error updating goal: {str(e)}", exc_info=True)
        return jsonify({"message": "Failed to update goal"}), 500

@goal_blueprint.route('/<int:goal_id>', methods=['DELETE'])
def delete_goal(goal_id):
    try:
        if goal_id <= 0:
            return jsonify({"message": "Invalid goal ID"}), 400

        rows_deleted = FinancialGoal.delete_goal(goal_id)
        if rows_deleted > 0:
            return jsonify({"message": "Goal deleted successfully"}), 200
        return jsonify({"message": "Goal not found"}), 404

    except Exception as e:
        current_app.logger.error(f"Error deleting goal: {str(e)}", exc_info=True)
        return jsonify({"message": "Failed to delete goal"}), 500