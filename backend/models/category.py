from models import db

class Category(db.Model):
    __tablename__ = 'categories'

    categoryId = db.Column(db.Integer, primary_key=True)
    categoryName = db.Column(db.String(100), unique=True, nullable=False)

    # Relationships
    transactions = db.relationship('Transaction', backref='category', lazy=True, cascade="all, delete-orphan")
    financial_goals = db.relationship('FinancialGoal', backref='category', lazy=True, cascade="all, delete-orphan")

    def __init__(self, category_name):
        self.categoryName = category_name

    def json(self):
        return {
            'categoryId': self.categoryId,
            'categoryName': self.categoryName
        }

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()

    @classmethod
    def find_by_id(cls, category_id):
        return cls.query.filter_by(categoryId=category_id).first()

    @classmethod
    def find_by_name(cls, name):
        return cls.query.filter_by(categoryName=name).first()

    @classmethod
    def get_all(cls):
        return cls.query.all()
