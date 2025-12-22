from flask import Blueprint, request, jsonify, current_app
from models.financial_goal import FinancialGoal
from models.user import User
from models.category import Category
from models import db

goal_blueprint = Blueprint('goal', __name__)

@goal_blueprint.route('', methods=['POST'])
def create_goal():
    data = request.get_json()
    current_app.logger.info(f"Received data for creating goal: {data}")

    if not data or 'userId' not in data or 'goalName' not in data or 'targetAmount' not in data or 'categoryId' not in data:
        return jsonify({"message": "Missing required fields"}), 400

    try:
        user_id = int(data['userId'])
        target_amount = float(data['targetAmount'])
        current_amount = float(data.get('currentAmount', 0))
        category_id = int(data['categoryId'])
    except (ValueError, TypeError):
        return jsonify({"message": "Invalid data types for fields"}), 400

    if not User.find_by_id(user_id):
        return jsonify({"message": "User does not exist"}), 404

    if FinancialGoal.find_by_category(category_id):
        return jsonify({"message": "Category is already associated with another goal"}), 400

    try:
        new_goal = FinancialGoal(
            user_id=user_id,
            goal_name=data['goalName'],
            target_amount=target_amount,
            current_amount=current_amount,
            category_id=category_id
        )
        new_goal.save_to_db()
        return jsonify({"message": "Goal created successfully", "goal": new_goal.json()}), 201
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error creating goal: {str(e)}", exc_info=True)
        return jsonify({"message": "Failed to create goal"}), 500

@goal_blueprint.route('', methods=['GET'])
def get_goals():
    user_id = request.args.get('userId')
    if not user_id:
        return jsonify({"message": "Missing userId"}), 400

    try:
        user_id = int(user_id)
    except (ValueError, TypeError):
        return jsonify({"message": "Invalid userId"}), 400

    try:
        goals = FinancialGoal.find_by_user(user_id)
        return jsonify([goal.json() for goal in goals]), 200
    except Exception as e:
        current_app.logger.error(f"Error fetching goals: {str(e)}", exc_info=True)
        return jsonify({"message": "Failed to fetch goals"}), 500

@goal_blueprint.route('/<int:goal_id>', methods=['PUT'])
def update_goal(goal_id):
    data = request.get_json()
    if not data or 'currentAmount' not in data:
        return jsonify({"message": "Missing currentAmount"}), 400

    try:
        current_amount = float(data['currentAmount'])
    except (ValueError, TypeError):
        return jsonify({"message": "Invalid currentAmount"}), 400

    try:
        goal = FinancialGoal.find_by_id(goal_id)
        if not goal:
            return jsonify({"message": "Goal not found"}), 404

        goal.currentAmount = current_amount
        goal.save_to_db()
        return jsonify({"message": "Goal updated successfully"}), 200
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error updating goal: {str(e)}", exc_info=True)
        return jsonify({"message": "Failed to update goal"}), 500

@goal_blueprint.route('/<int:goal_id>', methods=['DELETE'])
def delete_goal(goal_id):
    try:
        goal = FinancialGoal.find_by_id(goal_id)
        if not goal:
            return jsonify({"message": "Goal not found"}), 404

        goal.delete_from_db()
        return jsonify({"message": "Goal deleted successfully"}), 200
    except Exception as e:
        db.session.rollback()
        current_app.logger.error(f"Error deleting goal: {str(e)}", exc_info=True)
        return jsonify({"message": "Failed to delete goal"}), 500
