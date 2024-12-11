-- fn_GetFlightDuration	Calculates the duration of a flight based on DepartureTime and ArrivalTime.
CREATE FUNCTION dbo.fn_GetFlightDuration
(
    @DepartureTime DATETIME,
    @ArrivalTime DATETIME
)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN DATEDIFF(MINUTE, @DepartureTime, @ArrivalTime);
END;
GO

-- fn_CalculateLoyaltyPoints	Determines loyalty points based on TicketPrice and FareClass.
CREATE FUNCTION dbo.fn_CalculateLoyaltyPoints
(
    @TicketPrice DECIMAL(10, 2),
    @FareClass VARCHAR(20)
)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN CASE
        WHEN @FareClass = 'Economy' THEN CAST(@TicketPrice * 0.05 AS INT)
        WHEN @FareClass = 'Business' THEN CAST(@TicketPrice * 0.1 AS INT)
        WHEN @FareClass = 'FirstClass' THEN CAST(@TicketPrice * 0.15 AS INT)
        ELSE 0
    END;
END;
GO

-- fn_CheckParkingAvailability	Checks if a parking slot is available or reserved.
CREATE FUNCTION dbo.fn_CheckParkingAvailability
(
    @ParkingSlotNumber INT
)
RETURNS VARCHAR(20)
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @AvailabilityStatus VARCHAR(20);

    -- Get the availability status directly from the table
    SELECT @AvailabilityStatus = ps.AvailabilityStatus
    FROM dbo.ParkingSlots AS ps
    WHERE ps.SlotNumber = @ParkingSlotNumber;

    -- Return the status or 'Unknown' if the slot does not exist
    RETURN ISNULL(@AvailabilityStatus, 'Unknown');
END;
GO



-- fn_GetEmployeeFullName	Returns the full name of an employee by concatenating FirstName and LastName.
CREATE FUNCTION dbo.fn_GetEmployeeFullName
(
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50)
)
RETURNS VARCHAR(100)
WITH SCHEMABINDING
AS
BEGIN
    RETURN @FirstName + ' ' + @LastName;
END;
GO

-- fn_GetNextMaintenanceDate	Returns the next scheduled maintenance date for an aircraft.
CREATE FUNCTION dbo.fn_GetNextMaintenanceDate
(
    @AircraftID INT
)
RETURNS DATETIME
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @NextDate DATETIME;
    
    -- Use the two-part name for the table
    SELECT @NextDate = m.NextScheduledMaintenance
    FROM dbo.Maintenance AS m
    WHERE m.AircraftID = @AircraftID;

    -- Return the next maintenance date
    RETURN @NextDate;
END;
GO

-- fn_GetPassengerFeedbackScore	Analyzes CustomerFeedback to return a sentiment score (e.g., positive, neutral, negative).
CREATE FUNCTION dbo.fn_GetPassengerFeedbackScore
(
    @Feedback VARCHAR(MAX)
)
RETURNS VARCHAR(20)
WITH SCHEMABINDING
AS
BEGIN
    RETURN CASE
        WHEN @Feedback LIKE '%good%' THEN 'Positive'
        WHEN @Feedback LIKE '%bad%' THEN 'Negative'
        ELSE 'Neutral'
    END;
END;
GO

-- fn_GetTotalBaggageWeight	Calculates the total weight of luggage for a specific flight using FlightID.
CREATE FUNCTION dbo.fn_GetTotalBaggageWeight
(
    @FlightID INT
)
RETURNS DECIMAL(10, 2)
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @TotalWeight DECIMAL(10, 2);

    -- Calculate the total baggage weight for a specific flight
    SELECT @TotalWeight = SUM(L.Weight)
    FROM dbo.Luggage L
    JOIN dbo.FlightBooking FB ON L.TicketID = FB.TicketID
    WHERE FB.FlightID = @FlightID;

    -- Return the total weight, defaulting to 0 if no records found
    RETURN ISNULL(@TotalWeight, 0);
END;
GO


-- fn_GetGateUtilizationRate	Calculates the utilization rate of a gate based on GateID and flight assignments.
CREATE FUNCTION dbo.fn_GetGateUtilizationRate
(
    @GateID INT
)
RETURNS DECIMAL(5, 2)
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @UtilizationRate DECIMAL(5, 2);

    -- Calculate the utilization rate of the specified gate
    SELECT @UtilizationRate = 
        (CAST(COUNT(*) AS DECIMAL(5, 2)) / 
        NULLIF((SELECT COUNT(*) FROM dbo.Flight), 0)) * 100
    FROM dbo.Flight
    WHERE GateID = @GateID;

    -- Return the utilization rate, defaulting to 0 if NULL
    RETURN ISNULL(@UtilizationRate, 0);
