import pymysql


config = {
    'host': 'localhost',
    'port': 3306, 
    'user': 'root',
    'password': 'root',
    'database': 'spendora',
    'cursorclass': pymysql.cursors.DictCursor
}

def test_db_connection():
    try:
        # Connect to the database
        connection = pymysql.connect(**config)
        print("Database connection successful!")

        # Create a cursor object
        with connection.cursor() as cursor:
            # Execute a query to fetch the MySQL version
            cursor.execute("SELECT VERSION()")
            version = cursor.fetchone()
            print(f"Database version: {version}")

            # Execute a query to fetch all categories
            cursor.execute("SELECT * FROM categories")
            categories = cursor.fetchall()
            print("Categories in the database:")
            for category in categories:
                print(category)

    except Exception as e:
        print(f"Error connecting to the database: {e}")
    finally:
        # Close the connection
        if connection:
            connection.close()
            print("Database connection closed.")

# Function to add sample categories
def add_sample_categories():
    categories = [
        "Salary",
        "Groceries",
        "Rent",
        "Utilities",
        "Entertainment",
        "Transportation",
        "Healthcare",
        "Savings",
        "Investments",
        "Miscellaneous"
    ]

    try:
        # Connect to the database
        connection = pymysql.connect(**config)
        print("Database connection successful!")

        # Create a cursor object
        with connection.cursor() as cursor:
            # Insert sample categories
            for category_name in categories:
                sql = "INSERT INTO categories (categoryName) VALUES (%s)"
                cursor.execute(sql, (category_name,))
                print(f"Category '{category_name}' added.")

            # Commit the transaction
            connection.commit()

    except Exception as e:
        print(f"Error adding categories: {e}")
    finally:
        # Close the connection
        if connection:
            connection.close()
            print("Database connection closed.")

# Main function
if __name__ == "__main__":
    print("Testing database connection...")
    test_db_connection()

    print("\nAdding sample categories...")
    add_sample_categories()

    print("\nTesting database connection again...")
    test_db_connection()