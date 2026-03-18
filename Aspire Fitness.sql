CREATE DATABASE IF NOT EXISTS GymDB;
USE GymDB;

CREATE TABLE Members (
    membership_number VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    address TEXT,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    date_of_birth DATE,
    medical_conditions TEXT,
    weekly_charge DECIMAL(6,2) DEFAULT 10.00,
    join_date DATE DEFAULT (CURDATE())
);

INSERT INTO Members (
membership_number, first_name, surname, address, phone, email, date_of_birth, medical_conditions, weekly_charge, join_date
) VALUES
('M001', 'Sanjay', 'Shrestha', 'Kathmandu, Nepal', '+977-9841234567', 'sanjayshrestha@gmail.com', '1995-06-15', 'None', 350.00, '2026-03-10'),
('M002', 'Anita', 'Koirala', 'Lalitpur, Nepal', '+977-9801234568', 'anitakoirala@gmail.com', '1998-09-22', 'Asthma', 400.00, '2026-03-08'),
('M003', 'Ramesh', 'Thapa', 'Bhaktapur, Nepal', '+977-9812345670', 'rameshthapa@gmail.com', '1990-12-05', 'Diabetes', 320.00, '2026-03-05'),
('M004', 'Priya', 'Gurung', 'Pokhara, Nepal', '+977-9851234569', 'priyagurung@gmail.com', '2000-03-12', 'None', 370.00, '2026-03-09'),
('M005', 'Bikash', 'Rai', 'Biratnagar, Nepal', '+977-9861234570', 'bikashrai@gmail.com', '1992-11-30', 'Hypertension', 390.00, '2026-03-07');

CREATE TABLE IF NOT EXISTS Staff (
    staff_number VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    role ENUM('personal trainer', 'class instructor', 'gym staff', 'manager', 'administration') NOT NULL,
    phone VARCHAR(15)
);

INSERT INTO Staff (
    staff_number, first_name, surname, role, phone
) VALUES
('S001', 'Rohan', 'Shrestha', 'personal trainer', '+977-9841122334'),
('S002', 'Sita', 'Koirala', 'class instructor', '+977-9801122335'),
('S003', 'Prakash', 'Thapa', 'gym staff', '+977-9811122336'),
('S004', 'Manisha', 'Gurung', 'manager', '+977-9851122337'),
('S005', 'Bikram', 'Rai', 'administration', '+977-9861122338');

CREATE TABLE IF NOT EXISTS Facilities (
    facility_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    max_capacity INT NOT NULL CHECK (max_capacity > 0)
);

INSERT INTO Facilities (name, max_capacity) VALUES
('Weight Training Area', 30),
('Cardio Zone', 25),
('Yoga Room', 20),
('CrossFit Area', 15),
('Zumba Hall', 22);

CREATE TABLE IF NOT EXISTS Classes (
    class_code VARCHAR(10) PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    instructor_id VARCHAR(10),
    day_of_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'),
    time_slot TIME,
    max_size INT NOT NULL CHECK (max_size > 0),
    FOREIGN KEY (instructor_id) REFERENCES Staff(staff_number),
    UNIQUE KEY unique_class_schedule (instructor_id, day_of_week, time_slot)
);

INSERT INTO Classes VALUES
('C001', 'Yoga Flow', 'S001', 'Monday', '09:00:00', 15),
('C002', 'Zumba', 'S002', 'Wednesday', '18:00:00', 20),
('C003', 'Pilates', 'S001', 'Friday', '10:00:00', 12),
('C004', 'Tai Chi', 'S002', 'Tuesday', '07:00:00', 10),
('C005', 'Dance Fit', 'S003', 'Thursday', '19:00:00', 18);

CREATE TABLE IF NOT EXISTS FacilityBookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    membership_number VARCHAR(10) NOT NULL,
    facility_id INT NOT NULL,
    booking_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (membership_number) REFERENCES Members(membership_number),
    FOREIGN KEY (facility_id) REFERENCES Facilities(facility_id),

    CHECK (end_time > start_time),
    CHECK (TIME_TO_SEC(TIMEDIFF(end_time, start_time)) <= 7200)
);

