-- -- Switch to the master database to ensure no active connection in the target database
-- USE master;
-- GO

-- -- Set the target database to SINGLE_USER mode and rollback any active transactions
-- ALTER DATABASE AirportManagementSystem
-- SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- GO
-- -- Dropping the AMS database if it exists
-- DROP DATABASE IF EXISTS AirportManagementSystem;
-- GO

-- -- Creating the AMS database
-- CREATE DATABASE AirportManagementSystem;
-- GO

-- USE AirportManagementSystem;
-- GO

-- Switch to the master database to ensure no active connections in the target database
USE master;
GO

-- Check if the target database exists, drop it if it does
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'AirportManagementSystem')
BEGIN
    PRINT 'Dropping existing AirportManagementSystem database...';

    -- Set the database to SINGLE_USER mode to terminate active connections
    ALTER DATABASE AirportManagementSystem
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    
    -- Drop the existing database
    DROP DATABASE AirportManagementSystem;
    PRINT 'Database AirportManagementSystem dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Database AirportManagementSystem does not exist, proceeding to create a new database.';
END
GO

-- Create the new AirportManagementSystem database
CREATE DATABASE AirportManagementSystem;
PRINT 'Database AirportManagementSystem created successfully.';
GO

-- Switch to the newly created database
USE AirportManagementSystem;
GO


-- Dropping the AirportManagementSystem Database and All Related Tables
-- The tables are dropped in reverse order of dependencies to ensure referential integrity.

-- Step 1: Dropping Tables with Highest Dependencies First

-- Drop associative and dependent tables with complex foreign key relationships
DROP TABLE IF EXISTS AirportAirlineOperations;  -- Dependent on Airport and Airline
DROP TABLE IF EXISTS FlightEmployeeAssignment;   -- Dependent on Flight and AirplaneStaff
DROP TABLE IF EXISTS Parking;                    -- Dependent on ParkingSlots and Passenger
DROP TABLE IF EXISTS ParkingSlots; 
DROP TABLE IF EXISTS Luggage;                    -- Dependent on Airport, FlightBooking, and Passenger
DROP TABLE IF EXISTS BoardingPass;               -- Dependent on Passenger and FlightBooking
DROP TABLE IF EXISTS FlightBooking;              -- Dependent on Flight and Passenger

-- Step 2: Dropping Core Functional Tables with Foreign Key Dependencies

-- Drop tables associated with core functionalities that have multiple references
DROP TABLE IF EXISTS Flight;                     -- Dependent on Airport, Airline, RunwayManagement, Gate, and Aircraft
DROP TABLE IF EXISTS Gate;                       -- Dependent on Airport
DROP TABLE IF EXISTS Maintenance;                -- Dependent on Aircraft and GroundSupport
DROP TABLE IF EXISTS Aircraft;                   -- Dependent on Airline and RunwayManagement
DROP TABLE IF EXISTS RunwayManagement;           -- Dependent on Airport
DROP TABLE IF EXISTS EquipmentAssignment;        -- Dependent on GroundStaff
DROP TABLE IF EXISTS GroundSupport;              -- Independent core functional table for ground support equipment

-- Step 3: Dropping Employee Subtypes and Related Tables

-- Drop tables specific to employee subtypes and their details
DROP TABLE IF EXISTS GroundStaff;                -- Dependent on Airport and Employee
DROP TABLE IF EXISTS SecurityStaff;              -- Dependent on Airport and Employee
DROP TABLE IF EXISTS Certification;              -- Dependent on AirplaneStaff
DROP TABLE IF EXISTS Specialization;             -- Dependent on AirplaneStaff
DROP TABLE IF EXISTS AirplaneStaff;              -- Dependent on Employee and Airline

-- Step 4: Dropping Supporting Tables for Primary Entities

-- Drop core entity tables and primary data holders
DROP TABLE IF EXISTS Employee;                   -- Independent primary table for employees
DROP TABLE IF EXISTS LoyaltyProgram;             -- Dependent on Passenger
DROP TABLE IF EXISTS Phone;                      -- Dependent on Passenger
DROP TABLE IF EXISTS Passenger;                  -- Independent primary table for passengers
DROP TABLE IF EXISTS Airline;                    -- Independent primary table for airlines
DROP TABLE IF EXISTS Airport;                    -- Independent primary table for airports


