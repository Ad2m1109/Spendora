from utils.database import get_db
import logging

logger = logging.getLogger(__name__)

class FinancialGoal:
    @staticmethod
    def create_goal(user_id, goal_name, target_amount, current_amount=0, category_id=None):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = """
                    INSERT INTO financialgoals (userId, goalName, targetAmount, currentAmount, categoryId, created_at)
                    VALUES (%s, %s, %s, %s, %s, NOW())
                """
                cursor.execute(sql, (user_id, goal_name, target_amount, current_amount, category_id))
                db.commit()
                return cursor.lastrowid
        except Exception as e:
            db.rollback()
            logger.error(f"Error creating goal: {str(e)}", exc_info=True)
            raise Exception(f"Failed to create goal: {str(e)}")
        finally:
            db.close()

    @staticmethod
    def get_goals_by_user(user_id):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = "SELECT * FROM financialgoals WHERE userId = %s"
                cursor.execute(sql, (user_id,))
                goals = cursor.fetchall()
                return [dict(goal) for goal in goals] if goals else []
        except Exception as e:
            logger.error(f"Error fetching goals: {str(e)}", exc_info=True)
            raise Exception(f"Failed to fetch goals: {str(e)}")
        finally:
            db.close()

    @staticmethod
    def update_goal_progress(goal_id, current_amount):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = """
                    UPDATE financialgoals
                    SET currentAmount = %s
                    WHERE goalId = %s
                """
                cursor.execute(sql, (current_amount, goal_id))
                db.commit()
                return cursor.rowcount
        except Exception as e:
            db.rollback()
            logger.error(f"Error updating goal: {str(e)}", exc_info=True)
            raise Exception(f"Failed to update goal: {str(e)}")
        finally:
            db.close()

    @staticmethod
    def delete_goal(goal_id):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = "DELETE FROM financialgoals WHERE goalId = %s"
                cursor.execute(sql, (goal_id,))
                db.commit()
                return cursor.rowcount
        except Exception as e:
            db.rollback()
            logger.error(f"Error deleting goal: {str(e)}", exc_info=True)
            raise Exception(f"Failed to delete goal: {str(e)}")
        finally:
            db.close()

    @staticmethod
    def user_exists(user_id):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = "SELECT COUNT(*) AS count FROM users WHERE userId = %s"
                cursor.execute(sql, (user_id,))
                result = cursor.fetchone()
                logger.info(f"User existence check result for userId {user_id}: {result}")  # Debug log
                return result['count'] > 0 if isinstance(result, dict) else result[0] > 0  # Handle both dict and tuple
        except Exception as e:
            logger.error(f"Error checking user existence: {str(e)}", exc_info=True)
            raise Exception(f"Failed to verify user existence: {str(e)}")
        finally:
            db.close()

    @staticmethod
    def update_goal_current_amount_by_category(category_id, amount):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = """
                    UPDATE financialgoals
                    SET currentAmount = currentAmount + %s
                    WHERE categoryId = %s
                """
                cursor.execute(sql, (amount, category_id))
                db.commit()
                return cursor.rowcount
        except Exception as e:
            db.rollback()
            logger.error(f"Error updating goal current amount: {str(e)}", exc_info=True)
            raise Exception(f"Failed to update goal current amount: {str(e)}")
        finally:
            db.close()

    @staticmethod
    def is_category_used(category_id):
        db = get_db()
        try:
            with db.cursor() as cursor:
                sql = "SELECT COUNT(*) AS count FROM financialgoals WHERE categoryId = %s"
                cursor.execute(sql, (category_id,))
                result = cursor.fetchone()
                return result['count'] > 0 if isinstance(result, dict) else result[0] > 0  # Handle both dict and tuple
        except Exception as e:
            logger.error(f"Error checking category usage: {str(e)}", exc_info=True)
            raise Exception(f"Failed to check category usage: {str(e)}")
        finally:
            db.close()