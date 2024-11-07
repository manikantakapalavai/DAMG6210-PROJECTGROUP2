
-- 1. Airport
INSERT INTO Airport (AirportName, [Type], City, Area, Country) VALUES
('John F. Kennedy International', 'International', 'New York', 'Queens', 'USA'),
('Los Angeles International', 'International', 'Los Angeles', 'Westchester', 'USA'),
('Heathrow', 'International', 'London', 'Hillingdon', 'UK'),
('Dubai International', 'International', 'Dubai', 'Garhoud', 'UAE'),
('Tokyo Haneda', 'International', 'Tokyo', 'Ota', 'Japan'),
('Sydney Kingsford Smith', 'International', 'Sydney', 'Mascot', 'Australia'),
('San Francisco International', 'International', 'San Francisco', 'San Mateo', 'USA'),
('Changi', 'International', 'Singapore', 'Changi', 'Singapore'),
('Charles de Gaulle', 'International', 'Paris', 'Roissy-en-France', 'France'),
('Frankfurt Airport', 'International', 'Frankfurt', 'Frankfurt', 'Germany'),
('Suvarnabhumi', 'International', 'Bangkok', 'Racha Thewa', 'Thailand'),
('Beijing Capital', 'International', 'Beijing', 'Chaoyang', 'China'),
('Incheon International', 'International', 'Incheon', 'Jung-gu', 'South Korea'),
('Indira Gandhi International', 'International', 'Delhi', 'Palam', 'India'),
('Sheremetyevo', 'International', 'Moscow', 'Moscow Oblast', 'Russia');

SELECT * FROM Airport;

-- 2. Airline
INSERT INTO Airline (AirlineName, Country) VALUES
('American Airlines', 'USA'),
('Delta Airlines', 'USA'),
('British Airways', 'UK'),
('Emirates', 'UAE'),
('Japan Airlines', 'Japan'),
('Qantas', 'Australia'),
('Singapore Airlines', 'Singapore'),
('Air France', 'France'),
('Lufthansa', 'Germany'),
('Thai Airways', 'Thailand'),
('Air China', 'China'),
('Korean Air', 'South Korea'),
('Air India', 'India'),
('Aeroflot', 'Russia'),
('Cathay Pacific', 'Hong Kong');

SELECT * FROM Airline;

-- 3. Passenger
INSERT INTO Passenger (FirstName, LastName, Age, Nationality, CheckInStatus, CustomerFeedback) VALUES
('John', 'Doe', 29, 'American', 0, 'Pleasant experience'),
('Jane', 'Smith', 34, 'British', 1, 'Smooth process'),
('Akira', 'Tanaka', 42, 'Japanese', 1, 'Staff was helpful'),
('Suresh', 'Kumar', 50, 'Indian', 0, 'Good but crowded'),
('Maria', 'Garcia', 25, 'Spanish', 1, 'Loved the airport'),
('Ahmed', 'Al Fahim', 38, 'Emirati', 1, 'Very clean'),
('Pierre', 'Dubois', 31, 'French', 1, 'Long security line'),
('Wei', 'Liu', 28, 'Chinese', 0, 'Excellent facilities'),
('Anna', 'Schmidt', 45, 'German', 1, 'Very organized'),
('Lee', 'Choi', 27, 'South Korean', 1, 'Good amenities'),
('Olga', 'Ivanova', 33, 'Russian', 0, 'Needs improvement'),
('Juan', 'Carlos', 36, 'Mexican', 1, 'Efficient process'),
('Emily', 'Brown', 40, 'Canadian', 1, 'Good assistance'),
('Sarah', 'Wilson', 22, 'Australian', 1, 'Easy navigation'),
('Michael', 'Johnson', 47, 'American', 0, 'Crowded but fast');

SELECT * FROM Passenger;

-- 4. Phone
INSERT INTO Phone (PassengerID, PhoneType, PhoneNumber) VALUES
(3000, 'Mobile', '1234567890'),
(3001, 'Home', '2125551234'),
(3002, 'Work', '3055556789'),
(3003, 'Mobile', '9876543210'),
(3004, 'Mobile', '4145554567'),
(3005, 'Home', '08642256639'),
(3006, 'Work', '2135553456'),
(3007, 'Mobile', '4085555678'),
(3008, 'Home', '08642256924'),
(3009, 'Work', '4155551234'),
(3010, 'Mobile', '4955556789'),
(3011, 'Home', '5555554321'),
(3012, 'Mobile', '6045559876'),
(3013, 'Work', '9295558765'),
(3014, 'Home', '9175553456');

SELECT * FROM Phone;

