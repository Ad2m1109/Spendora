from utils.database import get_db
from flask import jsonify
import pymysql.cursors  # Ensure pymysql is imported for DictCursor

class Transaction:
    @staticmethod
    def create_transaction(user_id, amount, date, description, category_id):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = """
                    INSERT INTO transactions (userId, amount, date, description, categoryId)
                    VALUES (%s, %s, %s, %s, %s)
                """
                cursor.execute(sql, (user_id, amount, date, description, category_id))
                db.commit()

                # Update goal's currentAmount if the category matches
                if amount > 0:  # Only update for positive transactions
                    from models.financial_goal import FinancialGoal
                    FinancialGoal.update_goal_current_amount_by_category(category_id, amount)

                return cursor.lastrowid
        except Exception as e:
            db.rollback()  # Rollback in case of error
            print(f"Error creating transaction: {str(e)}")  # Debug log
            raise Exception(f"Failed to create transaction: {str(e)}")

    @staticmethod
    def get_transactions_by_user(user_id):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = "SELECT * FROM transactions WHERE userId = %s"
                print(f"Executing SQL: {sql} with userId: {user_id}")  # Debug log
                cursor.execute(sql, (user_id,))
                transactions = cursor.fetchall()
                if not transactions:
                    return []  # Return an empty list if no transactions are found
                return transactions
        except Exception as e:
            print(f"Error fetching transactions: {str(e)}")  # Debug log
            raise Exception(f"Failed to fetch transactions: {str(e)}")

    @staticmethod
    def update_transaction(transaction_id, amount, date, description, category_id):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = """
                    UPDATE transactions
                    SET amount = %s, date = %s, description = %s, categoryId = %s
                    WHERE transactionId = %s
                """
                cursor.execute(sql, (amount, date, description, category_id, transaction_id))
                db.commit()
                return cursor.rowcount
        except Exception as e:
            db.rollback()  # Rollback in case of error
            print(f"Error updating transaction: {str(e)}")  # Debug log
            raise Exception(f"Failed to update transaction: {str(e)}")

    @staticmethod
    def delete_transaction(transaction_id):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = "DELETE FROM transactions WHERE transactionId = %s"
                cursor.execute(sql, (transaction_id,))
                db.commit()
                return cursor.rowcount
        except Exception as e:
            db.rollback()  # Rollback in case of error
            print(f"Error deleting transaction: {str(e)}")  # Debug log
            raise Exception(f"Failed to delete transaction: {str(e)}")

    @staticmethod
    def calculate_metrics(user_id):
        db = get_db()
        try:
            with db.cursor(cursor=pymysql.cursors.DictCursor) as cursor:  # Use DictCursor for dictionary results
                # Debug: Check database connection
                print(f"Database connection: {db}")
                print(f"idu: {user_id}")
                # Calculate total income
                cursor.execute(
                    "SELECT SUM(amount) as totalIncome FROM transactions WHERE userId = %s AND amount > 0", (user_id,)
                )
                total_income = cursor.fetchone()
                print(f"Raw Total Income result for userId {user_id}: {total_income}")  # Debug log
                total_income = total_income['totalIncome'] if total_income and total_income['totalIncome'] is not None else 0

                # Calculate total expenses
                cursor.execute(
                    "SELECT SUM(amount) as totalExpenses FROM transactions WHERE userId = %s AND amount < 0", (user_id,)
                )
                total_expenses = cursor.fetchone()
                print(f"Raw Total Expenses result for userId {user_id}: {total_expenses}")  # Debug log
                total_expenses = abs(total_expenses['totalExpenses']) if total_expenses and total_expenses['totalExpenses'] is not None else 0

                # Calculate net savings
                net_savings = total_income - total_expenses
                print(f"Net Savings for userId {user_id}: {net_savings}")  # Debug log

                return {
                    "totalIncome": float(total_income),
                    "totalExpenses": float(total_expenses),
                    "netSavings": float(net_savings),
                }
        except Exception as e:
            print(f"Error calculating metrics for userId {user_id}: {str(e)}")  # Debug log
            raise Exception(f"Failed to calculate metrics: {str(e)}")

    @staticmethod
    def get_expense_categories(user_id):
        db = get_db()
        try:
            with db.cursor(cursor=pymysql.cursors.DictCursor) as cursor:
                sql = """
                    SELECT c.categoryName as categoryName, ABS(SUM(t.amount)) as totalAmount
                    FROM transactions t
                    JOIN categories c ON t.categoryId = c.categoryId
                    WHERE t.userId = %s AND t.amount < 0
                    GROUP BY t.categoryId
                """
                cursor.execute(sql, (user_id,))
                categories = cursor.fetchall()
                print(f"Expense categories for userId {user_id}: {categories}")  # Debug log
                return categories
        except Exception as e:
            print(f"Error fetching expense categories for userId {user_id}: {str(e)}")  # Debug log
            raise Exception(f"Failed to fetch expense categories: {str(e)}")

    @staticmethod
    def get_income_categories(user_id):
        db = get_db()
        try:
            with db.cursor(cursor=pymysql.cursors.DictCursor) as cursor:
                sql = """
                    SELECT c.categoryName as categoryName, SUM(t.amount) as totalAmount
                    FROM transactions t
                    JOIN categories c ON t.categoryId = c.categoryId
                    WHERE t.userId = %s AND t.amount > 0
                    GROUP BY t.categoryId
                """
                cursor.execute(sql, (user_id,))
                categories = cursor.fetchall()
                print(f"Income categories for userId {user_id}: {categories}")  # Debug log
                return categories
        except Exception as e:
            print(f"Error fetching income categories for userId {user_id}: {str(e)}")  # Debug log
            raise Exception(f"Failed to fetch income categories: {str(e)}")

    @staticmethod
    def get_daily_net_savings(user_id):
        db = get_db()
        try:
            with db.cursor(cursor=pymysql.cursors.DictCursor) as cursor:
                sql = """
                    SELECT DATE(date) as day, 
                           SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) as totalIncome,
                           ABS(SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END)) as totalExpenses,
                           SUM(amount) as netSavings
                    FROM transactions
                    WHERE userId = %s
                    GROUP BY DATE(date)
                    ORDER BY DATE(date)
                """
                cursor.execute(sql, (user_id,))
                daily_savings = cursor.fetchall()

                # Serialize data for JSON compatibility
                for entry in daily_savings:
                    entry['day'] = entry['day'].isoformat()  # Convert date to string
                    entry['totalIncome'] = float(entry['totalIncome'])  # Convert Decimal to float
                    entry['totalExpenses'] = float(entry['totalExpenses'])  # Convert Decimal to float
                    entry['netSavings'] = float(entry['netSavings'])  # Convert Decimal to float

                return daily_savings
        except Exception as e:
            print(f"Error fetching daily net savings for userId {user_id}: {str(e)}")  # Debug log
            raise Exception(f"Failed to fetch daily net savings: {str(e)}")