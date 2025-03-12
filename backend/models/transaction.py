from utils.database import get_db
from flask import jsonify

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