-- 5. LoyaltyProgram
INSERT INTO LoyaltyProgram (PassengerID, LoyaltyPoints, LoyaltyStatus, EnrollmentDate) VALUES
(3000, 1200, 'Gold', '2022-03-01 10:30:00'),
(3001, 900, 'Silver', '2021-10-10 09:45:00'),
(3002, 1500, 'Platinum', '2023-01-15 15:20:00'),
(3003, 800, 'Silver', '2020-06-20 11:05:00'),
(3004, 2000, 'Platinum', '2023-05-05 14:10:00'),
(3005, 1000, 'Gold', '2021-02-14 13:00:00'),
(3006, 700, 'Silver', '2021-08-22 08:50:00'),
(3007, 1800, 'Platinum', '2022-12-12 16:00:00'),
(3008, 500, 'Silver', '2020-03-30 10:00:00'),
(3009, 1300, 'Gold', '2022-07-01 12:40:00'),
(3010, 900, 'Silver', '2021-11-15 09:20:00'),
(3011, 1100, 'Gold', '2023-02-17 13:30:00'),
(3012, 1500, 'Platinum', '2023-06-10 14:45:00'),
(3013, 600, 'Silver', '2021-09-05 07:55:00'),
(3014, 2000, 'Platinum', '2022-01-25 17:10:00');

SELECT * FROM LoyaltyProgram;

-- Step 1: Enable explicit insertion on the identity column
SET IDENTITY_INSERT Employee ON;

-- 6. Employee
INSERT INTO Employee (EmployeeID, FirstName, LastName, Salary, Employee_Type) VALUES
(10000, 'Alice', 'Williams', 75000, 'AirplaneStaff'),
(10001, 'Bob', 'Johnson', 62000, 'SecurityStaff'),
(10002, 'Charlie', 'Brown', 68000, 'GroundStaff'),
(10003, 'Diana', 'Clark', 72000, 'AirplaneStaff'),
(10004, 'Edward', 'Harris', 55000, 'GroundStaff'),
(10005, 'Fiona', 'Martinez', 77000, 'AirplaneStaff'),
(10006, 'George', 'Miller', 60000, 'SecurityStaff'),
(10007, 'Helen', 'Moore', 63000, 'GroundStaff'),
(10008, 'Ian', 'Taylor', 58000, 'SecurityStaff'),
(10009, 'Julia', 'Anderson', 74000, 'AirplaneStaff'),
(10010, 'Kevin', 'Thomas', 64000, 'GroundStaff'),
(10011, 'Laura', 'Jackson', 80000, 'AirplaneStaff'),
(10012, 'Michael', 'White', 71000, 'SecurityStaff'),
(10013, 'Nancy', 'Lee', 66000, 'GroundStaff'),
(10014, 'Oliver', 'Young', 79000, 'AirplaneStaff'),
(10015, 'Paul', 'Walker', 62000, 'SecurityStaff'),
(10016, 'Rachel', 'Green', 65000, 'GroundStaff'),
(10017, 'Sam', 'Wilson', 71000, 'AirplaneStaff'),
(10018, 'Tina', 'Hall', 69000, 'GroundStaff'),
(10019, 'Victor', 'Stone', 73000, 'SecurityStaff'),
(10020, 'Wendy', 'James', 76000, 'AirplaneStaff'),
(10021, 'Xander', 'Scott', 60000, 'GroundStaff'),
(10022, 'Yara', 'Diaz', 72000, 'SecurityStaff'),
(10023, 'Zoe', 'Black', 75000, 'AirplaneStaff'),
(10024, 'Adam', 'Evans', 68000, 'GroundStaff'),
(10025, 'Bella', 'Carter', 81000, 'AirplaneStaff'),
(10026, 'Chris', 'Cooper', 70000, 'SecurityStaff'),
(10027, 'Derek', 'Hill', 67000, 'GroundStaff'),
(10028, 'Evelyn', 'Ross', 76000, 'AirplaneStaff'),
(10029, 'Frank', 'Wood', 66000, 'SecurityStaff');

-- Step 3: Turn off IDENTITY_INSERT to resume auto-incrementing
SET IDENTITY_INSERT Employee OFF;

SELECT * FROM Employee;

-- 7. AirplaneStaff
INSERT INTO AirplaneStaff (EmployeeID, AirlineID, Position, LicenseNumber, YearsOfExperience, FlightHours, MedicalClearance) VALUES
(10000, 100, 'Pilot', 'PLT001', 10, 1500.5, '2023-01-01'),
(10003, 101, 'Co-Pilot', 'CPL002', 8, 1200.7, '2022-11-12'),
(10005, 102, 'Flight Attendant', 'FA003', 5, 800.3, '2021-08-10'),
(10009, 103, 'Cabin Crew', 'CC004', 3, 600.2, '2023-04-05'),
(10011, 104, 'Pilot', 'PLT005', 12, 1700.1, '2023-03-20'),
(10015, 105, 'Co-Pilot', 'CPL006', 7, 1100.4, '2022-07-15'),
(10017, 106, 'Flight Attendant', 'FA007', 4, 750.5, '2021-12-20'),
(10019, 107, 'Cabin Crew', 'CC008', 6, 850.9, '2023-06-01'),
(10023, 108, 'Pilot', 'PLT009', 15, 2000.8, '2023-02-25'),
(10025, 109, 'Co-Pilot', 'CPL010', 9, 1300.3, '2022-09-15');

