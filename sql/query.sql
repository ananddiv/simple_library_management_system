USE wizard_books;

-- select all the books with their publisher names using left join
SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,concat(a.first_name, ' ', a.last_name) AS author_name,
 sum(i.quantity) AS inventory_count FROM books b
LEFT JOIN book_author ba
ON b.book_id = ba.book_id
LEFT JOIN authors a
ON ba.author_id = a.author_id
LEFT JOIN publishers p 
ON b.publisher_id = p.publisher_id
LEFT JOIN inventory i
ON b.book_id = i.book_id
WHERE 
1=1 
GROUP BY b.book_id, b.title, b.isbn, b.published_year, b.price, author_name;

-- Select a single book by its ID - using the GET method in the API
SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,concat(a.first_name, ' ', a.last_name) AS author_name,
 sum(i.quantity) AS inventory_count FROM books b
LEFT JOIN book_author ba
ON b.book_id = ba.book_id
LEFT JOIN authors a
ON ba.author_id = a.author_id
LEFT JOIN publishers p 
ON b.publisher_id = p.publisher_id
LEFT JOIN inventory i
ON b.book_id = i.book_id
WHERE 
1=1 
AND b.book_id = 106
GROUP BY b.book_id, b.title, b.isbn, b.published_year, b.price, author_name;


-- Select a book by title - using the GET method in the API - GET book by <title>
SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,concat(a.first_name, ' ', a.last_name) AS author_name,
 sum(i.quantity) AS inventory_count FROM books b
LEFT JOIN book_author ba
ON b.book_id = ba.book_id
LEFT JOIN authors a
ON ba.author_id = a.author_id
LEFT JOIN publishers p 
ON b.publisher_id = p.publisher_id
LEFT JOIN inventory i
ON b.book_id = i.book_id
WHERE 
1=1 
AND b.title like "%Algorithms%"
GROUP BY b.book_id, b.title, b.isbn, b.published_year, b.price, author_name;

-- Select all books published in a specific year - using the GET method in the API - GET books by <published_year>
SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,concat(a.first_name, ' ', a.last_name) AS author_name,
 sum(i.quantity) AS inventory_count FROM books b
LEFT JOIN book_author ba
ON b.book_id = ba.book_id
LEFT JOIN authors a
ON ba.author_id = a.author_id
LEFT JOIN publishers p 
ON b.publisher_id = p.publisher_id
LEFT JOIN inventory i
ON b.book_id = i.book_id
WHERE 
1=1 
AND b.published_year = 2009
GROUP BY b.book_id, b.title, b.isbn, b.published_year, b.price, author_name;


-- Select all books by author name - using the GET method in the API - GET books by <author_name>
SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,concat(a.first_name, ' ', a.last_name) AS author_name,
 sum(i.quantity) AS inventory_count FROM books b
LEFT JOIN book_author ba
ON b.book_id = ba.book_id
LEFT JOIN authors a
ON ba.author_id = a.author_id
LEFT JOIN publishers p 
ON b.publisher_id = p.publisher_id
LEFT JOIN inventory i
ON b.book_id = i.book_id
WHERE 
1=1 
AND a.first_name like "%Thomas H.%" or a.last_name like  "%Cormen%"
GROUP BY b.book_id, b.title, b.isbn, b.published_year, b.price, author_name;       

--Delete a book from the database - using the DELETE method in the API
DELETE FROM books WHERE book_id = 106;
-- Delete the inventory records associated with the book being deleted
DELETE FROM inventory WHERE book_id = 106;

-- Update query to update a book - using the POST method in the API - PATCH query
UPDATE books SET title = "Hello World" WHERE book_id = %s;

-- Select a book by its ISBN number - using the GET method in the API - GET book by <book_id>
select * from books where isbn =22;
-- Select the inventory details for a book by its ID - using the GET method in the API
select * from inventory where book_id = 173;

-- Insert a new book into the database - using the POST method in the API
INSERT INTO books (title,isbn,published_year,price,publisher_id) VALUES ("Introduction to Algorithms", "123-456-789", "2009","12.96", "4")
-- Insert a new book into the inventory database.
INSERT INTO inventory (book_id, quantity, location) VALUES (LAST_INSERT_ID(), 4, 'Main')

delete FROM inventory WHERE book_id = 178;

select * from inventory where book_id = 178;