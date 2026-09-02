-- ============================================
-- MediCare Hospital Appointment Database
-- Database: hospitaldb
-- ============================================

CREATE DATABASE IF NOT EXISTS hospitaldb;

USE hospitaldb;

-- ============================================
-- Departments
-- ============================================

CREATE TABLE IF NOT EXISTS departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- ============================================
-- Doctors
-- ============================================

CREATE TABLE IF NOT EXISTS doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_name VARCHAR(150) NOT NULL,
    department_id INT NOT NULL,
    designation VARCHAR(100),
    rating DECIMAL(2,1),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_doctor_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- ============================================
-- Patients
-- ============================================

CREATE TABLE IF NOT EXISTS patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(150) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Appointments
-- ============================================

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    department_id INT NOT NULL,
    preferred_date DATE NOT NULL,
    status VARCHAR(30) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_appointment_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- ============================================
-- Insert Departments
-- ============================================

INSERT INTO departments
    (department_name, description)
VALUES
    ('General Medicine',
     'Comprehensive primary healthcare for everyday medical needs.'),

    ('Cardiology',
     'Expert heart care from experienced cardiology specialists.'),

    ('Neurology',
     'Advanced diagnosis and treatment for neurological conditions.'),

    ('Orthopedics',
     'Specialized treatment for bones, joints and mobility.')
ON DUPLICATE KEY UPDATE
    description = VALUES(description);

-- ============================================
-- Insert Doctors
-- ============================================

INSERT INTO doctors
    (doctor_name, department_id, designation, rating)
SELECT
    'Dr. Sarah Wilson',
    department_id,
    'Senior Cardiologist',
    4.9
FROM departments
WHERE department_name = 'Cardiology'
AND NOT EXISTS (
    SELECT 1
    FROM doctors
    WHERE doctor_name = 'Dr. Sarah Wilson'
);

INSERT INTO doctors
    (doctor_name, department_id, designation, rating)
SELECT
    'Dr. Emily Carter',
    department_id,
    'Neurologist',
    4.8
FROM departments
WHERE department_name = 'Neurology'
AND NOT EXISTS (
    SELECT 1
    FROM doctors
    WHERE doctor_name = 'Dr. Emily Carter'
);

INSERT INTO doctors
    (doctor_name, department_id, designation, rating)
SELECT
    'Dr. Michael Brown',
    department_id,
    'Orthopedic Surgeon',
    4.9
FROM departments
WHERE department_name = 'Orthopedics'
AND NOT EXISTS (
    SELECT 1
    FROM doctors
    WHERE doctor_name = 'Dr. Michael Brown'
);

-- ============================================
-- Verify Data
-- ============================================

SELECT * FROM departments;

SELECT
    d.doctor_id,
    d.doctor_name,
    dep.department_name,
    d.designation,
    d.rating
FROM doctors d
JOIN departments dep
    ON d.department_id = dep.department_id;

SELECT * FROM patients;

SELECT * FROM appointments;
