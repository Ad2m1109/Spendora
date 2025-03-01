from utils.database import get_db
import bcrypt

class User:
    @staticmethod
    def create_user(name, email, password):
        db = get_db()
        hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
        with db.cursor() as cursor:
            sql = "INSERT INTO users (name, email, password) VALUES (%s, %s, %s)"
            cursor.execute(sql, (name, email, hashed_password))
            db.commit()
            return cursor.lastrowid

    @staticmethod
    def get_user_by_email(email):
        db = get_db()
        with db.cursor() as cursor:
            sql = "SELECT * FROM users WHERE email = %s"
            cursor.execute(sql, (email,))
            return cursor.fetchone()
