from utils.database import get_db

class Transaction:
    @staticmethod
    def create_transaction(user_id, amount, date, description, category_id):
        db = get_db()
        with db.cursor() as cursor:
            sql = """
                INSERT INTO transactions (userId, amount, date, description, categoryId)
                VALUES (%s, %s, %s, %s, %s)
            """
            cursor.execute(sql, (user_id, amount, date, description, category_id))
            db.commit()
            return cursor.lastrowid

    @staticmethod
    def get_transactions_by_user(user_id):
        db = get_db()
        with db.cursor() as cursor:
            sql = "SELECT * FROM transactions WHERE userId = %s"
            cursor.execute(sql, (user_id,))
            return cursor.fetchall()

    @staticmethod
    def update_transaction(transaction_id, amount, date, description, category_id):
        db = get_db()
        with db.cursor() as cursor:
            sql = """
                UPDATE transactions
                SET amount = %s, date = %s, description = %s, categoryId = %s
                WHERE transactionId = %s
            """
            cursor.execute(sql, (amount, date, description, category_id, transaction_id))
            db.commit()
            return cursor.rowcount

    @staticmethod
    def delete_transaction(transaction_id):
        db = get_db()
        with db.cursor() as cursor:
            sql = "DELETE FROM transactions WHERE transactionId = %s"
            cursor.execute(sql, (transaction_id,))
            db.commit()
            return cursor.rowcount