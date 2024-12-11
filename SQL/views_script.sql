-- Provides real-time, consolidated flight information.
-- Drop existing view if it exists
IF OBJECT_ID('dbo.vw_FlightStatusBoard', 'V') IS NOT NULL
    DROP VIEW dbo.vw_FlightStatusBoard;
GO

-- -- Create the view
-- CREATE VIEW dbo.vw_FlightStatusBoard
-- WITH SCHEMABINDING
-- AS
-- SELECT 
--     -- f.FlightID,
--     f.FlightNumber,
--     f.DepartureTime,
--     f.ArrivalTime,
--     g.GateNumber,
--     g.Terminal,
--     f.FlightStatus
-- FROM 
--     dbo.Flight f
-- JOIN 
--     dbo.Gate g ON f.GateID = g.GateID;
-- GO

-- Create or alter the view
CREATE VIEW dbo.vw_FlightStatusBoard
WITH SCHEMABINDING
AS
SELECT 
    f.FlightNumber,
    sa.AirportName AS SourceAirport,
    sa.City AS SourceCity,
    da.AirportName AS DestinationAirport,
    da.City AS DestinationCity,
    f.DepartureTime,
    f.ArrivalTime,
    g.GateNumber,
    g.Terminal,
    f.FlightStatus
FROM 
    dbo.Flight f
JOIN 
    dbo.Gate g ON f.GateID = g.GateID
JOIN 
    dbo.Airport sa ON f.SourceAirportID = sa.AirportID
JOIN 
    dbo.Airport da ON f.DestinationAirportID = da.AirportID;
GO


SELECT * FROM dbo.vw_FlightStatusBoard
WHERE FlightStatus = 'Scheduled';

-- Summarizes revenue generated from ticket sales, parking fees, and loyalty program usage. Useful for financial analysis and decision-making for administrators.
-- Drop existing view if it exists
IF OBJECT_ID('dbo.vw_RevenueSummary', 'V') IS NOT NULL
    DROP VIEW dbo.vw_RevenueSummary;
GO

-- Create the indexed view with non-nullable aggregate expressions
CREATE VIEW dbo.vw_RevenueSummary
WITH SCHEMABINDING
AS
SELECT 
    fb.FlightID,
    SUM(ISNULL(fb.TicketPrice, 0)) AS TotalTicketRevenue,
    SUM(ISNULL(p.ParkingFee, 0)) AS TotalParkingRevenue,
    SUM(ISNULL(lp.LoyaltyPoints, 0) * 0.01) AS LoyaltyRedemptionValue,
    COUNT_BIG(*) AS RecordCount
FROM 
    dbo.FlightBooking fb
JOIN 
    dbo.Parking p ON fb.PassengerID = p.PassengerID
JOIN 
    dbo.LoyaltyProgram lp ON fb.PassengerID = lp.PassengerID
GROUP BY 
    fb.FlightID;
GO

-- Create a unique clustered index for the view
CREATE UNIQUE CLUSTERED INDEX idx_vw_RevenueSummary ON dbo.vw_RevenueSummary (FlightID);
GO


-- Lists corresponding employee assignments, including roles and current assigned flights.
-- Drop existing view if it exists
IF OBJECT_ID('dbo.vw_AirplaneStaffAssignmentSummary', 'V') IS NOT NULL
    DROP VIEW dbo.vw_AirplaneStaffAssignmentSummary;
GO

-- Create the AirplaneStaff Assignment Summary View
CREATE VIEW dbo.vw_AirplaneStaffAssignmentSummary
AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Employee_Type,
    asa.Position,
    asa.FlightHours,
    fea.FlightID,
    f.FlightNumber,
    f.DepartureTime,
    f.ArrivalTime,
    g.GateNumber,
    g.Terminal
FROM 
    dbo.Employee e
JOIN 
    dbo.AirplaneStaff asa ON e.EmployeeID = asa.EmployeeID
LEFT JOIN 
    dbo.FlightEmployeeAssignment fea ON e.EmployeeID = fea.EmployeeID
LEFT JOIN 
    dbo.Flight f ON fea.FlightID = f.FlightID
