from flask import Blueprint, request, jsonify
from models.transaction import Transaction

transaction_blueprint = Blueprint('transaction', __name__)

@transaction_blueprint.route('/transactions', methods=['POST'])
def create_transaction():
    data = request.get_json()
    user_id = data['userId']
    amount = data['amount']
    date = data['date']
    description = data.get('description', '')
    category_id = data['categoryId']

    transaction_id = Transaction.create_transaction(user_id, amount, date, description, category_id)
    return jsonify({"message": "Transaction created successfully", "transactionId": transaction_id}), 201

@transaction_blueprint.route('/transactions/<int:user_id>', methods=['GET'])
def get_transactions(user_id):
    transactions = Transaction.get_transactions_by_user(user_id)
    return jsonify(transactions), 200

@transaction_blueprint.route('/transactions/<int:transaction_id>', methods=['PUT'])
def update_transaction(transaction_id):
    data = request.get_json()
    amount = data['amount']
    date = data['date']
    description = data.get('description', '')
    category_id = data['categoryId']

    rows_updated = Transaction.update_transaction(transaction_id, amount, date, description, category_id)
    if rows_updated > 0:
        return jsonify({"message": "Transaction updated successfully"}), 200
    return jsonify({"message": "Transaction not found"}), 404

@transaction_blueprint.route('/transactions/<int:transaction_id>', methods=['DELETE'])
def delete_transaction(transaction_id):
    rows_deleted = Transaction.delete_transaction(transaction_id)
    if rows_deleted > 0:
        return jsonify({"message": "Transaction deleted successfully"}), 200
    return jsonify({"message": "Transaction not found"}), 404