from flask import Flask, jsonify, render_template, request
import os
from dotenv import load_dotenv
import pymysql

# Load environment variables from .env file
load_dotenv() 

# Database connection function
def get_connection():
    return pymysql.connect(
        host=os.getenv('MYSQL_HOST'),
        user=os.getenv('MYSQL_USER'),
        password=os.getenv('MYSQL_PASSWORD'),
        database=os.getenv('MYSQL_DB'),
        cursorclass=pymysql.cursors.DictCursor
    )

# Create a Flask application instance. This will be the main entry point for our web application and will allow us to define routes and handle incoming requests.
app = Flask(__name__)

# Route to display all books and filter books by title, published year, or author
@app.route('/books', methods=['GET'])
def display_books():
    title = request.args.get('title')
    published_year = request.args.get('year')
    author  = request.args.get('author')

    #Obtain the limit and offset values from the query. Default limit to 5 and offset to 0
    limit = request.args.get('limit', default=5, type=int)
    offset = request.args.get('offset', default=0, type=int)

    #Setup the default query.
    #query = "SELECT * FROM books WHERE 1=1" 
    #query = "SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,p.name as publisher_name FROM books b LEFT JOIN publishers p ON b.publisher_id = p.publisher_id WHERE 1=1"
    query = "SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,p.name AS publisher_name, COUNT(i.inventory_id) AS inventory_count FROM books b LEFT JOIN publishers p ON b.publisher_id = p.publisher_id LEFT JOIN inventory i ON b.book_id = i.book_id WHERE 1=1"
    # Define the list for passing the query parameters. 
    parms = []
    group_by = " GROUP BY b.book_id, b.title, b.isbn, b.published_year, b.price, p.name"

    if title:
        query += " AND title LIKE %s"
        parms.append(f"%{title}%")
    if published_year:
        query += " AND published_year = %s"
        parms.append(published_year)
    if author:
        query += " AND book_id IN (SELECT book_id FROM book_authors WHERE author_id IN (SELECT author_id FROM authors WHERE name LIKE %s))"
        parms.append(f"%{author}%")

    # Add the group by clause to the query if any of the filters are applied. This will ensure that we get the correct count of inventory for each book based on the applied filters.
    query += group_by

    # Add the limit and offset to the query
    query += " LIMIT %s OFFSET %s"
    parms.extend([limit, offset])
    # Get all books from the database and return them as a JSON response
    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            # Execute a SQL query to retrieve all books from the database and store the results in a variable
            cursor.execute(query, tuple(parms))
            # Fetch all the books from the query result and store them in a variable. This will allow us to return the list of books as a JSON response to the client.
            books = cursor.fetchall()
    finally:
        #close the database connection after the operations are completed to free up resources and prevent potential memory leaks
        connection.close()
    # Return the list of books as a JSON response using the jsonify function from Flask. This will convert the list of books into a JSON format that can be easily consumed by clients.
    if books:
        return jsonify(books)
    else:
        return jsonify({'message': 'No books found'}), 404

# Search a book by book id
@app.route('/books/<int:book_id>', methods=['GET'])
def get_book(book_id):
    # Get the book details from the database using the provided book_id
    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            # Execute a SQL query to retrieve the book details based on the book_id
            query_book_by_id = "SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,p.name AS publisher_name, COUNT(i.inventory_id) AS inventory_count FROM books b LEFT JOIN publishers p ON b.publisher_id = p.publisher_id LEFT JOIN inventory i ON b.book_id = i.book_id WHERE b.book_id = %s GROUP BY b.book_id, b.title, b.isbn, b.published_year, b.price, p.name"
            cursor.execute(query_book_by_id, (book_id,))
            # Fetch the book details from the query result and store it in a variable
            book = cursor.fetchone()
    finally:
        # Close the database connection after the operations are completed to free up resources and prevent potential memory leaks
        connection.close()
    if book:
        # If the book is found, return the book details as a JSON response using the jsonify function from Flask. This will convert the book details into a JSON format that can be easily consumed by clients.
        return jsonify(book)
    else:
        # If the book is not found, return a JSON response with a message indicating that the book was not found and set the HTTP status code to 404 (Not Found) to indicate that the requested resource could not be found on the server.
        return jsonify({'message': 'Book not found'}), 404
    