------ Creating the Tables for AMS  ----------
-- 1. Airport Table
CREATE TABLE Airport (
    AirportID INT PRIMARY KEY IDENTITY(1,1),  -- Unique identifier for each airport
    AirportName VARCHAR(100) NOT NULL,  -- Name of the airport
    [Type] VARCHAR(50) CONSTRAINT CHK_Airport_Type CHECK ([Type] IN ('International', 'Domestic')),  -- Type of airport (International or Domestic)
    City VARCHAR(100) NOT NULL,  -- City where the airport is located
    Area VARCHAR(100),  -- Area within the city
    Country VARCHAR(100) NOT NULL  -- Country of the airport
);

-- 2. Airline Table
CREATE TABLE Airline (
    AirlineID INT PRIMARY KEY IDENTITY(100,1),  -- Unique identifier for each airline
    AirlineName VARCHAR(100) NOT NULL,  -- Name of the airline
    Country VARCHAR(50) NOT NULL  -- Country where the airline is based
);

-- 3. Passenger Table
CREATE TABLE Passenger (
    PassengerID INT PRIMARY KEY IDENTITY(3000,1),  -- Unique identifier for each passenger
    FirstName VARCHAR(50) NOT NULL,  -- Passenger's first name
    LastName VARCHAR(50) NOT NULL,  -- Passenger's last name
    Age INT CONSTRAINT CHK_Passenger_Age CHECK (Age >= 0 AND Age <= 120),  -- Age with a check constraint to ensure it is a valid age
    Nationality VARCHAR(50) NOT NULL,  -- Nationality of the passenger
    CheckInStatus BIT DEFAULT 0,  -- Check-in status, defaulting to not checked in
    CustomerFeedback TEXT  -- Optional feedback from the passenger
);

-- 4. Phone Table
CREATE TABLE Phone (
    PhoneSNo INT PRIMARY KEY IDENTITY(1,1),  -- Unique identifier for each phone entry
    PassengerID INT NOT NULL,  -- Reference to the associated passenger
    PhoneType VARCHAR(10) CONSTRAINT CHK_PhoneType CHECK (PhoneType IN ('Home', 'Work', 'Mobile')),  -- Type of phone
    PhoneNumber VARCHAR(15) NOT NULL,  -- The phone number itself
    CONSTRAINT CHK_PhoneNumberLength CHECK (  -- Check constraint for phone number length based on type
        (PhoneType = 'Home' AND LEN(PhoneNumber) BETWEEN 8 AND 15) OR
        (PhoneType = 'Work' AND LEN(PhoneNumber) BETWEEN 10 AND 13) OR
        (PhoneType = 'Mobile' AND LEN(PhoneNumber) BETWEEN 10 AND 13)
    ),
    CONSTRAINT FK_Phone_PassengerID FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID) ON DELETE CASCADE  -- Foreign key relationship
);

-- 5. LoyaltyProgram Table
CREATE TABLE LoyaltyProgram (
    LoyaltyID INT PRIMARY KEY IDENTITY(111,1),  -- Unique identifier for loyalty program entries
    PassengerID INT NOT NULL,  -- Reference to the associated passenger
    LoyaltyPoints INT DEFAULT 0 CHECK (LoyaltyPoints >= 0),  -- Points accumulated in the loyalty program
    LoyaltyStatus VARCHAR(20) CONSTRAINT CHK_LoyaltyStatus CHECK (LoyaltyStatus IN ('Silver', 'Gold', 'Platinum')),  -- Status of loyalty membership
    EnrollmentDate DATETIME DEFAULT GETDATE(),  -- Date of enrollment, defaulting to current date
    CONSTRAINT FK_LoyaltyProgram_PassengerID FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID) ON DELETE CASCADE  -- Foreign key relationship
);

