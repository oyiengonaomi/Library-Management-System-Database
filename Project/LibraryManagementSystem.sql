-- Library Management System

-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS LibraryManagementSystem;

-- Use the database
USE LibraryManagementSystem;

-- Table: Books
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ISBN VARCHAR(13) UNIQUE NOT NULL,
    PublicationYear INT,
    Publisher VARCHAR(255),
    AuthorID INT, -- Foreign Key
    CategoryID INT,  -- Foreign Key
    Status ENUM('Available', 'Checked Out', 'Reserved') NOT NULL DEFAULT 'Available'
);

-- Table: Authors
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Biography TEXT
);

-- Table: Categories
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);

-- Table: Members
CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    Address VARCHAR(255),
    MembershipDate DATE NOT NULL
);

-- Table: Loans (formerly BookLoans)
CREATE TABLE Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT, -- Foreign Key
    BookID INT, -- Foreign Key
    LoanDate DATE NOT NULL,
    ReturnDate DATE,
    Status ENUM('Active', 'Returned', 'Overdue') NOT NULL DEFAULT 'Active',
    CONSTRAINT FK_Loans_Members FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    CONSTRAINT FK_Loans_Books FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Table: Reservations
CREATE TABLE Reservations (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT, -- Foreign Key
    BookID INT, -- Foreign Key
    ReservationDate DATETIME NOT NULL,
    Status ENUM('Pending', 'Active', 'Cancelled', 'Completed') NOT NULL DEFAULT 'Pending',
    CONSTRAINT FK_Reservations_Members FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    CONSTRAINT FK_Reservations_Books FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Table: Fines
CREATE TABLE Fines (
    FineID INT AUTO_INCREMENT PRIMARY KEY,
    LoanID INT, -- Foreign Key
    FineAmount DECIMAL(10, 2) NOT NULL,
    PaymentDate DATE,
    Status ENUM('Unpaid', 'Paid', 'Waived') NOT NULL DEFAULT 'Unpaid',
    CONSTRAINT FK_Fines_Loans FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

-- Table: BookAuthor (Many-to-Many relationship between Books and Authors)
CREATE TABLE BookAuthor (
    BookID INT,
    AuthorID INT,
    PRIMARY KEY (BookID, AuthorID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);
-- Add foreign key constraint to Books table after creating Authors and Categories tables
ALTER TABLE Books
ADD CONSTRAINT FK_Books_Authors
FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID);

ALTER TABLE Books
ADD CONSTRAINT FK_Books_Categories
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);
