from flask import Blueprint, request, jsonify
from models.transaction import Transaction

transaction_blueprint = Blueprint('transaction', __name__)

@transaction_blueprint.route('', methods=['POST'])
def create_transaction():
    try:
        data = request.get_json()

        # Validate required fields
        if not data or 'userId' not in data or 'amount' not in data or 'date' not in data or 'categoryId' not in data:
            return jsonify({"message": "Missing required fields"}), 400

        user_id = data['userId']
        amount = data['amount']
        date = data['date']
        description = data.get('description', '')
        category_id = data['categoryId']

        # Create the transaction
        transaction_id = Transaction.create_transaction(user_id, amount, date, description, category_id)
        return jsonify({"message": "Transaction created successfully", "transactionId": transaction_id}), 201

    except Exception as e:
        print(f"Error creating transaction: {str(e)}")  # Debug log
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/get', methods=['POST'])
def get_transactions():
    try:
        data = request.get_json()
        user_id = data.get('userId')

        if not user_id:
            return jsonify({"message": "Missing userId"}), 400

        print(f"Fetching transactions for userId: {user_id}")  # Debug log
        transactions = Transaction.get_transactions_by_user(user_id)
        print(f"Transactions fetched: {transactions}")  # Debug log
        return jsonify(transactions), 200
    except Exception as e:
        print(f"Error fetching transactions: {str(e)}")  # Debug log
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/<int:transaction_id>', methods=['PUT'])
def update_transaction(transaction_id):
    try:
        data = request.get_json()

        # Validate required fields
        if not data or 'amount' not in data or 'date' not in data or 'categoryId' not in data:
            return jsonify({"message": "Missing required fields"}), 400

        amount = data['amount']
        date = data['date']
        description = data.get('description', '')
        category_id = data['categoryId']

        # Update the transaction
        rows_updated = Transaction.update_transaction(transaction_id, amount, date, description, category_id)
        if rows_updated > 0:
            return jsonify({"message": "Transaction updated successfully"}), 200
        return jsonify({"message": "Transaction not found"}), 404

    except Exception as e:
        print(f"Error updating transaction: {str(e)}")  # Debug log
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/<int:transaction_id>', methods=['DELETE'])
def delete_transaction(transaction_id):
    try:
        rows_deleted = Transaction.delete_transaction(transaction_id)
        if rows_deleted > 0:
            return jsonify({"message": "Transaction deleted successfully"}), 200
        return jsonify({"message": "Transaction not found"}), 404
    except Exception as e:
        print(f"Error deleting transaction: {str(e)}")  # Debug log
        return jsonify({"message": str(e)}), 500