# Route to add a new book
@app.route('/books', methods=['POST'])
def add_book():
    # Get the book details from the request body
    data = request.get_json()
    #print(data)
    connection = get_connection()
    resp_message = {}
    try:
        with connection.cursor() as cursor:
            # Insert the new book into the database
            cursor.execute("INSERT INTO books (title,isbn,published_year,price,publisher_id) VALUES (%s, %s, %s, %s, %s)", 
                           (data['title'], data['isbn'], data['published_year'], data['price'], data['publisher_id']))
            # Commit the transaction to save the changes to the database
            connection.commit()
    finally:
            try:
                with connection.cursor() as cursor1:
                    # Retrieve the newly added book using the last inserted id
                    cursor1.execute("SELECT * FROM books WHERE book_id = %s", (cursor.lastrowid,))
                    # Fetch the book details and add a success message to the response
                    book_added = cursor1.fetchone()
                    resp_message['message'] = f"Book added successfully with id {cursor.lastrowid}"
                    resp_message['book'] = book_added
            finally:       
                # Close the database connection after the operations are completed 
                connection.close()
    # Return the details of the newly added book along with a success message in the response            
    return jsonify(resp_message), 201

# Route to delete book by id
@app.route('/books/<int:book_id>', methods=['DELETE'])
def delete_book(book_id):
    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            # check if book exists before deleting
            cursor.execute("SELECT * FROM books WHERE book_id = %s", (book_id,))
            book = cursor.fetchone()
            if not book:
                # return not found message if book does not exist
                return jsonify({'message': 'Book not found'}), 404
            else:
                # delete the book if it exists
                cursor.execute("DELETE FROM books WHERE book_id = %s", (book_id,))
                connection.commit()
                # delete the book from inventory if it exists
                cursor.execute("DELETE FROM inventory WHERE book_id = %s", (book_id,))
                connection.commit()
                # return success message after deletion
                return jsonify({'message': 'Book deleted successfully'}), 200
    finally:
        connection.close()

@app.route('/books/<int:book_id>', methods=['PATCH'])
def update_book(book_id):
    # Initialize an empty dictionary to store the response message that will be returned to the client after processing the update request. This dictionary will be used to hold any relevant information or messages related to the update operation, such as success or error messages, which can then be included in the JSON response sent back to the client.
    resp_message = {}
    # Get the update data from the request body
    update_data = request.get_json()
    # Only allow updating specific fields
    allowed_fields = {'title', 'isbn', 'published_year', 'price', 'publisher_id', 'inventory_count'}
    # Filter the update data to include only allowed fields and their corresponding values. This will ensure that only valid fields are updated in the database and prevent any unintended changes to other fields.
    data = {key: value for key, value in update_data.items() if key in allowed_fields}  
    print(data)
    if not data:
        # If there are no valid fields to update, return a JSON response with a message indicating that there are no valid fields to update and set the HTTP status code to 400 (Bad Request) to indicate that the request was invalid.
        return jsonify({'message': 'No valid fields to update'}), 400
    else:
        #Check ifthe book exists before updating
        connection = get_connection()
        try:
            with connection.cursor() as cursor:
                # check if book exists before deleting
                cursor.execute("SELECT * FROM books WHERE book_id = %s", (book_id,))
                book = cursor.fetchone()
                if not book:
                    # return not found message if book does not exist
                    return jsonify({'message': 'Book not found'}), 404
                else:    
                    # Dynamically build the SQL query based on the fields provided in the update data. This will allow us to update only the specified fields in the database without affecting other fields.
                    set_clause = ", ".join(f"{key} = %s" for key in data.keys())
                    values = list(data.values()) + [book_id]
                    sql_query = f"UPDATE books SET {set_clause} WHERE book_id = %s"
                    #print(sql_query)
                    # Execute the SQL query to update the book details in the database using the dynamically built query and the corresponding values
                    cursor.execute(sql_query, values)
                    # Commit the transaction to save the changes to the database
                    connection.commit()
                    resp_message['message'] = 'Book updated successfully'
                    cursor.execute("SELECT * FROM books WHERE book_id = %s", (book_id,))
                    book = cursor.fetchone()
                    if not book:
                      # return not found message if book does not exist
                      return jsonify({'message': 'Book not found'}), 404
                    else:
                      resp_message['book'] = book
                    return jsonify(resp_message), 200
        finally:
            connection.close()
@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Resource not found', 'message': 'The requested resource was not found. Valid URLs: /books, /books/<int:book_id>','http_status':404}), 404

# Run the Flask application in debug mode on port 5000. This will allow us to see detailed error messages and automatically reload the server when we make changes to
if __name__ == '__main__':
    app.run(debug=True, port = 5001)