SELECT * FROM AirplaneStaff;

-- 8. Specialization
INSERT INTO Specialization (EmployeeID, Specialization, CertificationDate) VALUES
(10000, 'Pilot Training', '2021-03-01'),
(10003, 'Emergency Procedures', '2022-05-12'),
(10005, 'Customer Service', '2021-10-10'),
(10009, 'Safety Protocols', '2022-11-15'),
(10011, 'Aircraft Systems Operation', '2023-02-25'),
(10015, 'Pilot Training', '2021-08-18'),
(10017, 'Emergency Procedures', '2023-03-14'),
(10019, 'Safety Protocols', '2021-09-20'),
(10023, 'Customer Service', '2022-07-01'),
(10025, 'Aircraft Systems Operation', '2022-12-10');


SELECT * FROM Specialization;

-- 9. Certification
INSERT INTO Certification (EmployeeID, CertificationLevel, IssueDate, ExpiryDate) VALUES
(10000, 'Pilot License', '2021-05-01', '2024-05-01'),
(10003, 'Safety Training', '2022-06-10', '2025-06-10'),
(10005, 'Emergency Procedures', '2023-01-15', '2026-01-15'),
(10009, 'Pilot License', '2021-11-20', '2024-11-20'),
(10011, 'Safety Training', '2022-09-05', '2025-09-05'),
(10015, 'Emergency Procedures', '2023-04-18', '2026-04-18'),
(10017, 'Safety Training', '2021-12-12', '2024-12-12'),
(10019, 'Emergency Procedures', '2022-08-22', '2025-08-22'),
(10023, 'Pilot License', '2023-03-30', '2026-03-30'),
(10025, 'Safety Training', '2022-10-15', '2025-10-15');


SELECT * FROM Certification;

-- 10. SecurityStaff
INSERT INTO SecurityStaff (EmployeeID, AirportID, AssignedArea, SecurityClearanceLevel, TrainingCompleted, ShiftStart, ShiftEnd, Role) VALUES
(10001, 1, 'Terminal Security', 'Medium', '2021-12-01', '2023-07-01 08:00:00', '2023-07-01 16:00:00', 'Security Officer'),
(10006, 2, 'Customs', 'High', '2022-05-15', '2023-07-01 10:00:00', '2023-07-01 18:00:00', 'Customs Officer'),
(10008, 1, 'Runway Access', 'Top Secret', '2022-11-10', '2023-07-01 06:00:00', '2023-07-01 14:00:00', 'Runway Security'),
(10012, 3, 'Baggage Handling', 'Low', '2021-09-20', '2023-07-01 07:00:00', '2023-07-01 15:00:00', 'Baggage Security'),
(10015, 4, 'Terminal Security', 'Medium', '2023-01-12', '2023-07-01 14:00:00', '2023-07-01 22:00:00', 'Security Officer'),
(10019, 2, 'Customs', 'High', '2022-07-18', '2023-07-01 09:00:00', '2023-07-01 17:00:00', 'Customs Officer'),
(10022, 1, 'Runway Access', 'Top Secret', '2021-06-05', '2023-07-01 12:00:00', '2023-07-01 20:00:00', 'Runway Security'),
(10026, 3, 'Baggage Handling', 'Low', '2022-03-25', '2023-07-01 15:00:00', '2023-07-01 23:00:00', 'Baggage Security'),
(10029, 2, 'Customs', 'High', '2022-10-30', '2023-07-01 11:00:00', '2023-07-01 19:00:00', 'Customs Officer');

SELECT * FROM SecurityStaff;

-- 11. GroundStaff
INSERT INTO GroundStaff (EmployeeID, AirportID, AssignedTasks, ShiftGroup) VALUES
(10002, 1, 'Loading/Unloading', 'A'),
(10004, 3, 'Maintenance Support', 'B'),
(10007, 2, 'Equipment Operation', 'C'),
(10010, 4, 'Fueling Assistance', 'D'),
(10013, 1, 'Loading/Unloading', 'A'),
(10016, 2, 'Maintenance Support', 'B'),
(10018, 3, 'Equipment Operation', 'C'),
(10021, 4, 'Fueling Assistance', 'D'),
(10024, 1, 'Loading/Unloading', 'A'),
(10027, 3, 'Maintenance Support', 'B');

