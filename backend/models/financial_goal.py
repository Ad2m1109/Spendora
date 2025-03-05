from utils.database import get_db

class FinancialGoal:
    @staticmethod
    def create_goal(user_id, goal_name, target_amount):
        db = get_db()
        with db.cursor() as cursor:
            sql = """
                INSERT INTO financialGoals (userId, goalName, targetAmount)
                VALUES (%s, %s, %s)
            """
            cursor.execute(sql, (user_id, goal_name, target_amount))
            db.commit()
            return cursor.lastrowid

    @staticmethod
    def get_goals_by_user(user_id):
        db = get_db()
        with db.cursor() as cursor:
            sql = "SELECT * FROM financialGoals WHERE userId = %s"
            cursor.execute(sql, (user_id,))
            return cursor.fetchall()

    @staticmethod
    def update_goal_progress(goal_id, current_amount):
        db = get_db()
        with db.cursor() as cursor:
            sql = """
                UPDATE financialGoals
                SET currentAmount = %s
                WHERE goalId = %s
            """
            cursor.execute(sql, (current_amount, goal_id))
            db.commit()
            return cursor.rowcount

    @staticmethod
    def delete_goal(goal_id):
        db = get_db()
        with db.cursor() as cursor:
            sql = "DELETE FROM financialGoals WHERE goalId = %s"
            cursor.execute(sql, (goal_id,))
            db.commit()
            return cursor.rowcount