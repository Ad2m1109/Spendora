from models import db
from sqlalchemy.sql import func

class FinancialGoal(db.Model):
    __tablename__ = 'financialgoals'

    goalId = db.Column(db.Integer, primary_key=True)
    goalName = db.Column(db.String(100), nullable=False)
    targetAmount = db.Column(db.Float, nullable=False)
    currentAmount = db.Column(db.Float, default=0.0)
    created_at = db.Column(db.DateTime(timezone=True), server_default=func.now())
    
    userId = db.Column(db.Integer, db.ForeignKey('users.userId'), nullable=False)
    categoryId = db.Column(db.Integer, db.ForeignKey('categories.categoryId'), unique=True, nullable=True)

    def __init__(self, goal_name, target_amount, user_id, current_amount=0.0, category_id=None):
        self.goalName = goal_name
        self.targetAmount = target_amount
        self.currentAmount = current_amount
        self.userId = user_id
        self.categoryId = category_id

    def json(self):
        return {
            'goalId': self.goalId,
            'goalName': self.goalName,
            'targetAmount': self.targetAmount,
            'currentAmount': self.currentAmount,
            'created_at': self.created_at.isoformat(),
            'userId': self.userId,
            'categoryId': self.categoryId
        }

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()

    @classmethod
    def find_by_id(cls, goal_id):
        return cls.query.filter_by(goalId=goal_id).first()

    @classmethod
    def find_by_user(cls, user_id):
        return cls.query.filter_by(userId=user_id).all()

    @classmethod
    def find_by_category(cls, category_id):
        return cls.query.filter_by(categoryId=category_id).first()