SELECT * FROM GroundStaff;

-- 12. GroundSupport
INSERT INTO GroundSupport (EquipmentType, GSM_Status, UsageDuration, MaintenanceFrequency) VALUES
('Baggage Cart', 'Operational', '02:00:00', 'Monthly'),
('Fuel Truck', 'Operational', '03:00:00', 'Yearly'),
('Tow Tractor', 'Out of Service', '01:30:00', 'Monthly'),
('Ground Power Unit', 'Operational', '02:15:00', 'Yearly'),
('De-icing Truck', 'Operational', '04:00:00', 'Monthly'),
('Pushback Tug', 'Out of Service', '02:45:00', 'Monthly'),
('Air Start Unit', 'Operational', '01:00:00', 'Yearly'),
('Belt Loader', 'Operational', '03:30:00', 'Monthly'),
('Catering Truck', 'Out of Service', '02:20:00', 'Monthly'),
('Lavatory Service Truck', 'Operational', '01:50:00', 'Yearly'),
('Water Service Truck', 'Operational', '01:10:00', 'Monthly'),
('Aircraft Towbar', 'Out of Service', '01:40:00', 'Monthly'),
('Passenger Stair', 'Operational', '02:30:00', 'Yearly'),
('Air Conditioning Unit', 'Operational', '03:00:00', 'Monthly'),
('Fire Extinguisher Cart', 'Operational', '00:45:00', 'Yearly');

SELECT * FROM GroundSupport;

-- 13. EquipmentAssignment
INSERT INTO EquipmentAssignment (EquipmentID, EmployeeID, Assign_Date) VALUES
(440, 10002, '2023-07-01 08:00:00'),
(441, 10004, '2023-07-02 09:00:00'),
(442, 10007, '2023-07-03 10:00:00'),
(443, 10010, '2023-07-04 11:00:00'),
(444, 10013, '2023-07-05 12:00:00'),
(445, 10016, '2023-07-06 13:00:00'),
(446, 10018, '2023-07-07 14:00:00'),
(447, 10021, '2023-07-08 15:00:00'),
(448, 10024, '2023-07-09 16:00:00'),
(449, 10027, '2023-07-10 17:00:00'),
(450, 10018, '2023-07-11 18:00:00'),
(451, 10021, '2023-07-12 19:00:00'),
(452, 10024, '2023-07-13 20:00:00'),
(453, 10027, '2023-07-14 21:00:00'),
(454, 10002, '2023-07-15 22:00:00');


SELECT * FROM EquipmentAssignment;

-- 14. RunwayManagement
INSERT INTO RunwayManagement (AirportID, RunwayNumber, OccupiedStatus) VALUES
(1, 'Runway 1', 'Available'),
(2, 'Runway 2', 'Occupied'),
(3, 'Runway 3', 'Available'),
(4, 'Runway 4', 'Not in Use'),
(5, 'Runway 5', 'Available'),
(6, 'Runway 6', 'Occupied'),
(7, 'Runway 7', 'Available'),
(8, 'Runway 8', 'Not in Use'),
(9, 'Runway 9', 'Available'),
(10, 'Runway 10', 'Occupied'),
(11, 'Runway 11', 'Available'),
(12, 'Runway 12', 'Not in Use'),
(13, 'Runway 13', 'Available'),
(14, 'Runway 14', 'Occupied'),
(15, 'Runway 15', 'Not in Use');

SELECT * FROM RunwayManagement;

-- 15. Aircraft
INSERT INTO Aircraft (AirlineID, RunwayID, AircraftType, Capacity, FuelConsumption, AircraftAge) VALUES
(101, 1, 'Boeing 737', 180, 2400.50, 5),
(102, 2, 'Airbus A320', 200, 2100.75, 3),
(103, 3, 'Boeing 787', 240, 3200.00, 7),
(104, 4, 'Airbus A380', 300, 4100.25, 10),
(105, 5, 'Boeing 747', 350, 3900.00, 12),
(106, 6, 'Embraer E190', 100, 1800.50, 2),
(107, 7, 'Boeing 737 MAX', 180, 2200.75, 4),
(108, 8, 'Airbus A330', 260, 3300.60, 6),
(109, 9, 'Boeing 777', 300, 4000.00, 8),
(110, 10, 'Boeing 767', 220, 3100.00, 9),
(111, 11, 'Airbus A321', 190, 2500.50, 5),
(112, 12, 'Boeing 757', 200, 2600.75, 6),
(113, 13, 'Bombardier CRJ', 90, 1500.20, 3),
(114, 14, 'Cessna 172', 4, 150.00, 1),
(100, 15, 'Gulfstream G650', 10, 300.75, 2);