-- 6. Employee Table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY IDENTITY(10000,1),  -- Unique identifier for each employee
    FirstName VARCHAR(50) NOT NULL,  -- Employee's first name
    LastName VARCHAR(50) NOT NULL,  -- Employee's last name
    Salary DECIMAL(10, 2) NOT NULL,  -- Employee's salary
    Employee_Type VARCHAR(50) NOT NULL CONSTRAINT CHK_Employee_Type CHECK (Employee_Type IN ('AirplaneStaff', 'SecurityStaff', 'GroundStaff'))  -- Type of employee
);

-- 7. AirplaneStaff Table
CREATE TABLE AirplaneStaff (
    EmployeeID INT PRIMARY KEY,  -- Use EmployeeID as primary key to maintain one-to-one relationship with Employee
    AirlineID INT NOT NULL,  -- Reference to the associated airline
    Position VARCHAR(50) NOT NULL CONSTRAINT CHK_AirplaneStaff_Position CHECK (Position IN ('Pilot', 'Co-Pilot', 'Flight Attendant', 'Cabin Crew', 'Ground Crew')),  -- Position of the airplane staff
    LicenseNumber VARCHAR(50) NOT NULL,  -- Staff's license number
    YearsOfExperience INT CONSTRAINT CHK_AirplaneStaff_Experience CHECK (YearsOfExperience >= 0),  -- Years of experience
    FlightHours DECIMAL(10, 2) CONSTRAINT CHK_AirplaneStaff_FlightHours CHECK (FlightHours >= 0),  -- Total flight hours
    MedicalClearance DATE,  -- Medical clearance status

    -- Foreign key relationships
    CONSTRAINT FK_AirplaneStaff_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE,
    CONSTRAINT FK_AirplaneStaff_AirlineID FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID) ON DELETE CASCADE
);


-- 8. Specialization Table
CREATE TABLE Specialization (
    SpecializationID INT PRIMARY KEY IDENTITY(222,1),  -- Unique identifier for each specialization
    EmployeeID INT NOT NULL,  -- Reference to the associated airplane staff (using EmployeeID as foreign key)
    Specialization VARCHAR(50) NOT NULL CONSTRAINT CHK_Specialization CHECK (Specialization IN ('Pilot Training', 'Emergency Procedures', 'Safety Protocols', 'Customer Service', 'Aircraft Systems Operation')),  -- Type of specialization
    CertificationDate DATE DEFAULT GETDATE(),  -- Date of certification
    
    -- Foreign key relationship with AirplaneStaff
    CONSTRAINT FK_Specialization_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES AirplaneStaff(EmployeeID) ON DELETE CASCADE  -- Foreign key relationship
);


-- 9. Certification Table
CREATE TABLE Certification (
    CertificationID INT PRIMARY KEY IDENTITY(333,1),  -- Unique identifier for each certification
    EmployeeID INT NOT NULL,  -- Reference to the associated airplane staff (using EmployeeID as foreign key)
    CertificationLevel VARCHAR(50) NOT NULL CHECK (CertificationLevel IN ('Pilot License', 'Safety Training', 'Emergency Procedures')),  -- Level of certification
    IssueDate DATE DEFAULT GETDATE(),  -- Date when the certification was issued
    ExpiryDate DATE,  -- Expiry date of the certification

    -- Table-level CHECK constraint to ensure ExpiryDate is after IssueDate
    CONSTRAINT CHK_Certification_ExpiryDate CHECK (ExpiryDate > IssueDate),

    -- Foreign key relationship with AirplaneStaff
    CONSTRAINT FK_Certification_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES AirplaneStaff(EmployeeID) ON DELETE CASCADE
);



