from models import db
from sqlalchemy.sql import func
from sqlalchemy import case

class Transaction(db.Model):
    __tablename__ = 'transactions'

    transactionId = db.Column(db.Integer, primary_key=True)
    amount = db.Column(db.Float, nullable=False)
    date = db.Column(db.DateTime, nullable=False)
    description = db.Column(db.String(255), nullable=False)

    userId = db.Column(db.Integer, db.ForeignKey('users.userId'), nullable=False)
    categoryId = db.Column(db.Integer, db.ForeignKey('categories.categoryId'), nullable=False)

    def __init__(self, user_id, amount, date, description, category_id):
        self.userId = user_id
        self.amount = amount
        self.date = date
        self.description = description
        self.categoryId = category_id

    def json(self):
        return {
            'transactionId': self.transactionId,
            'amount': self.amount,
            'date': self.date.isoformat(),
            'description': self.description,
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
    def find_by_id(cls, transaction_id):
        return cls.query.filter_by(transactionId=transaction_id).first()

    @classmethod
    def find_by_user(cls, user_id):
        return cls.query.filter_by(userId=user_id).all()

    @staticmethod
    def calculate_metrics(user_id):
        total_income = db.session.query(func.sum(Transaction.amount)).filter(
            Transaction.userId == user_id,
            Transaction.amount > 0
        ).scalar() or 0.0

        total_expenses = db.session.query(func.sum(Transaction.amount)).filter(
            Transaction.userId == user_id,
            Transaction.amount < 0
        ).scalar() or 0.0
        total_expenses = abs(total_expenses)

        net_savings = total_income - total_expenses

        return {
            "totalIncome": float(total_income),
            "totalExpenses": float(total_expenses),
            "netSavings": float(net_savings),
        }

    @staticmethod
    def get_expense_categories(user_id):
        from models.category import Category
        return db.session.query(
            Category.categoryName,
            func.abs(func.sum(Transaction.amount)).label('totalAmount')
        ).join(Category, Transaction.categoryId == Category.categoryId).filter(
            Transaction.userId == user_id,
            Transaction.amount < 0
        ).group_by(Category.categoryName).all()

    @staticmethod
    def get_income_categories(user_id):
        from models.category import Category
        return db.session.query(
            Category.categoryName,
            func.sum(Transaction.amount).label('totalAmount')
        ).join(Category, Transaction.categoryId == Category.categoryId).filter(
            Transaction.userId == user_id,
            Transaction.amount > 0
        ).group_by(Category.categoryName).all()

    @staticmethod
    def get_daily_net_savings(user_id):
        results = db.session.query(
            func.date(Transaction.date).label('day'),
            func.sum(case((Transaction.amount > 0, Transaction.amount), else_=0)).label('totalIncome'),
            func.abs(func.sum(case((Transaction.amount < 0, Transaction.amount), else_=0))).label('totalExpenses'),
            func.sum(Transaction.amount).label('netSavings')
        ).filter(Transaction.userId == user_id).group_by(func.date(Transaction.date)).order_by(func.date(Transaction.date)).all()
        
        # Serialize data for JSON compatibility
        daily_savings = []
        for row in results:
            daily_savings.append({
                'day': row.day.isoformat(),
                'totalIncome': float(row.totalIncome),
                'totalExpenses': float(row.totalExpenses),
                'netSavings': float(row.netSavings)
            })
        return daily_savings
