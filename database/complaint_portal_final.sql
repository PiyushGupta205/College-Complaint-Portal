DROP DATABASE IF EXISTS complaint_portal;
CREATE DATABASE complaint_portal;
USE complaint_portal;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE faculty (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    department VARCHAR(100)
);

CREATE TABLE administrators (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE complaint_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    category_id INT NOT NULL,
    assigned_faculty_id INT NULL,
    title VARCHAR(150) NOT NULL,
    location VARCHAR(150),
    description TEXT,
    remarks TEXT,
    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_complaint_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_complaint_category
        FOREIGN KEY (category_id)
        REFERENCES complaint_category(category_id),

    CONSTRAINT fk_complaint_faculty
        FOREIGN KEY (assigned_faculty_id)
        REFERENCES faculty(faculty_id)
);

INSERT INTO complaint_category (category_name) VALUES
('Hostel'),
('Academic'),
('Infrastructure'),
('Canteen'),
('IT/Network'),
('Other');

INSERT INTO administrators (name, email, password)
VALUES (
    'Default Admin',
    'admin@college.edu',
    SHA2('admin123', 256)
);

INSERT INTO faculty (name, email, password, department) VALUES
('Dr. Sharma', 'sharma@college.edu', SHA2('faculty123', 256), 'Computer Science'),
('Dr. Verma', 'verma@college.edu', SHA2('faculty123', 256), 'Administration');