SELECT * FROM Aircraft;

-- 16. Maintenance
INSERT INTO Maintenance (AircraftID, EquipmentID, MaintenanceDate, MaintenanceType, MaintenanceDuration, NextScheduledMaintenance, MaintenanceStatus) VALUES
(1, 440, '2024-01-10 09:00:00', 'Routine Check', '02:00:00', '2024-02-10 09:00:00', 'Completed'),
(2, 441, '2024-01-12 10:00:00', 'Engine Check', '04:00:00', '2024-03-12 10:00:00', 'Completed'),
(3, 442, '2024-01-15 11:00:00', 'Landing Gear Inspection', '03:00:00', '2024-04-15 11:00:00', 'Completed'),
(4, 443, '2024-01-18 12:00:00', 'Hydraulic System Maintenance', '02:30:00', '2024-02-18 12:00:00', 'Pending'),
(5, 444, '2024-01-20 13:00:00', 'Fuel System Check', '01:30:00', '2024-03-20 13:00:00', 'Completed'),
(6, 445, '2024-01-22 14:00:00', 'Avionics Upgrade', '05:00:00', '2024-04-22 14:00:00', 'In Progress'),
(7, 446, '2024-01-24 15:00:00', 'Engine Replacement', '06:00:00', '2024-07-24 15:00:00', 'In Progress'),
(8, 447, '2024-01-26 16:00:00', 'Cabin Maintenance', '03:30:00', '2024-02-26 16:00:00', 'Completed'),
(9, 448, '2024-01-28 17:00:00', 'Exterior Cleaning', '01:00:00', '2024-03-28 17:00:00', 'Completed'),
(10, 449, '2024-01-30 18:00:00', 'Safety Inspection', '02:30:00', '2024-05-30 18:00:00', 'Pending'),
(11, 450, '2024-02-01 09:00:00', 'Wheel Alignment', '01:30:00', '2024-06-01 09:00:00', 'Completed'),
(12, 451, '2024-02-03 10:00:00', 'Engine Overhaul', '04:30:00', '2024-05-03 10:00:00', 'Completed'),
(13, 452, '2024-02-05 11:00:00', 'Hydraulic System Maintenance', '02:00:00', '2024-08-05 11:00:00', 'Completed'),
(14, 453, '2024-02-07 12:00:00', 'Routine Check', '01:30:00', '2024-04-07 12:00:00', 'Pending'),
(15, 454, '2024-02-09 13:00:00', 'Fuel System Check', '02:00:00', '2024-06-09 13:00:00', 'In Progress');

SELECT * FROM Maintenance;

-- 17. Gate
INSERT INTO Gate (AirportID, GateNumber, Terminal, GateStatus) VALUES
(1, 'A1', 'Terminal 1', 'Available'),
(2, 'B2', 'Terminal 2', 'Occupied'),
(3, 'C3', 'Terminal 3', 'Available'),
(4, 'D4', 'Terminal 1', 'Available'),
(5, 'E5', 'Terminal 2', 'Occupied'),
(6, 'F6', 'Terminal 3', 'Available'),
(7, 'G7', 'Terminal 1', 'Occupied'),
(8, 'H8', 'Terminal 2', 'Available'),
(9, 'I9', 'Terminal 3', 'Occupied'),
(10, 'J10', 'Terminal 1', 'Available'),
(11, 'K11', 'Terminal 2', 'Occupied'),
(12, 'L12', 'Terminal 3', 'Available'),
(13, 'M13', 'Terminal 1', 'Available'),
(14, 'N14', 'Terminal 2', 'Occupied'),
(15, 'O15', 'Terminal 3', 'Available');

SELECT * FROM Gate;

