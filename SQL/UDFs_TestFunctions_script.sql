SELECT dbo.fn_GetFlightDuration('2024-11-10 10:00:00', '2024-11-10 12:30:00') AS FlightDuration; 
-- Expected Result: 150 (minutes)

SELECT dbo.fn_CalculateLoyaltyPoints(500.00, 'Economy') AS LoyaltyPoints; 
-- Expected Result: 25

SELECT dbo.fn_CheckParkingAvailability(101) AS AvailabilityStatus; 
-- Expected Result: 'Available' or 'Occupied'

SELECT dbo.fn_GetEmployeeFullName('John', 'Doe') AS FullName; 
-- Expected Result: 'John Doe'

SELECT dbo.fn_GetNextMaintenanceDate(1) AS NextMaintenanceDate; 
-- Expected Result: A valid DATETIME value or NULL if no record exists

SELECT dbo.fn_GetPassengerFeedbackScore('The service was good and friendly.') AS FeedbackScore; 
-- Expected Result: 'Positive'

SELECT dbo.fn_GetTotalBaggageWeight(1) AS TotalWeight; 
-- Expected Result: Total weight of luggage for FlightID 1

SELECT dbo.fn_GetGateUtilizationRate(1) AS UtilizationRate; 
-- Expected Result: Utilization percentage (e.g., 6.67)

SELECT dbo.fn_CalculateFlightRevenue(1000.00, 'Business') AS Revenue; 
-- Expected Result: 1500.00

SELECT dbo.fn_GetPassengerLoyaltyStatus(600) AS LoyaltyStatus; 
-- Expected Result: 'Gold'

SELECT dbo.fn_GetAverageFlightDelay('Weather') AS AverageDelay; 
-- Expected Result: Average delay in minutes for flights delayed due to 'Weather'

SELECT dbo.fn_CalculateEmployeeShiftHours('2024-11-12 09:00:00', '2024-11-12 17:00:00') AS ShiftHours; 
-- Expected Result: 8

SELECT dbo.fn_GetAircraftCapacityUtilization(1) AS CapacityUtilization; 
-- Expected Result: Utilization percentage (e.g., 85.00)

SELECT dbo.fn_GetRunwayAvailabilityStatus(1) AS RunwayStatus; 
-- Expected Result: 'Occupied', 'Available', or 'Not in Use'

SELECT * FROM dbo.fn_GetTopFrequentFlyers(); 
-- Expected Result: Top 10 passengers sorted by LoyaltyPoints
