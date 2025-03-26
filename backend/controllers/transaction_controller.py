import matplotlib
matplotlib.use('Agg')  # Use non-GUI backend for rendering charts

from flask import Blueprint, request, jsonify, send_file
from models.transaction import Transaction
import io
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator  # For better axis formatting

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

@transaction_blueprint.route('/metrics', methods=['POST'])
def get_dashboard_metrics():
    try:
        data = request.get_json()
        user_id = data.get('userId')
        if not user_id:
            return jsonify({"message": "Missing userId"}), 400

        metrics = Transaction.calculate_metrics(user_id)
        return jsonify(metrics), 200
    except Exception as e:
        print(f"Error fetching dashboard metrics: {str(e)}")  # Debug log
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/expense-categories-chart', methods=['POST'])
def get_expense_categories_chart():
    try:
        data = request.get_json()
        user_id = data.get('userId')

        if not user_id:
            return jsonify({"message": "Missing userId"}), 400

        # Fetch expense categories data
        categories_data = Transaction.get_expense_categories(user_id)

        # Generate the chart
        labels = [item['categoryName'] for item in categories_data]
        values = [item['totalAmount'] for item in categories_data]

        fig, ax = plt.subplots(figsize=(8, 8))  # Reduced figure size for efficiency
        ax.pie(
            values,
            labels=labels,
            autopct='%1.1f%%',
            startangle=140,
            textprops={'fontsize': 12}  # Reduced font size for better performance
        )
        ax.axis('equal')  # Ensures the pie chart is a perfect circle

        # Save the chart to a BytesIO object
        img = io.BytesIO()
        fig.savefig(img, format='png', bbox_inches='tight')
        img.seek(0)
        plt.close(fig)  # Explicitly close the figure to free resources

        # Send the image as a response
        return send_file(img, mimetype='image/png')
    except Exception as e:
        print(f"Error generating expense categories chart: {str(e)}")  # Debug log
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/income-categories-chart', methods=['POST'])
def get_income_categories_chart():
    try:
        data = request.get_json()
        user_id = data.get('userId')

        if not user_id:
            return jsonify({"message": "Missing userId"}), 400

        # Fetch income categories data
        categories_data = Transaction.get_income_categories(user_id)

        # Generate the chart
        labels = [item['categoryName'] for item in categories_data]
        values = [item['totalAmount'] for item in categories_data]

        fig, ax = plt.subplots(figsize=(8, 8))  # Reduced figure size for efficiency
        ax.pie(
            values,
            labels=labels,
            autopct='%1.1f%%',
            startangle=140,
            textprops={'fontsize': 12}  # Reduced font size for better performance
        )
        ax.axis('equal')  # Ensures the pie chart is a perfect circle

        # Save the chart to a BytesIO object
        img = io.BytesIO()
        fig.savefig(img, format='png', bbox_inches='tight')
        img.seek(0)
        plt.close(fig)  # Explicitly close the figure to free resources

        # Send the image as a response
        return send_file(img, mimetype='image/png')
    except Exception as e:
        print(f"Error generating income categories chart: {str(e)}")  # Debug log
        return jsonify({"message": str(e)}), 500

@transaction_blueprint.route('/daily-net-savings-chart', methods=['POST'])
def get_daily_net_savings_chart():
    try:
        data = request.get_json()
        user_id = data.get('userId')

        if not user_id:
            return jsonify({"message": "Missing userId"}), 400

        # Fetch daily net savings data
        daily_savings = Transaction.get_daily_net_savings(user_id)

        # Prepare data for the chart
        days = [entry['day'] for entry in daily_savings]
        net_savings = [entry['netSavings'] for entry in daily_savings]

        fig, ax = plt.subplots(figsize=(10, 5))  # Reduced figure size for efficiency
        ax.fill_between(days, net_savings, color='blue', alpha=0.3, label='Net Savings')
        ax.plot(days, net_savings, marker='o', color='blue', label='Net Savings')
        ax.set_xlabel('Date', fontsize=12)
        ax.set_ylabel('Net Savings (Amount)', fontsize=12)
        ax.xaxis.set_major_locator(MaxNLocator(integer=True))  # Ensure integer ticks
        ax.tick_params(axis='x', rotation=45, labelsize=10)
        ax.legend(fontsize=10)
        ax.grid(alpha=0.3)

        # Save the chart to a BytesIO object
        img = io.BytesIO()
        fig.savefig(img, format='png', bbox_inches='tight')
        img.seek(0)
        plt.close(fig)  # Explicitly close the figure to free resources

        # Send the image as a response
        return send_file(img, mimetype='image/png')
    except Exception as e:
        print(f"Error generating daily net savings chart: {str(e)}")  # Debug log
        return jsonify({"message": str(e)}), 500