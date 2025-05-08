-- Library Management System Database
-- Created by: [MURANGIRI MURUNGI]
-- Date: [8/5/2025]

-- Create databasE
CREATE DATABASE library_management;
USE library_management;

-- Members table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    membership_date DATE NOT NULL,
    membership_status ENUM('Active', 'Expired', 'Suspended') DEFAULT 'Active',
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- Authors table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    biography TEXT
);

-- Publishers table
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100)
);

-- Books table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publisher_id INT,
    publication_year INT,
    edition VARCHAR(20),
    category VARCHAR(50),
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    shelf_location VARCHAR(20),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE SET NULL,
    CONSTRAINT chk_copies CHECK (available_copies <= total_copies AND available_copies >= 0)
);

-- Book-Author 
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Loans table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('On Loan', 'Returned', 'Overdue') DEFAULT 'On Loan',
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT chk_dates CHECK (due_date > loan_date AND (return_date IS NULL OR return_date >= loan_date))
);

-- Fines table
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    issue_date DATE NOT NULL,
    payment_date DATE,
    status ENUM('Pending', 'Paid') DEFAULT 'Pending',
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id),
    CONSTRAINT chk_amount CHECK (amount >= 0)
);

-- Staff table
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    CONSTRAINT chk_salary CHECK (salary >= 0)
);

-- Create indexes for performance
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_members_name ON members(last_name, first_name);
CREATE INDEX idx_loans_dates ON loans(loan_date, due_date);
CREATE INDEX idx_fines_status ON fines(status);


--- insert values in the table created
-- insert into members
USE library_management;
INSERT INTO members (first_name, last_name, email, phone, address, membership_date, membership_status) 
VALUES
('Alice', 'Johnson', 'alice.johnson@example.com', '1234567890', 
'123 Elm Street', '2023-01-15', 'Active'),
('Bob', 'Smith', 'bob.smith@example.com', '2345678901', 
'456 Oak Avenue', '2023-03-10', 'Active'),
('Carol', 'Davis', 'carol.davis@example.com', 
'3456789012', '789 Pine Road', '2022-11-05', 'Expired'),
('David', 'Miller', 'david.miller@example.com', '4567890123', 
'321 Maple Lane', '2024-02-01', 'Suspended');

--INSERT  INTO authours

USE library_management;
INSERT INTO authors (first_name, last_name, birth_date, nationality, biography)
VALUES
('George', 'Orwell', '1903-06-25', 'British', 
'Author of 1984 and Animal Farm.'),
('Jane', 'Austen', '1775-12-16', 'British', 
'Famous for Pride and Prejudice.'),
('Mark', 'Twain', '1835-11-30', 'American', 
'Known for The Adventures of Tom Sawyer.'),
('Haruki', 'Murakami', '1949-01-12', 'Japanese', 
'Japanese novelist and translator.');

--INSERT INTO PUBLISHERS

USE library_management;

INSERT INTO publishers (name, address, phone, email, website) VALUES
('Penguin Random House', '1745 Broadway, New York, NY', '2125551234', 
'contact@penguin.com', 'https://www.penguinrandomhouse.com'),
('HarperCollins', '195 Broadway, New York, NY', '2125552345', 
'info@harpercollins.com', 'https://www.harpercollins.com'),
('Oxford University Press', 'Great Clarendon St, Oxford', 
'01865255678', 'info@oup.com', 'https://www.oup.com'),
('Vintage Books', '1745 Broadway, New York, NY', '2125553456', 
'info@vintagebooks.com', 'https://www.vintagebooks.com');

-- INSERT INTO BOOKS

USE library_management;
INSERT INTO books (title, isbn, publisher_id, publication_year, 
edition, category, total_copies, available_copies, shelf_location)
 VALUES
('1984', '9780451524935', 1, 1949, '1st',
 'Fiction', 5, 3, 'A1'),
('Pride and Prejudice', '9780141439518', 2,
 1813, '2nd', 'Classic', 4, 2, 'B2'),
('Norwegian Wood', '9780375704024', 4, 1987, 
'1st', 'Romance', 6, 6, 'C3'),
('The Adventures of Tom Sawyer', '9780486400778',
 3, 1876, '3rd', 'Adventure', 3, 1, 'D4');

 --INSERT INTO STAFF 

 INSERT INTO staff (first_name, last_name, email, phone,
 position, hire_date, salary) VALUES
('Emily', 'Brown', 'emily.brown@example.com',
'5551230001', 'Librarian', '2020-06-15', 45000.00),
('James', 'Wilson', 'james.wilson@example.com', '5551230002',
'Assistant Librarian', '2021-09-01', 35000.00),
('Sarah', 'Lee', 'sarah.lee@example.com', '5551230003',
'Technician', '2019-02-20', 40000.00),
('Michael', 'Clark', 'michael.clark@example.com',
'5551230004', 'Manager', '2018-11-05', 60000.00);