-- 18. Flight
INSERT INTO Flight (SourceAirportID, DestinationAirportID, AirlineID, RunwayID, AircraftID, GateID, FlightNumber, FlightName, Capacity, DepartureTime, ArrivalTime, FlightPrice, FlightStatus) VALUES
(1, 2, 101, 1, 1, 1, 'AA1001', 'American Airlines 1001', 180, '2024-01-15 08:00:00', '2024-01-15 12:00:00', 500.00, 'Scheduled'),
(2, 3, 102, 2, 2, 2, 'DL2002', 'Delta Airlines 2002', 200, '2024-01-16 09:30:00', '2024-01-16 13:45:00', 650.00, 'Scheduled'),
(3, 4, 103, 3, 3, 3, 'UA3003', 'United Airlines 3003', 220, '2024-01-17 10:00:00', '2024-01-17 14:20:00', 700.00, 'Scheduled'),
(4, 5, 104, 4, 4, 4, 'BA4004', 'British Airways 4004', 240, '2024-01-18 11:00:00', '2024-01-18 15:30:00', 800.00, 'Scheduled'),
(5, 6, 105, 5, 5, 5, 'AF5005', 'Air France 5005', 260, '2024-01-19 12:30:00', '2024-01-19 16:45:00', 850.00, 'Scheduled'),
(6, 7, 106, 6, 6, 6, 'LH6006', 'Lufthansa 6006', 180, '2024-01-20 13:00:00', '2024-01-20 17:15:00', 550.00, 'Scheduled'),
(7, 8, 107, 7, 7, 7, 'EK7007', 'Emirates 7007', 200, '2024-01-21 14:30:00', '2024-01-21 18:50:00', 920.00, 'Scheduled'),
(8, 9, 108, 8, 8, 8, 'QR8008', 'Qatar Airways 8008', 220, '2024-01-22 15:00:00', '2024-01-22 19:00:00', 980.00, 'Scheduled'),
(9, 10, 109, 9, 9, 9, 'CX9009', 'Cathay Pacific 9009', 240, '2024-01-23 16:00:00', '2024-01-23 20:10:00', 1100.00, 'Scheduled'),
(10, 11, 110, 10, 10, 10, 'SQ1010', 'Singapore Airlines 1010', 260, '2024-01-24 17:30:00', '2024-01-24 21:30:00', 1150.00, 'Scheduled'),
(11, 12, 111, 11, 11, 11, 'JL1111', 'Japan Airlines 1111', 180, '2024-01-25 18:00:00', '2024-01-25 22:00:00', 600.00, 'Scheduled'),
(12, 13, 112, 12, 12, 12, 'KE1212', 'Korean Air 1212', 200, '2024-01-26 19:30:00', '2024-01-26 23:30:00', 700.00, 'Scheduled'),
(13, 14, 113, 13, 13, 13, 'QF1313', 'Qantas 1313', 220, '2024-01-27 20:00:00', '2024-01-28 00:20:00', 750.00, 'Scheduled'),
(14, 15, 114, 14, 14, 14, 'SA1414', 'South African Airways 1414', 240, '2024-01-28 21:00:00', '2024-01-29 01:30:00', 820.00, 'Scheduled'),
(15, 1, 100, 15, 15, 15, 'AC1515', 'Air Canada 1515', 260, '2024-01-29 22:30:00', '2024-01-30 02:45:00', 900.00, 'Scheduled');

SELECT * FROM Flight;

-- 19. FlightBooking
INSERT INTO FlightBooking (FlightID, PassengerID, PurchaseDate, FareClass, BookingStatus, TicketPrice) VALUES
(1, 3000, '2024-01-01 10:00:00', 'Economy', 'Confirmed', 400.00),
(2, 3001, '2024-01-02 11:30:00', 'Business', 'Confirmed', 800.00),
(3, 3002, '2024-01-03 09:45:00', 'Economy', 'Pending', 450.00),
(4, 3003, '2024-01-04 12:15:00', 'First', 'Cancelled', 1200.00),
(5, 3004, '2024-01-05 13:30:00', 'Business', 'Confirmed', 700.00),
(6, 3005, '2024-01-06 14:45:00', 'Economy', 'Confirmed', 300.00),
(7, 3006, '2024-01-07 16:00:00', 'Economy', 'Confirmed', 450.00),
(8, 3007, '2024-01-08 17:15:00', 'First', 'Confirmed', 1100.00),
(9, 3008, '2024-01-09 18:30:00', 'Economy', 'Confirmed', 350.00),
(10, 3009, '2024-01-10 19:45:00', 'Business', 'Pending', 750.00),
(11, 3010, '2024-01-11 21:00:00', 'First', 'Confirmed', 1250.00),
(12, 3011, '2024-01-12 08:00:00', 'Economy', 'Cancelled', 420.00),
(13, 3012, '2024-01-13 10:30:00', 'Economy', 'Confirmed', 380.00),
(14, 3013, '2024-01-14 13:15:00', 'Business', 'Confirmed', 900.00),
(15, 3014, '2024-01-15 15:45:00', 'Economy', 'Confirmed', 470.00);

SELECT * FROM FlightBooking;

