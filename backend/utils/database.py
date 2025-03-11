import pymysql
from flask import current_app
from contextlib import contextmanager

def get_db():
    return pymysql.connect(
        host=current_app.config['MYSQL_HOST'].split(':')[0],
        port=int(current_app.config['MYSQL_HOST'].split(':')[1]),
        user=current_app.config['MYSQL_USER'],
        password=current_app.config['MYSQL_PASSWORD'],
        database=current_app.config['MYSQL_DB'],
        cursorclass=pymysql.cursors.DictCursor
    )