INSERT INTO FacilityBookings VALUES
(NULL, 'M001', 1, '2026-03-10', '14:00:00', '15:00:00'), -- Main Hall 1hr OK
(NULL, 'M002', 2, '2026-03-10', '16:00:00', '17:00:00');  -- Yoga Hall OK
CREATE TABLE IF NOT EXISTS ClassBookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    membership_number VARCHAR(10) NOT NULL,
    class_code VARCHAR(10) NOT NULL,
    booking_date DATE NOT NULL,
    attendance_status ENUM('booked', 'attended', 'cancelled') DEFAULT 'booked',
    FOREIGN KEY (membership_number) REFERENCES Members(membership_number),
    FOREIGN KEY (class_code) REFERENCES Classes(class_code)
);

INSERT INTO ClassBookings VALUES
(NULL, 'M001', 'C001', '2026-03-10', 'booked'),
(NULL, 'M001', 'C002', '2026-03-10', 'booked'),
(NULL, 'M002', 'C003', '2026-03-10', 'attended');

-- INDEXES
CREATE INDEX idx_fb_member_week ON FacilityBookings(membership_number, YEARWEEK(booking_date));
CREATE INDEX idx_fb_facility_time ON FacilityBookings(facility_id, booking_date, start_time);
CREATE INDEX idx_cb_member_week ON ClassBookings(membership_number, YEARWEEK(booking_date));

-- TRIGGER : PREVENT OVERLAPPING FACILITY BOOKINGS
DELIMITER $$
CREATE TRIGGER trg_prevent_overlap
BEFORE INSERT ON FacilityBookings
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT DEFAULT 0;

    SELECT COUNT(*) INTO overlap_count
    FROM FacilityBookings
    WHERE facility_id = NEW.facility_id
      AND booking_date = NEW.booking_date
      AND start_time < NEW.end_time
      AND end_time > NEW.start_time;

    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Facility already booked for this time slot';
    END IF;
END$$

DELIMITER ;

--  MEMBER'S CURRENT WEEK ACTIVITIES (M001)
SELECT 
    'Facility' as type,
    fb.start_time, fb.end_time, f.name as facility,
    NULL as class_name
FROM FacilityBookings fb
JOIN Facilities f ON fb.facility_id = f.facility_id
WHERE fb.membership_number = 'M001' 
  AND YEARWEEK(fb.booking_date) = YEARWEEK(CURDATE())
UNION ALL
SELECT 
    'Class' as type,
    c.time_slot as start_time, 
    DATE_ADD(c.time_slot, INTERVAL 1 HOUR) as end_time,
    NULL as facility,
    c.class_name
FROM ClassBookings cb
JOIN Classes c ON cb.class_code = c.class_code
WHERE cb.membership_number = 'M001'
  AND YEARWEEK(cb.booking_date) = YEARWEEK(CURDATE())
ORDER BY start_time;

-- QUERY 2: INSTRUCTOR CLASSES THIS WEEK (S001) - FIXED
SELECT 
    class_code, class_name, day_of_week, time_slot, max_size
FROM Classes 
WHERE instructor_id = 'S001'
ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'), time_slot;

SELECT *
FROM Members
ORDER BY membership_number;

SELECT staff_number, first_name, surname
FROM Staff
WHERE role = 'class instructor';

SELECT facility_id, name, max_capacity
FROM Facilities
ORDER BY facility_id;

SELECT class_code, class_name, day_of_week, time_slot
FROM Classes
WHERE instructor_id = 'S001';

SELECT c.class_name, COUNT(cb.booking_id) AS total_bookings
FROM Classes c
JOIN ClassBookings cb
ON c.class_code = cb.class_code
GROUP BY c.class_name
ORDER BY total_bookings DESC;

SELECT membership_number, COUNT(booking_id) AS total_bookings
FROM ClassBookings
GROUP BY membership_number
HAVING COUNT(booking_id) > 1;

SELECT s.staff_number, s.first_name, s.surname, COUNT(c.class_code) AS total_classes
FROM Staff s
LEFT JOIN Classes c
ON s.staff_number = c.instructor_id
GROUP BY s.staff_number, s.first_name, s.surname;