END;
GO



-- fn_CalculateFlightRevenue	Computes the total revenue for a flight based on ticket prices and fare classes.
CREATE FUNCTION dbo.fn_CalculateFlightRevenue
(
    @TicketPrice DECIMAL(10, 2),
    @FareClass VARCHAR(20)
)
RETURNS DECIMAL(15, 2)
WITH SCHEMABINDING
AS
BEGIN
    RETURN CASE
        WHEN @FareClass = 'Economy' THEN @TicketPrice * 1
        WHEN @FareClass = 'Business' THEN @TicketPrice * 1.5
        WHEN @FareClass = 'FirstClass' THEN @TicketPrice * 2
        ELSE 0
    END;
END;
GO

-- fn_GetPassengerLoyaltyStatus	Returns the loyalty status (e.g., Silver, Gold, Platinum) of a passenger based on LoyaltyPoints.
CREATE FUNCTION dbo.fn_GetPassengerLoyaltyStatus
(
    @LoyaltyPoints INT
)
RETURNS VARCHAR(20)
WITH SCHEMABINDING
AS
BEGIN
    RETURN CASE
        WHEN @LoyaltyPoints >= 1000 THEN 'Platinum'
        WHEN @LoyaltyPoints >= 500 THEN 'Gold'
        WHEN @LoyaltyPoints >= 100 THEN 'Silver'
        ELSE 'Bronze'
    END;
END;
GO

-- fn_GetAverageFlightDelay	Returns the average delay time (in minutes) for flights based on DelayReason.
CREATE FUNCTION dbo.fn_GetAverageFlightDelay
(
    @DelayReason VARCHAR(100)
)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @AverageDelay INT;
    SELECT @AverageDelay = AVG(DelayDuration)
    FROM dbo.Flight  -- Use two-part naming convention
    WHERE DelayReason = @DelayReason;
    RETURN ISNULL(@AverageDelay, 0);
END;
GO


-- fn_CalculateEmployeeShiftHours	Calculates the total hours worked by an employee based on ShiftStart and ShiftEnd.
CREATE FUNCTION dbo.fn_CalculateEmployeeShiftHours
(
    @ShiftStart DATETIME,
    @ShiftEnd DATETIME
)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
    RETURN DATEDIFF(HOUR, @ShiftStart, @ShiftEnd);
END;
GO

-- fn_GetAircraftCapacityUtilization	Calculates the percentage of seats filled for a flight based on Capacity and bookings.
CREATE FUNCTION dbo.fn_GetAircraftCapacityUtilization
(
    @FlightID INT
)
RETURNS DECIMAL(5, 2)
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @Utilization DECIMAL(5, 2);

    -- Calculate seat utilization based on booked seats using a subquery
    SELECT @Utilization = (CAST((SELECT COUNT(*) FROM dbo.FlightBooking fb WHERE fb.FlightID = @FlightID) AS DECIMAL(5, 2)) / f.Capacity) * 100
    FROM dbo.Flight f
    WHERE f.FlightID = @FlightID;

    -- Return the utilization percentage
    RETURN ISNULL(@Utilization, 0);
END;
GO



-- fn_GetRunwayAvailabilityStatus	Checks if a specific runway is available or occupied based on RunwayID.
CREATE FUNCTION dbo.fn_GetRunwayAvailabilityStatus
(
    @RunwayID INT
)
RETURNS VARCHAR(20)
WITH SCHEMABINDING
AS
BEGIN
    DECLARE @Status VARCHAR(20);

    -- Select the OccupiedStatus directly from RunwayManagement
    SELECT @Status = OccupiedStatus
    FROM dbo.RunwayManagement
    WHERE RunwayID = @RunwayID;

    -- Return the status, defaulting to 'Unknown' if no matching RunwayID is found
    RETURN ISNULL(@Status, 'Unknown');
END;
GO


-- fn_GetTopFrequentFlyers	Returns a list of top frequent flyers based on LoyaltyPoints accumulated.
CREATE FUNCTION dbo.fn_GetTopFrequentFlyers()
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
    SELECT PassengerID, LoyaltyPoints
    FROM dbo.LoyaltyProgram
    ORDER BY LoyaltyPoints DESC
    OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY
);
GO