-- 10. SecurityStaff Table
CREATE TABLE SecurityStaff (
    EmployeeID INT PRIMARY KEY,  -- Use EmployeeID as primary key to maintain one-to-one relationship with Employee
    AirportID INT NOT NULL,  -- Reference to the associated airport
    AssignedArea VARCHAR(100) NOT NULL CONSTRAINT CHK_SecurityStaff_AssignedArea CHECK (AssignedArea IN ('Baggage Handling', 'Terminal Security', 'Customs', 'Runway Access')),  -- Area assigned for security
    SecurityClearanceLevel VARCHAR(50) NOT NULL CONSTRAINT CHK_SecurityStaff_ClearanceLevel CHECK (SecurityClearanceLevel IN ('Low', 'Medium', 'High', 'Top Secret')),  -- Level of security clearance
    TrainingCompleted DATE CONSTRAINT CHK_SecurityStaff_TrainingDate CHECK (TrainingCompleted <= GETDATE()),  -- Date when training was completed
    ShiftStart DATETIME NOT NULL,  -- Start time of the shift
    ShiftEnd DATETIME NOT NULL,  -- End time of the shift
    Role VARCHAR(50) NOT NULL,  -- Role of the security staff

    -- Foreign key constraints
    CONSTRAINT FK_SecurityStaff_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE,
    CONSTRAINT FK_SecurityStaff_AirportID FOREIGN KEY (AirportID) REFERENCES Airport(AirportID) ON DELETE NO ACTION,
    
    -- Table-level CHECK constraints
    CONSTRAINT CHK_SecurityStaff_ShiftTiming CHECK (ShiftEnd > ShiftStart),  -- Ensures ShiftEnd is after ShiftStart
    CONSTRAINT CHK_SecurityStaff_WorkHours CHECK (  -- Check for valid work hours
        DATEPART(HOUR, ShiftStart) BETWEEN 0 AND 23 AND
        DATEPART(HOUR, ShiftEnd) BETWEEN 0 AND 23
    )
);


-- 11. GroundStaff Table
CREATE TABLE GroundStaff (
    EmployeeID INT PRIMARY KEY,  -- Use EmployeeID as primary key to maintain one-to-one relationship with Employee
    AirportID INT NOT NULL,  -- Reference to the associated airport
    AssignedTasks VARCHAR(50) NOT NULL CONSTRAINT CHK_GroundStaff_AssignedTasks CHECK (AssignedTasks IN ('Equipment Operation', 'Maintenance Support', 'Loading/Unloading', 'Fueling Assistance')),  -- Tasks assigned to ground staff
    ShiftGroup CHAR(1) NOT NULL CONSTRAINT CHK_GroundStaff_ShiftGroup CHECK (ShiftGroup IN ('A', 'B', 'C', 'D', 'M')),  -- Group of shift timing
    -- Foreign key relationships
    CONSTRAINT FK_GroundStaff_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE,
    CONSTRAINT FK_GroundStaff_AirportID FOREIGN KEY (AirportID) REFERENCES Airport(AirportID) ON DELETE CASCADE
);


-- 12. GroundSupport Table
CREATE TABLE GroundSupport (
    EquipmentID INT PRIMARY KEY IDENTITY(440,1),  -- Unique identifier for ground support equipment
    EquipmentType VARCHAR(50) NOT NULL,  -- Type of equipment
    GSM_Status VARCHAR(20) NOT NULL CHECK (GSM_Status IN ('Operational', 'Out of Service')),  -- Status of the equipment
    UsageDuration TIME NOT NULL,  -- Duration of equipment usage
    MaintenanceFrequency VARCHAR(20) NOT NULL CONSTRAINT GS_MF_CHK CHECK (MaintenanceFrequency IN ('Monthly', 'Yearly'))  -- Frequency of maintenance
);

-- 13. EquipmentAssignment Table
CREATE TABLE EquipmentAssignment (
    EquipmentID INT NOT NULL,  -- Reference to the associated equipment
    EmployeeID INT NOT NULL,  -- Reference to the associated ground staff (using EmployeeID as foreign key)
    Assign_Date DATETIME NOT NULL DEFAULT GETDATE(),  -- Date of assignment

    -- Composite primary key on EquipmentID and EmployeeID
    CONSTRAINT PK_EquipmentID_EmployeeID PRIMARY KEY (EquipmentID, EmployeeID),  
    
    -- Foreign key constraints
    CONSTRAINT FK_EquipmentAssignment_EquipmentID FOREIGN KEY (EquipmentID) REFERENCES GroundSupport(EquipmentID) ON DELETE CASCADE,
    CONSTRAINT FK_EquipmentAssignment_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES GroundStaff(EmployeeID) ON DELETE CASCADE
);



