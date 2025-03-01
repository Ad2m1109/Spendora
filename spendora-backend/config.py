import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'your-secret-key'
    MYSQL_HOST = 'localhost:3306'  # Include the port number
    MYSQL_USER = 'root'            # Default MAMP username
    MYSQL_PASSWORD = 'root'        # Default MAMP password
    MYSQL_DB = 'spendora'          # Your database name
    MYSQL_CURSORCLASS = 'DictCursor'  # Return results as a dictionary