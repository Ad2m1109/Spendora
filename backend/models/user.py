from utils.database import get_db
import bcrypt

class User:
    @staticmethod
    def create_user(name, email, password):
        db = get_db()
        try:
            hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
            with db.cursor() as cursor:
                sql = "INSERT INTO users (name, email, password) VALUES (%s, %s, %s)"
                cursor.execute(sql, (name, email, hashed_password))
                db.commit()
                return cursor.lastrowid
        except Exception as e:
            db.rollback()
            raise
        finally:
            db.close()

    @staticmethod
    def get_user_by_email(email):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = "SELECT * FROM users WHERE email = %s"
                cursor.execute(sql, (email,))
                user = cursor.fetchone()
                # Debug print to check the retrieved user
                print(f'Retrieved user: {user}')
                return user
        finally:
            db.close()

    @staticmethod
    def get_user_by_id(user_id):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = "SELECT * FROM users WHERE userId = %s"
                cursor.execute(sql, (user_id,))
                return cursor.fetchone()
        finally:
            db.close()

    @staticmethod
    def update_user_profile(user_id, name, email):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = "UPDATE users SET name = %s, email = %s WHERE userId = %s"
                cursor.execute(sql, (name, email, user_id))
                db.commit()
                return cursor.rowcount
        except Exception as e:
            db.rollback()
            raise
        finally:
            db.close()