-- 14. RunwayManagement Table
CREATE TABLE RunwayManagement (
    RunwayID INT PRIMARY KEY IDENTITY(1,1),  -- Unique identifier for each runway
    AirportID INT NOT NULL,  -- Reference to the associated airport
    RunwayNumber VARCHAR(10) NOT NULL,  -- Number identifier for runway
    OccupiedStatus VARCHAR(20) NOT NULL CONSTRAINT CHK_RW_OS CHECK (OccupiedStatus IN ('Occupied', 'Available', 'Not in Use')),  -- Occupancy status of the runway
    CONSTRAINT FK_RunwayManagement_AirportID FOREIGN KEY (AirportID) REFERENCES Airport(AirportID) ON DELETE CASCADE  -- Foreign key relationship
);

-- 15. Aircraft Table
CREATE TABLE Aircraft (
    AircraftID INT PRIMARY KEY IDENTITY(1,1),  -- Unique identifier for each aircraft
    AirlineID INT NOT NULL,  -- Reference to the associated airline
    RunwayID INT NOT NULL,  -- Reference to the associated runway
    AircraftType VARCHAR(50) NOT NULL,  -- Type of aircraft
    Capacity INT NOT NULL CONSTRAINT CHK_Capacity CHECK (Capacity > 0),  -- Capacity of the aircraft
    FuelConsumption DECIMAL(10, 2) CONSTRAINT CHK_FC CHECK (FuelConsumption >= 0),  -- Fuel consumption
    AircraftAge INT CONSTRAINT CHK_AA CHECK (AircraftAge >= 0),  -- Age of the aircraft
    CONSTRAINT FK_Aircraft_AirlineID FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID) ON DELETE CASCADE,  -- Foreign key relationship
    CONSTRAINT FK_Aircraft_RunwayID FOREIGN KEY (RunwayID) REFERENCES RunwayManagement(RunwayID) ON DELETE CASCADE  -- Foreign key relationship
);

-- 16. Maintenance Table
CREATE TABLE Maintenance (
    MaintenanceID INT PRIMARY KEY IDENTITY(1230000,1),  -- Unique identifier for each maintenance record
    AircraftID INT NOT NULL,  -- Reference to the associated aircraft
    EquipmentID INT NOT NULL,  -- Reference to the associated equipment
    MaintenanceDate DATETIME DEFAULT GETDATE(),  -- Date of maintenance
    MaintenanceType VARCHAR(50) NOT NULL,  -- Type of maintenance
    MaintenanceDuration TIME NOT NULL,  -- Duration of maintenance
    NextScheduledMaintenance DATETIME,  -- Next scheduled maintenance date
    MaintenanceStatus VARCHAR(20) CONSTRAINT CHK_MS CHECK (MaintenanceStatus IN ('Pending', 'In Progress', 'Completed')),  -- Status of maintenance
    CONSTRAINT FK_Maintenance_AircraftID FOREIGN KEY (AircraftID) REFERENCES Aircraft(AircraftID) ON DELETE CASCADE,  -- Foreign key relationship
    CONSTRAINT FK_Maintenance_EquipmentID FOREIGN KEY (EquipmentID) REFERENCES GroundSupport(EquipmentID) ON DELETE CASCADE  -- Foreign key relationship
);

-- 17. Gate
CREATE TABLE Gate (
    GateID INT PRIMARY KEY IDENTITY(1,1),  -- Unique identifier for each gate
    AirportID INT NOT NULL,  -- Reference to the associated airport
    GateNumber VARCHAR(10) NOT NULL CHECK (GateNumber LIKE '[A-Z][0-9]%'),  -- Gate number with format check
    Terminal VARCHAR(50) NOT NULL CHECK (Terminal IN ('Terminal 1', 'Terminal 2', 'Terminal 3')),  -- Terminal validation
    GateStatus VARCHAR(20) NOT NULL CHECK (GateStatus IN ('Occupied', 'Available')),  -- Status of the gate
    CONSTRAINT FK_Gate_AirportID FOREIGN KEY (AirportID) REFERENCES Airport(AirportID) ON DELETE CASCADE,  -- Foreign key relationship
    CONSTRAINT UQ_GateNumber_Terminal UNIQUE (GateNumber, Terminal)  -- Ensures unique gate number per terminal
);

