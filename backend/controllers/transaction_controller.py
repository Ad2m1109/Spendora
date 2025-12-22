import matplotlib
matplotlib.use('Agg')

from flask import Blueprint, request, jsonify, send_file
from models.transaction import Transaction
from models.financial_goal import FinancialGoal
from models import db
import io
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
from datetime import datetime

transaction_blueprint = Blueprint('transaction', __name__)

@transaction_blueprint.route('', methods=['POST'])
def create_transaction():
    data = request.get_json()
    if not data or 'userId' not in data or 'amount' not in data or 'date' not in data or 'categoryId' not in data:
        return jsonify({"message": "Missing required fields"}), 400

    try:
        new_transaction = Transaction(
            user_id=data['userId'],
            amount=float(data['amount']),
            date=datetime.fromisoformat(data['date']),
            description=data.get('description', ''),
            category_id=data['categoryId']
        )
        new_transaction.save_to_db()

        # Update goal's currentAmount if the category matches
        if new_transaction.amount > 0:
            goal = FinancialGoal.find_by_category(new_transaction.categoryId)
            if goal and goal.userId == new_transaction.userId:
                goal.currentAmount += new_transaction.amount
                goal.save_to_db()

        return jsonify({"message": "Transaction created successfully", "transactionId": new_transaction.transactionId}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/get', methods=['POST'])
def get_transactions():
    data = request.get_json()
    user_id = data.get('userId')
    if not user_id:
        return jsonify({"message": "Missing userId"}), 400

    try:
        transactions = Transaction.find_by_user(user_id)
        return jsonify([t.json() for t in transactions]), 200
    except Exception as e:
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/<int:transaction_id>', methods=['PUT'])
def update_transaction(transaction_id):
    data = request.get_json()
    if not data or 'amount' not in data or 'date' not in data or 'categoryId' not in data:
        return jsonify({"message": "Missing required fields"}), 400

    try:
        transaction = Transaction.find_by_id(transaction_id)
        if not transaction:
            return jsonify({"message": "Transaction not found"}), 404

        transaction.amount = float(data['amount'])
        transaction.date = datetime.fromisoformat(data['date'])
        transaction.description = data.get('description', '')
        transaction.categoryId = data['categoryId']
        transaction.save_to_db()
        
        return jsonify({"message": "Transaction updated successfully"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/<int:transaction_id>', methods=['DELETE'])
def delete_transaction(transaction_id):
    try:
        transaction = Transaction.find_by_id(transaction_id)
        if not transaction:
            return jsonify({"message": "Transaction not found"}), 404
        
        transaction.delete_from_db()
        return jsonify({"message": "Transaction deleted successfully"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/metrics', methods=['POST'])
def get_dashboard_metrics():
    data = request.get_json()
    user_id = data.get('userId')
    if not user_id:
        return jsonify({"message": "Missing userId"}), 400

    try:
        metrics = Transaction.calculate_metrics(user_id)
        return jsonify(metrics), 200
    except Exception as e:
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/expense-categories-chart', methods=['POST'])
def get_expense_categories_chart():
    data = request.get_json()
    user_id = data.get('userId')
    if not user_id:
        return jsonify({"message": "Missing userId"}), 400

    try:
        categories_data = Transaction.get_expense_categories(user_id)
        
        labels = [item.categoryName for item in categories_data]
        values = [float(item.totalAmount) for item in categories_data]

        fig, ax = plt.subplots(figsize=(8, 8))
        ax.pie(values, labels=labels, autopct='%1.1f%%', startangle=140, textprops={'fontsize': 12})
        ax.axis('equal')

        img = io.BytesIO()
        fig.savefig(img, format='png', bbox_inches='tight')
        img.seek(0)
        plt.close(fig)
        
        return send_file(img, mimetype='image/png')
    except Exception as e:
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/income-categories-chart', methods=['POST'])
def get_income_categories_chart():
    data = request.get_json()
    user_id = data.get('userId')
    if not user_id:
        return jsonify({"message": "Missing userId"}), 400

    try:
        categories_data = Transaction.get_income_categories(user_id)
        
        labels = [item.categoryName for item in categories_data]
        values = [float(item.totalAmount) for item in categories_data]

        fig, ax = plt.subplots(figsize=(8, 8))
        ax.pie(values, labels=labels, autopct='%1.1f%%', startangle=140, textprops={'fontsize': 12})
        ax.axis('equal')

        img = io.BytesIO()
        fig.savefig(img, format='png', bbox_inches='tight')
        img.seek(0)
        plt.close(fig)
        
        return send_file(img, mimetype='image/png')
    except Exception as e:
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/daily-net-savings-chart', methods=['POST'])
def get_daily_net_savings_chart():
    data = request.get_json()
    user_id = data.get('userId')
    if not user_id:
        return jsonify({"message": "Missing userId"}), 400

    try:
        daily_savings = Transaction.get_daily_net_savings(user_id)
        
        days = [entry['day'] for entry in daily_savings]
        net_savings = [entry['netSavings'] for entry in daily_savings]

        fig, ax = plt.subplots(figsize=(10, 5))
        ax.fill_between(days, net_savings, color='blue', alpha=0.3, label='Net Savings')
        ax.plot(days, net_savings, marker='o', color='blue', label='Net Savings')
        ax.set_xlabel('Date', fontsize=12)
        ax.set_ylabel('Net Savings (Amount)', fontsize=12)
        ax.xaxis.set_major_locator(MaxNLocator(integer=True))
        ax.tick_params(axis='x', rotation=45, labelsize=10)
        ax.legend(fontsize=10)
        ax.grid(alpha=0.3)

        img = io.BytesIO()
        fig.savefig(img, format='png', bbox_inches='tight')
        img.seek(0)
        plt.close(fig)
        
        return send_file(img, mimetype='image/png')
    except Exception as e:
        return jsonify({"message": str(e)}), 500
