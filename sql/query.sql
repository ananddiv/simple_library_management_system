USE wizard_books;
-- This SQL script is used to query the `books` table and retrieve information about the books along with their publishers.
SELECT title, published_year, price,count(*) as inventory FROM books group by title, published_year, price

SELECT b.book_id,b.title,b.isbn,b.published_year,b.price,p.name FROM books b
LEFT JOIN publishers p 
ON b.publisher_id = p.publisher_id;