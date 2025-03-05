import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'your-secret-key'
    MYSQL_HOST = 'localhost:3306'
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = 'root'
    MYSQL_DB = 'spendora'
    MYSQL_CURSORCLASS = 'DictCursor'