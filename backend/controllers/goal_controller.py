from flask import Blueprint, request, jsonify
from models.financial_goal import FinancialGoal

goal_blueprint = Blueprint('goal', __name__)

@goal_blueprint.route('/goals', methods=['POST'])
def create_goal():
    data = request.get_json()
    user_id = data['userId']
    goal_name = data['goalName']
    target_amount = data['targetAmount']

    goal_id = FinancialGoal.create_goal(user_id, goal_name, target_amount)
    return jsonify({"message": "Goal created successfully", "goalId": goal_id}), 201

@goal_blueprint.route('/goals/<int:user_id>', methods=['GET'])
def get_goals(user_id):
    goals = FinancialGoal.get_goals_by_user(user_id)
    return jsonify(goals), 200

@goal_blueprint.route('/goals/<int:goal_id>', methods=['PUT'])
def update_goal(goal_id):
    data = request.get_json()
    current_amount = data['currentAmount']

    rows_updated = FinancialGoal.update_goal_progress(goal_id, current_amount)
    if rows_updated > 0:
        return jsonify({"message": "Goal updated successfully"}), 200
    return jsonify({"message": "Goal not found"}), 404

@goal_blueprint.route('/goals/<int:goal_id>', methods=['DELETE'])
def delete_goal(goal_id):
    rows_deleted = FinancialGoal.delete_goal(goal_id)
    if rows_deleted > 0:
        return jsonify({"message": "Goal deleted successfully"}), 200
    return jsonify({"message": "Goal not found"}), 404