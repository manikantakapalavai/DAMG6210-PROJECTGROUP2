-- Fetch data from Flight Status Board view
SELECT * FROM dbo.vw_FlightStatusBoard
where FlightStatus = 'Scheduled';


-- Fetch data from Revenue Summary view
SELECT * FROM dbo.vw_RevenueSummary;

-- View AirplaneStaff Assignments
SELECT * FROM dbo.vw_AirplaneStaffAssignmentSummary
WHERE [Position] = 'Pilot';

-- Query SecurityStaff Assignments
SELECT * FROM dbo.vw_SecurityStaffAssignmentSummary;

-- Query GroundStaff Assignments
SELECT * FROM dbo.vw_GroundStaffAssignmentSummary;

-- Fetch data from Maintenance Schedule view
SELECT * FROM dbo.vw_MaintenanceSchedule
WHERE MaintenanceStatus = 'In Progress';

-- Query the view to get the check-in status
SELECT * FROM vw_PassengerCheckInStatus WHERE PassengerID = 3005;
