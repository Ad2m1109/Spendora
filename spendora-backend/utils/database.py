import pymysql
from flask import current_app

def get_db():
    # Split host and port from the configuration
    host, port = current_app.config['MYSQL_HOST'].split(':')
    
    return pymysql.connect(
        host=host,
        port=int(port),  # Convert port to integer
        user=current_app.config['MYSQL_USER'],
        password=current_app.config['MYSQL_PASSWORD'],
        database=current_app.config['MYSQL_DB'],
        cursorclass=pymysql.cursors.DictCursor
    )