-- 20. BoardingPass
INSERT INTO BoardingPass (PassengerID, TicketID, SeatNumber, BoardingGroup, IssueTime) VALUES
(3000, 1, '12A', 'A', '2024-01-01 09:00:00'),
(3001, 2, '15B', 'B', '2024-01-02 10:00:00'),
(3002, 3, '17C', 'C', '2024-01-03 08:45:00'),
(3003, 4, '20D', 'D', '2024-01-04 09:15:00'),
(3004, 5, '22E', 'A', '2024-01-05 12:30:00'),
(3005, 6, '10F', 'A', '2024-01-06 13:45:00'),
(3006, 7, '14G', 'B', '2024-01-07 15:00:00'),
(3007, 8, '18H', 'C', '2024-01-08 17:15:00'),
(3008, 9, '16A', 'D', '2024-01-09 18:30:00'),
(3009, 10, '21B', 'A', '2024-01-10 19:00:00'),
(3010, 11, '19C', 'A', '2024-01-11 21:15:00'),
(3011, 12, '23D', 'B', '2024-01-12 07:00:00'),
(3012, 13, '11E', 'C', '2024-01-13 09:00:00'),
(3013, 14, '13A', 'D', '2024-01-14 10:30:00'),
(3014, 15, '24B', 'B', '2024-01-15 11:45:00');

SELECT * FROM BoardingPass;

-- 21. Luggage
INSERT INTO Luggage (AirportID, TicketID, PassengerID, NumberOfBags, [Weight], [Status], BaggageLocation) VALUES
(1, 1, 3000, 2, 40.5, 'Checked In', 'Terminal 1 - Area B'),
(2, 2, 3001, 1, 25.0, 'In Transit', 'Terminal 2 - Area A'),
(3, 3, 3002, 3, 55.0, 'Delivered', 'Arrivals'),
(4, 4, 3003, 2, 33.0, 'Lost', 'Unknown'),
(5, 5, 3004, 1, 28.5, 'Checked In', 'Terminal 1 - Area C'),
(6, 6, 3005, 4, 60.0, 'In Transit', 'Terminal 3 - Area D'),
(7, 7, 3006, 2, 48.5, 'Checked In', 'Terminal 1 - Area E'),
(8, 8, 3007, 1, 23.0, 'Delivered', 'Baggage Claim'),
(9, 9, 3008, 3, 54.0, 'Checked In', 'Terminal 2 - Area F'),
(10, 10, 3009, 1, 27.0, 'In Transit', 'Terminal 1 - Area G'),
(11, 11, 3010, 2, 45.0, 'Lost', 'Unknown'),
(12, 12, 3011, 1, 30.5, 'Delivered', 'Baggage Claim'),
(13, 13, 3012, 2, 43.0, 'In Transit', 'Terminal 1 - Area H'),
(14, 14, 3013, 3, 56.0, 'Checked In', 'Terminal 3 - Area I'),
(15, 15, 3014, 1, 24.5, 'Delivered', 'Arrivals');

SELECT * FROM Luggage;

-- 22. ParkingSlots
INSERT INTO ParkingSlots (AirportID, AvailabilityStatus) VALUES
(1, 'Available'),
(2, 'Occupied'),
(3, 'Available'),
(4, 'Occupied'),
(5, 'Available'),
(6, 'Available'),
(7, 'Occupied'),
(8, 'Available'),
(9, 'Occupied'),
(10, 'Available'),
(11, 'Available'),
(12, 'Occupied'),
(13, 'Available'),
(14, 'Occupied'),
(15, 'Available');

SELECT * FROM ParkingSlots;

-- 23. Parking
INSERT INTO Parking (SlotNumber, PassengerID, CheckInTime, CheckOutTime, ParkingFee) VALUES
(100, 3000, '2024-01-01 09:00:00', '2024-01-01 18:00:00', 20.00),
(101, 3001, '2024-01-02 10:30:00', '2024-01-02 19:00:00', 22.50),
(102, 3002, '2024-01-03 08:45:00', '2024-01-03 16:30:00', 18.75),
(103, 3003, '2024-01-04 09:15:00', '2024-01-04 17:45:00', 21.00),
(104, 3004, '2024-01-05 11:00:00', '2024-01-05 20:30:00', 24.00),
(105, 3005, '2024-01-06 12:30:00', '2024-01-06 21:00:00', 19.50),
(106, 3006, '2024-01-07 13:45:00', '2024-01-07 22:15:00', 23.00),
(107, 3007, '2024-01-08 15:00:00', '2024-01-08 23:30:00', 26.25),
(108, 3008, '2024-01-09 14:15:00', '2024-01-09 21:45:00', 20.75),
(109, 3009, '2024-01-10 08:00:00', '2024-01-10 16:00:00', 18.00),
(110, 3010, '2024-01-11 09:30:00', '2024-01-11 18:30:00', 22.00),
(111, 3011, '2024-01-12 10:00:00', '2024-01-12 17:30:00', 19.25),
(112, 3012, '2024-01-13 11:15:00', '2024-01-13 19:45:00', 23.75),
(113, 3013, '2024-01-14 12:00:00', '2024-01-14 20:30:00', 24.50),
(114, 3014, '2024-01-15 08:45:00', '2024-01-15 15:45:00', 17.50);

SELECT * FROM Parking;