-- 18. Flight
CREATE TABLE Flight (
    FlightID INT PRIMARY KEY IDENTITY(1,1),  -- Unique identifier for each flight
    SourceAirportID INT NOT NULL,  -- Reference to the source airport
    DestinationAirportID INT NOT NULL,  -- Reference to the destination airport
    AirlineID INT NOT NULL,  -- Reference to the associated airline
    RunwayID INT NOT NULL,  -- Reference to the assigned runway
    AircraftID INT NOT NULL,  -- Reference to the aircraft for this flight
    GateID INT NOT NULL,  -- Reference to the assigned gate
    FlightNumber VARCHAR(20) NOT NULL UNIQUE,  -- Unique flight number
    FlightName VARCHAR(50),  -- Name of the flight
    Capacity INT NOT NULL,  -- Capacity of the flight
    DepartureTime DATETIME NOT NULL,  -- Scheduled departure time
    ArrivalTime DATETIME NOT NULL,  -- Scheduled arrival time
    FlightPrice DECIMAL(10, 2),  -- Price for the flight
    FlightStatus VARCHAR(20),  -- Status of the flight
    ActualArrivalTime DATETIME,  -- Actual arrival time
    ActualDepartureTime DATETIME,  -- Actual departure time
    DelayReason VARCHAR(100),  -- Reason for delay, if any
    DelayDuration AS DATEDIFF(MINUTE, ArrivalTime, ActualArrivalTime),  -- Calculated delay duration if there’s a delay

    -- Foreign key constraints
    CONSTRAINT FK_Flight_SourceAirportID FOREIGN KEY (SourceAirportID) REFERENCES Airport(AirportID) ON DELETE CASCADE,
    CONSTRAINT FK_Flight_DestinationAirportID FOREIGN KEY (DestinationAirportID) REFERENCES Airport(AirportID) ON DELETE NO ACTION,
    CONSTRAINT FK_Flight_AirlineID FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID) ON DELETE CASCADE,
    CONSTRAINT FK_Flight_RunwayID FOREIGN KEY (RunwayID) REFERENCES RunwayManagement(RunwayID) ON DELETE NO ACTION,
    CONSTRAINT FK_Flight_AircraftID FOREIGN KEY (AircraftID) REFERENCES Aircraft(AircraftID) ON DELETE NO ACTION,
    CONSTRAINT FK_Flight_GateID FOREIGN KEY (GateID) REFERENCES Gate(GateID) ON DELETE NO ACTION,

    -- Table-level CHECK constraints
    CONSTRAINT CHK_Flight_Capacity CHECK (Capacity > 0),
    CONSTRAINT CHK_Flight_Price CHECK (FlightPrice >= 0),
    CONSTRAINT CHK_Flight_Status CHECK (FlightStatus IN ('Scheduled', 'Delayed', 'Cancelled', 'Completed')),
    CONSTRAINT CHK_Flight_DifferentAirports CHECK (SourceAirportID <> DestinationAirportID),
    CONSTRAINT CHK_Flight_DepartureBeforeArrival CHECK (ArrivalTime > DepartureTime),
    CONSTRAINT CHK_Flight_ActualArrival CHECK (ActualArrivalTime IS NULL OR ActualArrivalTime >= ArrivalTime),
    CONSTRAINT CHK_Flight_ActualDeparture CHECK (ActualDepartureTime IS NULL OR ActualDepartureTime >= DepartureTime),
    CONSTRAINT CHK_Flight_StatusCompletedTimes CHECK (
        (FlightStatus <> 'Completed') OR 
        (ActualDepartureTime IS NOT NULL AND ActualArrivalTime IS NOT NULL)
    )
);