LEFT JOIN 
    dbo.Gate g ON f.GateID = g.GateID
WHERE 
    e.Employee_Type = 'AirplaneStaff';
GO

-- Drop existing view if it exists
IF OBJECT_ID('dbo.vw_SecurityStaffAssignmentSummary', 'V') IS NOT NULL
    DROP VIEW dbo.vw_SecurityStaffAssignmentSummary;
GO

-- Create the SecurityStaff Assignment Summary View
CREATE VIEW dbo.vw_SecurityStaffAssignmentSummary
AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Employee_Type,
    s.AssignedArea,
    s.SecurityClearanceLevel,
    s.TrainingCompleted,
    s.ShiftStart,
    s.ShiftEnd,
    s.Role
FROM 
    dbo.Employee e
JOIN 
    dbo.SecurityStaff s ON e.EmployeeID = s.EmployeeID
WHERE 
    e.Employee_Type = 'SecurityStaff';
GO


-- Drop existing view if it exists
IF OBJECT_ID('dbo.vw_GroundStaffAssignmentSummary', 'V') IS NOT NULL
    DROP VIEW dbo.vw_GroundStaffAssignmentSummary;
GO

-- Create the GroundStaff Assignment Summary View
CREATE VIEW dbo.vw_GroundStaffAssignmentSummary
AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Employee_Type,
    gs.AssignedTasks,
    gs.ShiftGroup,
    ea.EquipmentID,
    gs.AirportID,
    g.EquipmentType,
    g.GSM_Status
FROM 
    dbo.Employee e
JOIN 
    dbo.GroundStaff gs ON e.EmployeeID = gs.EmployeeID
LEFT JOIN 
    dbo.EquipmentAssignment ea ON gs.EmployeeID = ea.EmployeeID
LEFT JOIN 
    dbo.GroundSupport g ON ea.EquipmentID = g.EquipmentID
WHERE 
    e.Employee_Type = 'GroundStaff';
GO


-- Displays upcoming maintenance tasks for both aircraft and ground support equipment
-- Drop existing view if it exists
IF OBJECT_ID('dbo.vw_MaintenanceSchedule', 'V') IS NOT NULL
    DROP VIEW dbo.vw_MaintenanceSchedule;
GO

-- Create the view
CREATE VIEW dbo.vw_MaintenanceSchedule
AS
SELECT 
    m.MaintenanceID,
    a.AircraftID,
    a.AircraftType,
    gs.EquipmentType,
    m.MaintenanceDate,
    m.NextScheduledMaintenance,
    m.MaintenanceStatus
FROM 
    dbo.Maintenance m
JOIN 
    dbo.Aircraft a ON m.AircraftID = a.AircraftID
JOIN 
    dbo.GroundSupport gs ON m.EquipmentID = gs.EquipmentID;
GO


-- Drop the view if it already exists
DROP VIEW IF EXISTS vw_PassengerCheckInStatus;
GO

-- Create a view for dynamic check-in status
CREATE VIEW vw_PassengerCheckInStatus AS
SELECT 
    p.PassengerID,
    p.FirstName,
    p.LastName,
    p.Age,
    p.Nationality,
    CASE 
        WHEN EXISTS (SELECT 1 FROM dbo.BoardingPass bp WHERE bp.PassengerID = p.PassengerID)
        THEN 1
        ELSE 0
    END AS CheckInStatus
FROM 
    dbo.Passenger p;
GO

-- Drop the view if it already exists
DROP VIEW IF EXISTS vw_PassengerCheckInStatus;
GO


CREATE VIEW vw_TicketDetails AS
SELECT 
    FB.TicketNumber,
    P.FirstName AS PassengerFirstName,
    P.LastName AS PassengerLastName,
    F.FlightNumber,
    F.SourceAirportID AS FromLocation,
    F.DestinationAirportID AS ToLocation,
    G.GateNumber,
    G.Terminal,
    FB.BookingStatus
FROM FlightBooking FB
JOIN Passenger P ON FB.PassengerID = P.PassengerID
JOIN Flight F ON FB.FlightID = F.FlightID
JOIN Gate G ON F.GateID = G.GateID;