-- 24. FlightEmployeeAssignment
INSERT INTO FlightEmployeeAssignment (FlightID, EmployeeID, AssignmentDate) VALUES
(1, 10000, '2024-01-01'),
(2, 10003, '2024-01-02'),
(3, 10005, '2024-01-03'),
(4, 10009, '2024-01-04'),
(5, 10011, '2024-01-05'),
(6, 10015, '2024-01-06'),
(7, 10017, '2024-01-07'),
(8, 10019, '2024-01-08'),
(9, 10023, '2024-01-09'),
(10, 10025, '2024-01-10');


SELECT * FROM FlightEmployeeAssignment;

-- 25. AirportAirlineOperations
INSERT INTO AirportAirlineOperations (AirportID, AirlineID, ContractStartDate, ContractEndDate, GateCount, TerminalsAssigned) VALUES
(1, 101, '2022-01-01', '2025-01-01', 5, 'Terminal 1'),
(2, 102, '2023-03-01', '2026-03-01', 4, 'Terminal 2'),
(3, 103, '2021-06-15', '2024-06-15', 6, 'Terminal 3'),
(4, 104, '2023-09-01', '2026-09-01', 3, 'Terminal 1, Terminal 2'),
(5, 105, '2022-05-01', '2025-05-01', 4, 'Terminal 2'),
(6, 106, '2023-10-10', '2026-10-10', 2, 'Terminal 3'),
(7, 107, '2024-02-01', '2027-02-01', 5, 'Terminal 1, Terminal 3'),
(8, 108, '2023-08-05', '2026-08-05', 4, 'Terminal 2'),
(9, 109, '2022-11-01', '2025-11-01', 3, 'Terminal 3'),
(10, 110, '2024-04-01', '2027-04-01', 2, 'Terminal 1');

SELECT * FROM AirportAirlineOperations;



-- Will Use in future for SCOPE identity 
-- DECLARE @EmployeeID INT;

-- -- Insert each employee and handle AirplaneStaff records

-- INSERT INTO Employee (FirstName, LastName, Salary, Employee_Type) 
-- VALUES ('Alice', 'Williams', 75000, 'AirplaneStaff');
-- SET @EmployeeID = SCOPE_IDENTITY();
-- -- Insert into AirplaneStaff if Employee_Type is 'AirplaneStaff'
-- IF (SELECT Employee_Type FROM Employee WHERE EmployeeID = @EmployeeID) = 'AirplaneStaff'
-- BEGIN
--     INSERT INTO AirplaneStaff (EmployeeID, AirlineID, Position, LicenseNumber, YearsOfExperience, FlightHours, MedicalClearance)
--     VALUES (@EmployeeID, 100, 'Pilot', 'PLT001', 10, 1500.5, '2023-01-01');
-- END

-- -- 1. Airport
-- SELECT * FROM Airport;

-- -- 2. Airline
-- SELECT * FROM Airline;

-- -- 3. Passenger
-- SELECT * FROM Passenger;

-- -- 4. Phone
-- SELECT * FROM Phone;

-- -- 5. LoyaltyProgram
-- SELECT * FROM LoyaltyProgram;

-- -- 6. Employee
-- SELECT * FROM Employee;

-- -- 7. AirplaneStaff
-- SELECT * FROM AirplaneStaff;

-- -- 8. Specialization
-- SELECT * FROM Specialization;

-- -- 9. Certification
-- SELECT * FROM Certification;

-- -- 10. SecurityStaff
-- SELECT * FROM SecurityStaff;

-- -- 11. GroundStaff
-- SELECT * FROM GroundStaff;

-- -- 12. GroundSupport
-- SELECT * FROM GroundSupport;

-- -- 13. EquipmentAssignment
-- SELECT * FROM EquipmentAssignment;

-- -- 14. RunwayManagement
-- SELECT * FROM RunwayManagement;

-- -- 15. Aircraft
-- SELECT * FROM Aircraft;

-- -- 16. Maintenance
-- SELECT * FROM Maintenance;

-- -- 17. Gate
-- SELECT * FROM Gate;

-- -- 18. Flight
-- SELECT * FROM Flight;

-- -- 19. FlightBooking
-- SELECT * FROM FlightBooking;

-- -- 20. BoardingPass
-- SELECT * FROM BoardingPass;

-- -- 21. Luggage
-- SELECT * FROM Luggage;

-- -- 22. ParkingSlots
-- SELECT * FROM ParkingSlots;

-- -- 23. Parking
-- SELECT * FROM Parking;

-- -- 24. FlightEmployeeAssignment
-- SELECT * FROM FlightEmployeeAssignment;

-- -- 25. AirportAirlineOperations
-- SELECT * FROM AirportAirlineOperations;
