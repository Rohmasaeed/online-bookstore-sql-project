-- =====================================================
-- PROJECT: ONLINE BOOKSTORE DATABASE
-- Description: SQL project demonstrating database design,
-- joins, aggregation, filtering and analytical queries.
-- =====================================================
-- Create Database
CREATE DATABASE OnlineBookstore;
USE OnlineBookstore;
-- Books Table
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price DECIMAL(10,2),
    Stock INT
);
-- Customers Table
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
    Customer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(50)
);
-- Orders Table
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    Order_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10,2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);
-- BASIC DATA CHECK
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
-- 1) Retrieve all books in the "Fiction" genre
SELECT *
FROM Books
WHERE Genre = 'Fiction';

-- 2) Find books published after 1950
SELECT *
FROM Books
WHERE Published_Year > 1950;

-- 3) List all customers from Canada
SELECT *
FROM Customers
WHERE Country = 'Canada';

-- 4) Show orders placed in November 2023
SELECT *
FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve total stock of books available
SELECT SUM(Stock) AS Total_Stock
FROM Books;

-- 6) Find the most expensive book
SELECT *
FROM Books
ORDER BY Price DESC
LIMIT 1;

-- 7) Show customers who ordered more than 1 quantity
SELECT Customer_ID, Quantity
FROM Orders
WHERE Quantity > 1;

-- 8) Retrieve orders where total amount exceeds $20
SELECT *
FROM Orders
WHERE Total_Amount > 20;

-- 9) List all unique genres
SELECT DISTINCT Genre
FROM Books;

-- 10) Find the book with the lowest stock
SELECT Book_ID, Title, Stock
FROM Books
ORDER BY Stock ASC
LIMIT 1;

-- 11) Calculate total revenue from all orders
SELECT SUM(Total_Amount) AS Total_Revenue
FROM Orders;

-- 12) Total number of books sold per genre
SELECT b.Genre, SUM(o.Quantity) AS Total_Sold
FROM Books b
JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Genre;

-- 13) Average price of Fantasy books
SELECT AVG(Price) AS Average_Fantasy_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 14) Customers who placed at least 2 orders
SELECT c.Customer_ID, c.Name, COUNT(o.Order_ID) AS Total_Orders
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2;

-- 15) Most frequently ordered book
SELECT b.Title, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Books b
ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY Order_Count DESC
LIMIT 1;

-- 16) Top 3 most expensive Fantasy books
SELECT Title, Price
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- 17) Total books sold by each author
SELECT b.Author, SUM(o.Quantity) AS Total_Books_Sold
FROM Books b
JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Author
ORDER BY Total_Books_Sold DESC;

-- 18) Cities where customers spent more than $30
SELECT c.City, SUM(o.Total_Amount) AS Total_Spent
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.City
HAVING SUM(o.Total_Amount) > 30;

-- 19) Customer who spent the most
SELECT c.Customer_ID, c.Name, SUM(o.Total_Amount) AS Amount_Spent
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Amount_Spent DESC
LIMIT 1;

-- 20) Remaining stock after fulfilling orders
SELECT 
b.Book_ID,
b.Title,
b.Stock,
COALESCE(SUM(o.Quantity),0) AS Total_Sold,
b.Stock - COALESCE(SUM(o.Quantity),0) AS Remaining_Stock
FROM Books b
LEFT JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock;

-- 21) Top 5 customers by total spending
SELECT c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Name
ORDER BY Total_Spent DESC
LIMIT 5;

-- 22) Books that have never been ordered
SELECT b.Title
FROM Books b
LEFT JOIN Orders o
ON b.Book_ID = o.Book_ID
WHERE o.Order_ID IS NULL;

-- 23) Total number of orders per customer
SELECT c.Name, COUNT(o.Order_ID) AS Total_Orders
FROM Customers c
LEFT JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Name;

-- 24) Average order value per customer
SELECT c.Name, AVG(o.Total_Amount) AS Avg_Order_Value
FROM Customers c
JOIN Orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Name;

-- 25) Best selling genre
SELECT b.Genre, SUM(o.Quantity) AS Books_Sold
FROM Books b
JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Books_Sold DESC
LIMIT 1;

