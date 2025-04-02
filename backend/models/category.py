from utils.database import get_db

class Category:
    @staticmethod
    def create_category(category_name):
        db = get_db()
        with db.cursor() as cursor:
            sql = "INSERT INTO categories (categoryName) VALUES (%s)"
            cursor.execute(sql, (category_name,))
            db.commit()
            return cursor.lastrowid

    @staticmethod
    def get_all_categories():
        db = get_db()
        with db.cursor() as cursor:
            sql = "SELECT * FROM categories"
            cursor.execute(sql)
            return cursor.fetchall()

    @staticmethod
    def get_category_by_id(category_id):
        db = get_db()
        with db.cursor() as cursor:
            sql = "SELECT * FROM categories WHERE categoryId = %s"
            cursor.execute(sql, (category_id,))
            return cursor.fetchone()

    @staticmethod
    def delete_category(category_id):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = "DELETE FROM categories WHERE categoryId = %s"
                cursor.execute(sql, (category_id,))
                db.commit()
                return cursor.rowcount
        except Exception as e:
            db.rollback()
            raise Exception(f"Failed to delete category: {str(e)}")
        finally:
            db.close()