-- 19. FlightBooking
CREATE TABLE FlightBooking (
    TicketID INT PRIMARY KEY IDENTITY(1,1),  -- Unique identifier for each ticket
    FlightID INT NOT NULL,  -- Reference to the associated flight
    PassengerID INT NOT NULL,  -- Reference to the associated passenger
    TicketNumber AS ('TNO-' + RIGHT('00000' + CAST(TicketID AS VARCHAR), 5)) PERSISTED UNIQUE,  -- Computed ticket number in format TICK-00001, TICK-00002, etc.
    PurchaseDate DATETIME DEFAULT GETDATE(),  -- Date of purchase, defaults to current date
    FareClass VARCHAR(20) NOT NULL CHECK (FareClass IN ('Economy', 'Business', 'First')),  -- Fare class for the booking
    BookingStatus VARCHAR(20) NOT NULL CHECK (BookingStatus IN ('Confirmed', 'Cancelled', 'Pending')),  -- Status of the booking
    TicketPrice DECIMAL(10, 2) NOT NULL CHECK (TicketPrice >= 0),  -- Price of the ticket, non-negative
    CONSTRAINT FK_FlightBooking_FlightID FOREIGN KEY (FlightID) REFERENCES Flight(FlightID) ON DELETE CASCADE,  -- Foreign key relationship
    CONSTRAINT FK_FlightBooking_PassengerID FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID) ON DELETE CASCADE  -- Foreign key relationship
);

-- 20. BoardingPass(A: First or Business Class , B: Loyalty Program Members, C: Families or Assistance Boarding, D: Economy Class (Rear seats), E: Economy Class (Front seats))
CREATE TABLE BoardingPass (
    BoardingPassID INT PRIMARY KEY IDENTITY(1,1),  -- Unique identifier for each boarding pass
    PassengerID INT NOT NULL,  -- Reference to the associated passenger
    TicketID INT NOT NULL,  -- Reference to the associated ticket
    SeatNumber VARCHAR(10) NOT NULL,  -- Assigned seat number
    BoardingGroup CHAR(1) CHECK (BoardingGroup IN ('A', 'B', 'C', 'D')),  -- Boarding group with specific allowed values
    IssueTime DATETIME DEFAULT GETDATE(),  -- Time when the boarding pass was issued
    CONSTRAINT FK_BoardingPass_PassengerID FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID) ON DELETE CASCADE,  -- Foreign key relationship
    CONSTRAINT FK_BoardingPass_TicketID FOREIGN KEY (TicketID) REFERENCES FlightBooking(TicketID) ON DELETE NO ACTION  -- Foreign key relationship
);

-- 21. Luggage
CREATE TABLE Luggage (
    LuggageID INT PRIMARY KEY IDENTITY(1,1),  -- Unique identifier for each luggage entry
    AirportID INT NOT NULL,  -- Reference to the associated airport
    TicketID INT NOT NULL,  -- Reference to the associated ticket
    PassengerID INT NOT NULL,  -- Reference to the associated passenger
    NumberOfBags INT NOT NULL CHECK (NumberOfBags > 0),  -- Number of bags, must be positive
    [Weight] DECIMAL(10, 2) CHECK ([Weight] >= 0),  -- Total weight of the luggage, non-negative
    [Status] VARCHAR(20) CHECK ([Status] IN ('Checked In', 'In Transit', 'Delivered', 'Lost')),  -- Status of the luggage
    BaggageLocation VARCHAR(50),  -- Current location or terminal for the luggage
    CONSTRAINT FK_Luggage_AirportID FOREIGN KEY (AirportID) REFERENCES Airport(AirportID) ON DELETE NO ACTION,  -- Foreign key relationship
    CONSTRAINT FK_Luggage_TicketID FOREIGN KEY (TicketID) REFERENCES FlightBooking(TicketID) ON DELETE NO ACTION,  -- Foreign key relationship
    CONSTRAINT FK_Luggage_PassengerID FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID) ON DELETE CASCADE  -- Foreign key relationship
);

