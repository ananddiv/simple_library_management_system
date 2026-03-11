USE wizard_books;

-- select all the books with their publisher names using left join
SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,p.name AS publisher_name, COUNT(i.inventory_id) AS inventory_count FROM books b
LEFT JOIN publishers p 
ON b.publisher_id = p.publisher_id
LEFT JOIN inventory i
ON b.book_id = i.book_id
WHERE 1=1
GROUP BY b.book_id, b.title, b.isbn, b.published_year, b.price, p.name;

-- Select a single book by its ID - using the GET method in the API
SELECT * FROM books WHERE book_id = 101;

-- Update query to update a book - using the POST method in the API
UPDATE books SET {set_clause} WHERE book_id = %s;

--Delete a book from the database - using the DELETE method in the API

DELETE FROM books WHERE book_id = 101;

-- Insert a new book into the database - using the POST method in the API
INSERT INTO books (title,isbn,published_year,price,publisher_id) VALUES (%s, %s, %s, %s, %s)", 
                           (data['title'], data['isbn'], data['published_year'], data['price'], data['publisher_id'])