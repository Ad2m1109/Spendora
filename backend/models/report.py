from utils.database import get_db

class Report:
    @staticmethod
    def generate_report(user_id, report_type, generated_date):
        db = get_db()
        with db.cursor() as cursor:
            sql = """
                INSERT INTO reports (userId, reportType, generatedDate)
                VALUES (%s, %s, %s)
            """
            cursor.execute(sql, (user_id, report_type, generated_date))
            db.commit()
            return cursor.lastrowid

    @staticmethod
    def get_reports_by_user(user_id):
        db = get_db()
        with db.cursor() as cursor:
            sql = "SELECT * FROM reports WHERE userId = %s"
            cursor.execute(sql, (user_id,))
            return cursor.fetchall()