-- 22. ParkingSlots
CREATE TABLE ParkingSlots (
    SlotNumber INT PRIMARY KEY IDENTITY(100,1),  -- Unique identifier for each parking slot
    AirportID INT NOT NULL,  -- Reference to the associated airport
    AvailabilityStatus VARCHAR(20) NOT NULL CONSTRAINT CHK_PS_AS CHECK (AvailabilityStatus IN ('Available', 'Occupied')),  -- Availability status of the slot
    CONSTRAINT FK_ParkingSlots_AirportID FOREIGN KEY (AirportID) REFERENCES Airport(AirportID) ON DELETE CASCADE  -- Foreign key relationship
);

-- 23. Parking
CREATE TABLE Parking (
    ParkingID INT PRIMARY KEY IDENTITY(1001,1),  -- Unique identifier for each parking entry
    SlotNumber INT NOT NULL,  -- Reference to the associated parking slot
    PassengerID INT NOT NULL,  -- Reference to the associated passenger
    CheckInTime DATETIME NOT NULL,  -- Check-in time for parking
    CheckOutTime DATETIME,  -- Check-out time for parking
    ParkingFee DECIMAL(10, 2) CHECK (ParkingFee >= 0),  -- Fee for the parking duration

    -- Foreign key constraints
    CONSTRAINT FK_Parking_SlotNumber FOREIGN KEY (SlotNumber) REFERENCES ParkingSlots(SlotNumber) ON DELETE CASCADE,
    CONSTRAINT FK_Parking_PassengerID FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID) ON DELETE CASCADE,

    -- Table-level CHECK constraint for CheckOutTime being after CheckInTime
    CONSTRAINT CHK_Parking_CheckOutAfterCheckIn CHECK (
        CheckOutTime IS NULL OR CheckOutTime > CheckInTime
    )
);


-- 24. FlightEmployeeAssignment
CREATE TABLE FlightEmployeeAssignment (
    FlightID INT NOT NULL,  -- Reference to the associated flight
    EmployeeID INT NOT NULL,  -- Reference to the associated airplane staff (using EmployeeID as foreign key)
    AssignmentDate DATE NOT NULL,  -- Date of the assignment

    -- Composite primary key on FlightID and EmployeeID
    CONSTRAINT PK_FlightEmployeeAssignment PRIMARY KEY (FlightID, EmployeeID),  
    
    -- Foreign key constraints
    CONSTRAINT FK_FlightEmployeeAssignment_FlightID FOREIGN KEY (FlightID) REFERENCES Flight(FlightID) ON DELETE CASCADE,
    CONSTRAINT FK_FlightEmployeeAssignment_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES AirplaneStaff(EmployeeID) ON DELETE NO ACTION
);


-- 25. AirportAirlineOperations
CREATE TABLE AirportAirlineOperations (
    AirportID INT NOT NULL,  -- Reference to the associated airport
    AirlineID INT NOT NULL,  -- Reference to the associated airline
    ContractStartDate DATE NOT NULL,  -- Start date of the contract between airport and airline
    ContractEndDate DATE NOT NULL,  -- End date of the contract, must be after start date
    GateCount INT NOT NULL CHECK (GateCount >= 0),  -- Number of gates assigned to the airline, must be non-negative
    TerminalsAssigned VARCHAR(100) NOT NULL,  -- List or details of terminals assigned to the airline

    -- Primary key and foreign key constraints
    CONSTRAINT PK_AirportAirlineOperations PRIMARY KEY (AirportID, AirlineID),
    CONSTRAINT FK_AirportAirlineOperations_AirportID FOREIGN KEY (AirportID) REFERENCES Airport(AirportID) ON DELETE NO ACTION,
    CONSTRAINT FK_AirportAirlineOperations_AirlineID FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID) ON DELETE CASCADE,

    -- Table-level CHECK constraint to ensure ContractEndDate is after ContractStartDate
    CONSTRAINT CHK_AirportAirlineOperations_ContractDate CHECK (ContractEndDate > ContractStartDate)
);


