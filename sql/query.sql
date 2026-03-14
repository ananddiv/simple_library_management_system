USE wizard_books;

--1. SQL Queries for selecting/searching books in the database - using the GET method in the API
-- select all the books with their publisher names using left join
-- Update the limit and offset values in the query below for pagination. The limit value determines how many records to return and the offset value determines how many records to skip before starting to return records.
SELECT b.book_id,b.title,b.isbn,b.published_year,p.name as publisher_name, b.price,concat(a.first_name, ' ', a.last_name) AS author_name,
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
GROUP BY b.book_id, b.title, b.isbn, b.published_year, publisher_name,b.price, author_name
LIMIT 5 OFFSET 0;

-- Select a single book by its ID - using the GET method in the API
-- replace the book_id value in the query below with the actual book_id you want to search for
-- Update the limit and offset values in the query below for pagination. The limit value determines how many records to return and the offset value determines how many records to skip before starting to return records.
SELECT b.book_id,b.title,b.isbn,b.published_year,p.name as publisher_name, b.price,concat(a.first_name, ' ', a.last_name) AS author_name,
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
GROUP BY b.book_id, b.title, b.isbn, b.published_year, publisher_name, b.price, author_name
LIMIT 5 OFFSET 0;


-- Select a book by title - using the GET method in the API - GET book by <title>
-- replace the title value in the query below with the actual title you want to search for. Use % as a wildcard character for partial matches.
-- Update the limit and offset values in the query below for pagination. The limit value determines how many records to return and the offset value determines how many records to skip before starting to return records.
SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,p.name as publisher_name,concat(a.first_name, ' ', a.last_name) AS author_name,
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
GROUP BY b.book_id, b.title, b.isbn, b.published_year, publisher_name, b.price, author_name
LIMIT 5 OFFSET 0;

-- Select all books published in a specific year - using the GET method in the API - GET books by <published_year>
-- replace the published_year value in the query below with the actual published year you want to search for.
-- Update the limit and offset values in the query below for pagination. The limit value determines how many records to return and the offset value determines how many records to skip before starting to return records.
SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,p.name as publisher_name,concat(a.first_name, ' ', a.last_name) AS author_name,
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
GROUP BY b.book_id, b.title, b.isbn, b.published_year, publisher_name, b.price, author_name
LIMIT 5 OFFSET 0;

-- Select all books by author name - using the GET method in the API - GET books by <author_name>
-- replace the author_name value in the query below with the actual author name you want to search for. Use % as a wildcard character for partial matches.
-- Update the limit and offset values in the query below for pagination. The limit value determines how many records to return and the offset value determines how many records to skip before starting to return records.

SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,p.name as publisher_name,concat(a.first_name, ' ', a.last_name) AS author_name,
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
GROUP BY b.book_id, b.title, b.isbn, b.published_year, publisher_name, b.price, author_name
LIMIT 5 OFFSET 0;


-- 2. SQL Queries for adding a new book to the database - using the POST method in the API - INSERT query
-- Insert a new book into the database - using the POST method in the API

-- 2.1 Check if a book exists in the database by its ISBN before inserting a new book - using the POST method in the API
-- replace the isbn value in the query below with the actual isbn you want to check for.
SELECT * FROM books WHERE isbn = "123-456-789";

-- 2.2 If the book does not exist, insert the new book into the database - using the POST method in the API
INSERT INTO books (title,isbn,published_year,price,publisher_id) VALUES ("Introduction to Algorithms", "123-456-789", "2009","12.96", "4")
-- Insert a new book into the inventory database.

--2.3 Insert the inventory details for the new book into the inventory table - using the POST method in the API
-- replace the book_id value in the query below with the actual book_id of the newly inserted
INSERT INTO inventory (book_id, quantity, location) VALUES (123, 4, 'Main')

--2.4 Check if the author exists in the database - using the POST method in the API
-- replace the author name in the query below with the actual author name you want to check for.
SELECT * FROM authors WHERE first_name = "Thomas H." AND last_name = "Cormen";

--2.5 If the author does not exist, Insert the author name and details for the new book into the authors table - using the POST method in the API
INSERT INTO authors (first_name, last_name) VALUES ("Thomas H.", "Cormen")

--2.6 Insert the author & book mapping into the book_author table - using the POST method in the API
-- replace the book_id value in the query below with the actual book_id of the newly inserted book and replace the author_id value with the actual author_id of the author of the book. You can insert multiple authors for the same book by running the insert query multiple times with the same book_id and different author_id values.
INSERT INTO book_author (book_id, author_id) VALUES (123, 1)


-- 3. SQL Queries for updating book details in the database - using the POST method in the API - PATCH query
-- Update query to update a book - using the POST method in the API - PATCH query
-- replace the book_id value the values to be updated in the query below with the actual values that you want to update and set the new values for the attributes you want to update. You can update one or more attributes of the book.

--3.1 Check if the book exists in the database by its ID before updating the book details - using the POST method in the API - PATCH query
-- replace the book_id value in the query below with the actual book_id you want to check for.
SELECT * FROM books WHERE book_id = 106;
--3.2 Update the fields of the book in the database - using the POST method in the API - PATCH query
-- replace the book_id value in the query below with the actual book_id of the book you
UPDATE books SET title = "Hello World", price = 15.99, publisher_id = 4,isbn="123-456-789" WHERE book_id = 106;
--3.3 Update the inventory details for the book in the inventory table - using the POST method in the API - PATCH query
-- replace the book_id value in the query below with the actual book_id of the book you want to update and set the new values for the inventory attributes you want to update.
UPDATE inventory SET quantity = 10, location = 'Main' WHERE book_id = 106;
--3.4 Update the author name and details for the book in the authors table - using the POST method in the API - PATCH query
-- Check if the author of the book is different from the existing author in the database. If it is different, update the author details in the authors table and update the book_author mapping in the book_author table - using the POST method in the API - PATCH query
SELECT a.author_id, first_name,last_name FROM authors a LEFT JOIN book_author ba ON a.author_id = ba.author_id WHERE ba.book_id = 106;

--3.5 If the author is different, update the author details in the authors table and update the book_author mapping in the book_author table - using the POST method in the API - PATCH query
-- Check if the new author exists in the database. If the new author does not exist, insert the new author details into the authors table and update the book_author mapping in the book_author table with the new author_id - using the POST method in the API - PATCH query
SELECT * FROM authors WHERE first_name = "Thomas H." AND last_name = "Cormen";
--3.6 If the new author does not exist, insert the new author details into the authors table - using the POST method in the API - PATCH query
INSERT INTO authors (first_name, last_name) VALUES ("Thomas H.", "Cormen")
-- 3.7 Update the book_author mapping in the book_author table with the new author_id - using the POST method in the API - PATCH query
UPDATE book_author SET author_id = 1 WHERE book_id = 106;   

--4. SQL Queries for Deleting books from the database - using the DELETE method in the API
--4.1 Delete a book from the database - using the DELETE method in the API
DELETE FROM books WHERE book_id = 106;
-- 4.2 Delete the inventory records associated with the book being deleted
DELETE FROM inventory WHERE book_id = 106;
-- Delete the book_author records associated with the book being deleted
DELETE FROM book_author WHERE book_id = 106;

