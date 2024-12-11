-- Passenger Table Focused stored procedures
-- 1.TicketID generation after booking for the passenger
-- Drop the sequence if it already exists
DROP SEQUENCE IF EXISTS dbo.TicketID_Sequence;
GO

-- Create the sequence for TicketID generation
CREATE SEQUENCE dbo.TicketID_Sequence
    START WITH 201  -- Starting point for TicketID
    INCREMENT BY 1;  -- Increment by 1
GO

DROP PROCEDURE IF EXISTS sp_CreateFlightBooking;
GO

-- CREATE PROCEDURE sp_CreateFlightBooking
--     @FlightID INT, @PassengerID INT, @FareClass VARCHAR(20), @BookingStatus VARCHAR(20), @TicketPrice DECIMAL(10, 2), @message VARCHAR(200) OUTPUT
-- AS
-- BEGIN
--     DECLARE @newTicketID INT;
--     DECLARE @currentDate DATETIME = GETDATE();
--     BEGIN TRY
--         BEGIN TRANSACTION;
--         -- Validate FlightID
--         IF NOT EXISTS (SELECT 1 FROM dbo.Flight WHERE FlightID = @FlightID)
--         BEGIN
--             SET @message = 'Invalid FlightID.';
--             IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
--             RETURN;
--         END
--         -- Validate PassengerID
--         IF NOT EXISTS (SELECT 1 FROM dbo.Passenger WHERE PassengerID = @PassengerID)
--         BEGIN
--             SET @message = 'Invalid PassengerID.';
--             IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
--             RETURN;
--         END
--         -- Generate a new TicketID using the sequence object
--         SELECT @newTicketID = NEXT VALUE FOR dbo.TicketID_Sequence;

--         -- Enable IDENTITY_INSERT for manual TicketID insertion
--         SET IDENTITY_INSERT dbo.FlightBooking ON;

--         -- Insert the booking record (exclude TicketNumber)
--         INSERT INTO dbo.FlightBooking (TicketID, FlightID, PassengerID, FareClass, BookingStatus, TicketPrice, PurchaseDate)
--         VALUES (@newTicketID, @FlightID, @PassengerID, @FareClass, @BookingStatus, @TicketPrice, @currentDate);

--         -- Disable IDENTITY_INSERT
--         SET IDENTITY_INSERT dbo.FlightBooking OFF;

--         -- Set success message with the computed TicketNumber
--         SET @message = 'Flight booking created successfully. TicketNumber: TNO-' + RIGHT('00000' + CAST(@newTicketID AS VARCHAR), 5);

--         COMMIT TRANSACTION;
--     END TRY
--     BEGIN CATCH
--         IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

--         DECLARE @ErrorMessage NVARCHAR(4000);
--         SELECT @ErrorMessage = ERROR_MESSAGE();

--         SET @message = 'An error occurred during flight booking: ' + @ErrorMessage;
--     END CATCH
-- END;
-- GO

-- -- Testing Above Procedure
-- DECLARE @message VARCHAR(200);
-- EXEC sp_CreateFlightBooking
--     @FlightID = 10,
--     @PassengerID = 3008,
--     @FareClass = 'Economy',
--     @BookingStatus = 'Confirmed',
--     @TicketPrice = 830.00,
--     @message = @message OUTPUT;

CREATE PROCEDURE sp_CreateFlightBooking
    @FlightNumber VARCHAR(50), 
    @Email VARCHAR(255), 
    @FareClass VARCHAR(20), 
    @BookingStatus VARCHAR(20), 
    @TicketPrice DECIMAL(10, 2), 
    @PurchaseDate DATETIME = NULL, 
    @message VARCHAR(200) OUTPUT
AS
BEGIN
    DECLARE @newTicketID INT;
    DECLARE @PassengerID INT;
    DECLARE @FlightID INT;

        IF @PurchaseDate IS NULL
        SET @PurchaseDate = GETDATE();

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate FlightNumber and fetch FlightID
        SELECT @FlightID = FlightID 
        FROM dbo.Flight 
        WHERE FlightNumber = @FlightNumber;

        IF @FlightID IS NULL
        BEGIN
            SET @message = 'Invalid FlightNumber. Flight not found.';
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validate Email and fetch PassengerID
        SELECT @PassengerID = PassengerID 
        FROM dbo.Passenger 
        WHERE Email = @Email;

        IF @PassengerID IS NULL
        BEGIN
            SET @message = 'Invalid Email. Passenger not found.';
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Generate a new TicketID using the sequence object
        SELECT @newTicketID = NEXT VALUE FOR dbo.TicketID_Sequence;

        -- Enable IDENTITY_INSERT for manual TicketID insertion
        SET IDENTITY_INSERT dbo.FlightBooking ON;

        -- Insert the booking record (exclude TicketNumber)
        INSERT INTO dbo.FlightBooking (TicketID, FlightID, PassengerID, FareClass, BookingStatus, TicketPrice, PurchaseDate)
        VALUES (@newTicketID, @FlightID, @PassengerID, @FareClass, @BookingStatus, @TicketPrice, @PurchaseDate);

        -- Disable IDENTITY_INSERT
        SET IDENTITY_INSERT dbo.FlightBooking OFF;

        -- Set success message with the computed TicketNumber
        SET @message = 'Flight booking created successfully. TicketNumber: TNO-' + RIGHT('00000' + CAST(@newTicketID AS VARCHAR), 5);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000);
        SELECT @ErrorMessage = ERROR_MESSAGE();

        SET @message = 'An error occurred during flight booking: ' + @ErrorMessage;
    END CATCH
END;
GO

DECLARE @message VARCHAR(200);

EXEC sp_CreateFlightBooking 
    @FlightNumber = 'FL5278', 
    @Email = 'veronica54@example.net', 
    @FareClass = 'Economy', 
    @BookingStatus = 'Confirmed', 
    @TicketPrice = 299.99,
    @message = @message OUTPUT;

PRINT @message;

SELECT * FROM FlightBooking;

-- DELETE FROM FlightBooking where TicketID = 201;


-- 2. Manages passenger check-in and issues a boarding pass.
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_CheckInPassenger;
GO

-- Create the sp_CheckInPassenger procedure
-- CREATE PROCEDURE sp_CheckInPassenger
--     @TicketID INT, @PassengerID INT, @SeatNumber VARCHAR(10), @message VARCHAR(200) OUTPUT
-- AS
-- BEGIN
--     DECLARE @FlightID INT;
--     BEGIN TRY
--         BEGIN TRANSACTION;
--         -- Validate if the TicketID exists
--         IF NOT EXISTS (SELECT 1 FROM dbo.FlightBooking WHERE TicketID = @TicketID)
--         BEGIN
--             SET @message = 'Error: TicketID ' + CAST(@TicketID AS VARCHAR) + ' does not exist.';
--             IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
--             RETURN;
--         END
--         -- Validate if the PassengerID exists
--         IF NOT EXISTS (SELECT 1 FROM dbo.Passenger WHERE PassengerID = @PassengerID)
--         BEGIN
--             SET @message = 'Error: PassengerID ' + CAST(@PassengerID AS VARCHAR) + ' does not exist.';
--             IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
--             RETURN;
--         END
--         -- Validate if the TicketID and PassengerID match with a confirmed booking
--         IF NOT EXISTS (SELECT 1 FROM dbo.FlightBooking WHERE TicketID = @TicketID AND PassengerID = @PassengerID)
--         BEGIN
--             SET @message = 'Error: TicketID ' + CAST(@TicketID AS VARCHAR) + ' does not match PassengerID ' + CAST(@PassengerID AS VARCHAR) + '.';
--             IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
--             RETURN;
--         END
--         -- Validate if the booking status is 'Confirmed'
--         IF NOT EXISTS (SELECT 1 FROM dbo.FlightBooking WHERE TicketID = @TicketID AND BookingStatus = 'Confirmed')
--         BEGIN
--             SET @message = 'Error: Booking for TicketID ' + CAST(@TicketID AS VARCHAR) + ' is not confirmed.';
--             IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
--             RETURN;
--         END
--         -- Get FlightID from the ticket
--         SELECT @FlightID = FlightID
--         FROM dbo.FlightBooking
--         WHERE TicketID = @TicketID;
--         -- Check if the passenger is already checked in (boarding pass exists)
--         IF EXISTS (SELECT 1 FROM dbo.BoardingPass WHERE TicketID = @TicketID)
--         BEGIN
--             SET @message = 'Error: Passenger is already checked in for TicketID ' + CAST(@TicketID AS VARCHAR) + '.';
--             IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
--             RETURN;
--         END
--         -- Check if the chosen SeatNumber is already occupied
--         IF EXISTS (SELECT 1 FROM dbo.BoardingPass WHERE SeatNumber = @SeatNumber AND TicketID IN (SELECT TicketID FROM dbo.FlightBooking WHERE FlightID = @FlightID))
--         BEGIN
--             SET @message = 'Error: Seat ' + @SeatNumber + ' is already occupied. Please choose a different seat.';
--             IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
--             RETURN;
--         END
--         -- Assign the seat and issue the boarding pass
--         INSERT INTO dbo.BoardingPass (PassengerID, TicketID, SeatNumber, BoardingGroup, IssueTime)
--         VALUES (@PassengerID, @TicketID, @SeatNumber, 'A', GETDATE());
--         -- Set success message
--         SET @message = 'Check-in successful for PassengerID ' + CAST(@PassengerID AS VARCHAR) + '. Seat assigned: ' + @SeatNumber;
--         COMMIT TRANSACTION;
--     END TRY
--     BEGIN CATCH
--         IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

--         DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
--         SELECT
--             @ErrorMessage = ERROR_MESSAGE(),
--             @ErrorSeverity = ERROR_SEVERITY(),
--             @ErrorState = ERROR_STATE();

--         SET @message = 'An error occurred during check-in: ' + @ErrorMessage;
--     END CATCH
-- END;
-- GO

CREATE PROCEDURE sp_CheckInPassenger
    @TicketID INT, 
    @SeatNumber VARCHAR(10), 
    @message VARCHAR(200) OUTPUT
AS
BEGIN
    DECLARE @PassengerID INT;
    DECLARE @FlightID INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate if the TicketID exists
        IF NOT EXISTS (SELECT 1 FROM dbo.FlightBooking WHERE TicketID = @TicketID)
        BEGIN
            SET @message = 'Error: TicketID ' + CAST(@TicketID AS VARCHAR) + ' does not exist.';
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validate if the booking status is 'Confirmed'
        IF NOT EXISTS (SELECT 1 FROM dbo.FlightBooking WHERE TicketID = @TicketID AND BookingStatus = 'Confirmed')
        BEGIN
            SET @message = 'Error: Booking for TicketID ' + CAST(@TicketID AS VARCHAR) + ' is not confirmed.';
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Get PassengerID and FlightID from the ticket
        SELECT @PassengerID = PassengerID, @FlightID = FlightID
        FROM dbo.FlightBooking
        WHERE TicketID = @TicketID;

        -- Check if the passenger is already checked in (boarding pass exists)
        IF EXISTS (SELECT 1 FROM dbo.BoardingPass WHERE TicketID = @TicketID)
        BEGIN
            SET @message = 'Error: Passenger is already checked in for TicketID ' + CAST(@TicketID AS VARCHAR) + '.';
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Check if the chosen SeatNumber is already occupied
        IF EXISTS (SELECT 1 FROM dbo.BoardingPass WHERE SeatNumber = @SeatNumber AND TicketID IN (SELECT TicketID FROM dbo.FlightBooking WHERE FlightID = @FlightID))
        BEGIN
            SET @message = 'Error: Seat ' + @SeatNumber + ' is already occupied. Please choose a different seat.';
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Assign the seat and issue the boarding pass
        INSERT INTO dbo.BoardingPass (PassengerID, TicketID, SeatNumber, BoardingGroup, IssueTime)
        VALUES (@PassengerID, @TicketID, @SeatNumber, 'A', GETDATE());

        -- Set success message
        SET @message = 'Check-in successful for PassengerID ' + CAST(@PassengerID AS VARCHAR) + '. Seat assigned: ' + @SeatNumber;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        SET @message = 'An error occurred during check-in: ' + @ErrorMessage;
    END CATCH
END;
GO

-- Testing the sp_CheckInPassenger procedure with TicketID and PassengerID
DECLARE @message VARCHAR(200);

EXEC sp_CheckInPassenger
    @TicketID = 16,
    @SeatNumber = '16A',  -- Manually chosen seat
    @message = @message OUTPUT;

PRINT @message;

Select * FROM BoardingPass;

-- Fetches flight details including schedule and status.
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_GetFlightDetails;
GO

-- Create the sp_GetFlightDetails procedure
CREATE PROCEDURE sp_GetFlightDetails
    @FlightID INT,
    @message VARCHAR(200) OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Validate FlightID
        IF NOT EXISTS (SELECT 1 FROM dbo.Flight WHERE FlightID = @FlightID)
        BEGIN
            SET @message = 'Invalid FlightID. Please provide a valid FlightID.';
            RETURN;
        END

        -- Fetch flight details including flight name, number, schedule, status, and airport names
        SELECT 
            f.FlightID,
            f.FlightName,
            f.FlightNumber,
            a.AirlineName,
            f.DepartureTime,
            f.ArrivalTime,
            sa.AirportName AS SourceAirport,
            da.AirportName AS DestinationAirport,
            f.FlightStatus
        FROM 
            dbo.Flight f
        INNER JOIN 
            dbo.Airline a ON f.AirlineID = a.AirlineID
        INNER JOIN 
            dbo.Airport sa ON f.SourceAirportID = sa.AirportID
        INNER JOIN 
            dbo.Airport da ON f.DestinationAirportID = da.AirportID
        WHERE 
            f.FlightID = @FlightID;

        -- Set success message
        SET @message = 'Flight details retrieved successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        SET @message = 'An error occurred while fetching flight details: ' + @ErrorMessage;
    END CATCH
END;
GO

-- Testing the sp_GetFlightDetails procedure
DECLARE @message VARCHAR(200);
EXEC sp_GetFlightDetails
    @FlightID = 7,
    @message = @message OUTPUT;

PRINT @message;



-- Admin Login In Mind:
-- Updates the status of a flight 
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_UpdateFlightStatus;
GO

-- Create the sp_UpdateFlightStatus procedure
CREATE PROCEDURE sp_UpdateFlightStatus
    @FlightID INT,
    @NewStatus VARCHAR(20),
    @message VARCHAR(200) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate FlightID
        IF NOT EXISTS (SELECT 1 FROM dbo.Flight WHERE FlightID = @FlightID)
        BEGIN
            SET @message = 'Invalid FlightID. Please provide a valid FlightID.';
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validate the new status
        IF @NewStatus NOT IN ('Scheduled', 'Delayed', 'Cancelled', 'Completed')
        BEGIN
            SET @message = 'Invalid Flight Status. Please use one of the following: Scheduled, Delayed, Cancelled, or Completed.';
            IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Update the flight status
        UPDATE dbo.Flight
        SET FlightStatus = @NewStatus
        WHERE FlightID = @FlightID;

        -- Set success message
        SET @message = 'Flight status updated successfully to ' + @NewStatus + ' for FlightID: ' + CAST(@FlightID AS VARCHAR);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        SET @message = 'An error occurred while updating the flight status: ' + @ErrorMessage;
    END CATCH
END;
GO

-- Testing the sp_UpdateFlightStatus procedure
DECLARE @message VARCHAR(200);

EXEC sp_UpdateFlightStatus
    @FlightID = 7,
    @NewStatus = 'Delayed',
    @message = @message OUTPUT;

PRINT @message;

-- Security Login
-- Retrieves a list of available parking slots in real-time.
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_GetAvailableParkingSlots;
GO

-- Create the sp_GetAvailableParkingSlots procedure
CREATE PROCEDURE sp_GetAvailableParkingSlots
AS
BEGIN
    BEGIN TRY
        -- Retrieve available parking slots
        SELECT 
            SlotNumber,
            AirportID,
            AvailabilityStatus
        FROM 
            dbo.ParkingSlots
        WHERE 
            AvailabilityStatus = 'Available'
        ORDER BY 
            SlotNumber;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        PRINT 'An error occurred while retrieving available parking slots: ' + @ErrorMessage;
    END CATCH
END;
GO

-- Testing the sp_GetAvailableParkingSlots procedure
EXEC sp_GetAvailableParkingSlots;

-- Provides the shift schedule for employees
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_GetEmployeeShiftSchedule;
GO

-- Create the sp_GetEmployeeShiftSchedule procedure
CREATE PROCEDURE sp_GetEmployeeShiftSchedule
    @EmployeeType VARCHAR(50),
    @message VARCHAR(200) OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Validate the input for EmployeeType
        IF @EmployeeType NOT IN ('SecurityStaff', 'GroundStaff')
        BEGIN
            SET @message = 'Invalid EmployeeType. Please use "SecurityStaff" or "GroundStaff".';
            RETURN;
        END

        -- Fetch shift schedule for SecurityStaff
        IF @EmployeeType = 'SecurityStaff'
        BEGIN
            SELECT 
                e.EmployeeID,
                e.FirstName,
                e.LastName,
                'SecurityStaff' AS EmployeeType,
                ss.AssignedArea,
                ss.ShiftStart,
                ss.ShiftEnd,
                ss.Role
            FROM dbo.Employee e
            JOIN dbo.SecurityStaff ss ON e.EmployeeID = ss.EmployeeID
            ORDER BY ss.ShiftStart;
            
            SET @message = 'SecurityStaff shift schedule fetched successfully.';
        END

        -- Fetch shift schedule for GroundStaff
        ELSE IF @EmployeeType = 'GroundStaff'
        BEGIN
            SELECT 
                e.EmployeeID,
                e.FirstName,
                e.LastName,
                'GroundStaff' AS EmployeeType,
                gs.AssignedTasks,
                gs.ShiftGroup,
                (CASE
                    WHEN gs.ShiftGroup = 'A' THEN 'Morning Shift'
                    WHEN gs.ShiftGroup = 'B' THEN 'Afternoon Shift'
                    WHEN gs.ShiftGroup = 'C' THEN 'Evening Shift'
                    WHEN gs.ShiftGroup = 'D' THEN 'Night Shift'
                    ELSE 'Miscellaneous'
                END) AS ShiftDescription
            FROM dbo.Employee e
            JOIN dbo.GroundStaff gs ON e.EmployeeID = gs.EmployeeID
            ORDER BY gs.ShiftGroup;
            
            SET @message = 'GroundStaff shift schedule fetched successfully.';
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        SET @message = 'An error occurred while fetching employee shift schedules: ' + @ErrorMessage;
    END CATCH
END;
GO

-- Test for SecurityStaff
DECLARE @message VARCHAR(200);
EXEC sp_GetEmployeeShiftSchedule @EmployeeType = 'SecurityStaff', @message = @message OUTPUT;
PRINT @message;

-- Test for GroundStaff
EXEC sp_GetEmployeeShiftSchedule @EmployeeType = 'GroundStaff', @message = @message OUTPUT;
PRINT @message;


-- Retrieves loyalty program details for a passenger.
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_GetPassengerLoyaltyInfo;
GO

-- Create the sp_GetPassengerLoyaltyInfo procedure
CREATE PROCEDURE sp_GetPassengerLoyaltyInfo
    @PassengerID INT,
    @message VARCHAR(200) OUTPUT
AS
BEGIN
    DECLARE @FullName VARCHAR(100);

    BEGIN TRY
        -- Validate PassengerID
        IF NOT EXISTS (SELECT 1 FROM dbo.Passenger WHERE PassengerID = @PassengerID)
        BEGIN
            SET @message = 'Invalid PassengerID. Passenger not found.';
            RETURN;
        END

        -- Check if the passenger is enrolled in the LoyaltyProgram
        IF NOT EXISTS (SELECT 1 FROM dbo.LoyaltyProgram WHERE PassengerID = @PassengerID)
        BEGIN
            SET @message = 'The passenger is not enrolled in any loyalty program.';
            RETURN;
        END

        -- Get Full Name of the passenger
        SELECT @FullName = CONCAT(FirstName, ' ', LastName)
        FROM dbo.Passenger
        WHERE PassengerID = @PassengerID;

        -- Fetch Loyalty Program Details
        SELECT
            lp.LoyaltyID,
            @FullName AS FullName,
            lp.LoyaltyPoints,
            lp.LoyaltyStatus,
            lp.EnrollmentDate
        FROM
            dbo.LoyaltyProgram lp
        WHERE
            lp.PassengerID = @PassengerID;

        -- Set success message
        SET @message = 'Loyalty program details retrieved successfully for ' + @FullName + '.';
    END TRY
    BEGIN CATCH
        -- Error handling
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        SET @message = 'An error occurred while fetching loyalty program details: ' + @ErrorMessage;
    END CATCH
END;
GO

-- Declare an output message variable
DECLARE @message VARCHAR(200);

-- Execute the procedure with a valid PassengerID
EXEC sp_GetPassengerLoyaltyInfo
    @PassengerID = 3005,
    @message = @message OUTPUT;

-- Print the output message
PRINT @message;


-- Updates the contact details of a passenger (e.g., phone, email).
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_UpdatePassengerContactInfo;
GO

-- Create the updated stored procedure
CREATE PROCEDURE sp_UpdatePassengerContactInfo
    @PassengerID INT,
    @PhoneNumber VARCHAR(15) = NULL,
    @Email VARCHAR(100) = NULL
AS
BEGIN
    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;

        -- Validate the PassengerID
        IF NOT EXISTS (SELECT 1 FROM dbo.Passenger WHERE PassengerID = @PassengerID)
        BEGIN
            RAISERROR('Invalid PassengerID. Please provide a valid PassengerID.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validate the email format (must contain '@')
        IF @Email IS NOT NULL AND CHARINDEX('@', @Email) = 0
        BEGIN
            RAISERROR('Invalid email format. The email must contain an "@" symbol.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Update Phone number if provided
        IF @PhoneNumber IS NOT NULL
        BEGIN
            UPDATE dbo.Phone
            SET PhoneNumber = @PhoneNumber
            WHERE PassengerID = @PassengerID;

            -- Check if the update was successful
            IF @@ROWCOUNT = 0
            BEGIN
                RAISERROR('No phone record found for the specified PassengerID.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END

        -- Update Email if provided
        IF @Email IS NOT NULL
        BEGIN
            UPDATE dbo.Passenger
            SET Email = @Email
            WHERE PassengerID = @PassengerID;

            -- Check if the update was successful
            IF @@ROWCOUNT = 0
            BEGIN
                RAISERROR('Failed to update the email for the specified PassengerID.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END

        -- Commit the transaction if all updates are successful
        COMMIT TRANSACTION;

        PRINT 'Contact information updated successfully.';
    END TRY
    BEGIN CATCH
        -- Handle errors and rollback the transaction
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('An error occurred while updating contact information: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO


-- Update phone number and email for a specific passenger
EXEC sp_UpdatePassengerContactInfo 
    @PassengerID = 3001,
    @PhoneNumber = '123-456-7890',
    @Email = 'john.doe@newemail.com';

-- Update only the email
EXEC sp_UpdatePassengerContactInfo 
    @PassengerID = 3002,
    @Email = 'jane.smith@updatedmail.co.uk';

-- Update only the phone number
EXEC sp_UpdatePassengerContactInfo 
    @PassengerID = 3003,
    @PhoneNumber = '987-654-3210';

-- Shows detailed information about passengers' bookings, including flight details, fare class, and loyalty status. 
-- This is useful for airline staff and customer service.
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_PassengerBookingDetails;
GO

-- Create the stored procedure
CREATE PROCEDURE sp_PassengerBookingDetails
    @PassengerID INT
AS
BEGIN
    BEGIN TRY
        -- Validate the PassengerID
        IF NOT EXISTS (SELECT 1 FROM dbo.Passenger WHERE PassengerID = @PassengerID)
        BEGIN
            RAISERROR('Invalid PassengerID. Please provide a valid PassengerID.', 16, 1);
            RETURN;
        END

        -- Fetch the booking details
        SELECT 
            dbo.fn_GetEmployeeFullName(P.FirstName, P.LastName) AS FullName,
            F.FlightName,
            F.FlightNumber,
            F.DepartureTime,
            F.ArrivalTime,
            FB.FareClass,
            dbo.fn_GetPassengerLoyaltyStatus(LP.LoyaltyPoints) AS LoyaltyStatus,
            FB.BookingStatus
        FROM dbo.FlightBooking FB
        JOIN dbo.Flight F ON FB.FlightID = F.FlightID
        JOIN dbo.Passenger P ON FB.PassengerID = P.PassengerID
        LEFT JOIN dbo.LoyaltyProgram LP ON P.PassengerID = LP.PassengerID
        WHERE P.PassengerID = @PassengerID;

    END TRY
    BEGIN CATCH
        -- Handle errors and provide meaningful feedback
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('An error occurred while retrieving booking details: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

-- Retrieve booking details for a specific passenger
EXEC sp_PassengerBookingDetails @PassengerID = 3008;


-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_AssignGateToFlight;
GO

CREATE PROCEDURE sp_AssignGateToFlight
    @FlightID INT
AS
BEGIN
    -- Declare variables
    DECLARE @SourceAirportID INT;
    DECLARE @SelectedGateID INT;
    DECLARE @DepartureTime DATETIME;
    DECLARE @ArrivalTime DATETIME;
    DECLARE @FlightStatus VARCHAR(20);

    -- Start a transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Step 1: Validate the FlightID
        IF NOT EXISTS (SELECT 1 FROM Flight WHERE FlightID = @FlightID)
        BEGIN
            RAISERROR('Invalid FlightID. Please provide a valid FlightID.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Step 2: Get the Flight Status, SourceAirportID, DepartureTime, and ArrivalTime
        SELECT @FlightStatus = FlightStatus, @SourceAirportID = SourceAirportID,
               @DepartureTime = DepartureTime, @ArrivalTime = ArrivalTime
        FROM Flight
        WHERE FlightID = @FlightID;

        -- Validate the Flight Status
        IF @FlightStatus <> 'Scheduled'
        BEGIN
            RAISERROR('Gate can only be assigned to Scheduled flights.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Step 3: Find an Available Gate at the Source Airport with No Time Overlap
        SELECT TOP 1 @SelectedGateID = GateID
        FROM Gate G
        WHERE G.AirportID = @SourceAirportID
          AND G.GateStatus = 'Available'
          AND NOT EXISTS (
              SELECT 1
              FROM Flight F
              WHERE F.GateID = G.GateID
                AND F.FlightStatus = 'Scheduled'
                AND (
                    (@DepartureTime BETWEEN F.DepartureTime AND F.ArrivalTime) OR
                    (@ArrivalTime BETWEEN F.DepartureTime AND F.ArrivalTime) OR
                    (F.DepartureTime BETWEEN @DepartureTime AND @ArrivalTime) OR
                    (F.ArrivalTime BETWEEN @DepartureTime AND @ArrivalTime)
                )
          )
        ORDER BY G.GateID;

        -- Check if an available gate was found
        IF @SelectedGateID IS NULL
        BEGIN
            RAISERROR('No available gates found at the source airport.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Step 4: Assign the Selected Gate to the Flight
        UPDATE Flight
        SET GateID = @SelectedGateID
        WHERE FlightID = @FlightID;

        -- Step 5: Update the Gate Status to 'Occupied'
        UPDATE Gate
        SET GateStatus = 'Occupied'
        WHERE GateID = @SelectedGateID;

        -- Commit the transaction
        COMMIT TRANSACTION;

        PRINT 'Gate assigned successfully to the flight.';

    END TRY
    BEGIN CATCH
        -- Handle errors and rollback the transaction
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO


-- Assign an available gate to Flight 3
EXEC sp_AssignGateToFlight @FlightID = 3;

-- Verify the assignment
SELECT FlightID, GateID, FlightStatus
FROM Flight
WHERE FlightID = 3;

-- Check the gate status
SELECT GateID, GateNumber, GateStatus
FROM Gate
WHERE GateID = (SELECT GateID FROM Flight WHERE FlightID = 3);


-- Drop the procedure if it already exists
IF OBJECT_ID('dbo.sp_GenerateMonthlyFlightReport', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GenerateMonthlyFlightReport;
GO

CREATE PROCEDURE dbo.sp_GenerateMonthlyFlightReport
    @ReportMonth INT,   -- Month for the report (1 to 12)
    @ReportYear INT     -- Year for the report (e.g., 2024)
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables for report metrics
    DECLARE @TotalFlights INT = 0;
    DECLARE @CompletedFlights INT = 0;
    DECLARE @DelayedFlights INT = 0;
    DECLARE @CancelledFlights INT = 0;
    DECLARE @AverageDelayDuration INT = 0;
    DECLARE @TotalRevenue DECIMAL(15, 2) = 0.0;

    -- Input validation
    IF @ReportMonth < 1 OR @ReportMonth > 12
    BEGIN
        RAISERROR('Invalid ReportMonth. Please provide a value between 1 and 12.', 16, 1);
        RETURN;
    END

    IF @ReportYear < 2000 OR @ReportYear > YEAR(GETDATE())
    BEGIN
        RAISERROR('Invalid ReportYear. Please provide a valid year.', 16, 1);
        RETURN;
    END

    -- Start a transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Step 1: Calculate Total Flights
        SELECT @TotalFlights = COUNT(*)
        FROM dbo.Flight
        WHERE MONTH(DepartureTime) = @ReportMonth
          AND YEAR(DepartureTime) = @ReportYear;

        -- Step 2: Calculate Completed Flights
        SELECT @CompletedFlights = COUNT(*)
        FROM dbo.Flight
        WHERE FlightStatus = 'Completed'
          AND MONTH(DepartureTime) = @ReportMonth
          AND YEAR(DepartureTime) = @ReportYear;

        -- Step 3: Calculate Delayed Flights
        SELECT @DelayedFlights = COUNT(*)
        FROM dbo.Flight
        WHERE FlightStatus = 'Delayed'
          AND MONTH(DepartureTime) = @ReportMonth
          AND YEAR(DepartureTime) = @ReportYear;

        -- Step 4: Calculate Cancelled Flights
        SELECT @CancelledFlights = COUNT(*)
        FROM dbo.Flight
        WHERE FlightStatus = 'Cancelled'
          AND MONTH(DepartureTime) = @ReportMonth
          AND YEAR(DepartureTime) = @ReportYear;

        -- Step 5: Calculate Average Delay Duration
        SELECT @AverageDelayDuration = ISNULL(AVG(DATEDIFF(MINUTE, ArrivalTime, ActualArrivalTime)), 0)
        FROM dbo.Flight
        WHERE FlightStatus = 'Delayed'
          AND MONTH(DepartureTime) = @ReportMonth
          AND YEAR(DepartureTime) = @ReportYear;

        -- Step 6: Calculate Total Revenue
        SELECT @TotalRevenue = ISNULL(SUM(FB.TicketPrice), 0.0)
        FROM dbo.FlightBooking FB
        JOIN dbo.Flight F ON FB.FlightID = F.FlightID
        WHERE MONTH(F.DepartureTime) = @ReportMonth
          AND YEAR(F.DepartureTime) = @ReportYear
          AND FB.BookingStatus = 'Confirmed';

        -- Commit the transaction
        COMMIT TRANSACTION;

        -- Return the report as a result set
        SELECT
            @ReportMonth AS ReportMonth,
            @ReportYear AS ReportYear,
            @TotalFlights AS TotalFlights,
            @CompletedFlights AS CompletedFlights,
            @DelayedFlights AS DelayedFlights,
            @CancelledFlights AS CancelledFlights,
            @AverageDelayDuration AS AverageDelayDuration,
            @TotalRevenue AS TotalRevenue;

    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of error
        ROLLBACK TRANSACTION;

        -- Capture and return the error details
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        RETURN;
    END CATCH;
END;
GO

EXEC dbo.sp_GenerateMonthlyFlightReport @ReportMonth = 1, @ReportYear = 2024;



-- Generates a report on gate usage for optimization.
IF OBJECT_ID('dbo.sp_GetGateUtilizationReport', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetGateUtilizationReport;
GO

CREATE PROCEDURE dbo.sp_GetGateUtilizationReport
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Retrieve gate utilization statistics
        SELECT
            G.GateID,
            G.GateNumber,
            G.Terminal,
            G.GateStatus,
            COUNT(F.FlightID) AS AssignedFlights,
            CAST(COUNT(F.FlightID) * 100.0 / NULLIF((SELECT COUNT(*) FROM dbo.Flight), 0) AS DECIMAL(5, 2)) AS UtilizationPercentage
        FROM dbo.Gate G
        LEFT JOIN dbo.Flight F ON G.GateID = F.GateID
        GROUP BY G.GateID, G.GateNumber, G.Terminal, G.GateStatus
        ORDER BY UtilizationPercentage DESC;
    END TRY
    BEGIN CATCH
        -- Error handling block
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO

EXEC dbo.sp_GetGateUtilizationReport;


-- Generates a report on revenue collected from parking slots.
IF OBJECT_ID('dbo.sp_GetParkingRevenueReport', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetParkingRevenueReport;
GO

CREATE PROCEDURE dbo.sp_GetParkingRevenueReport
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Calculate total parking revenue by slot
        SELECT
            PS.SlotNumber,
            COUNT(P.ParkingID) AS TotalParkings,
            SUM(P.ParkingFee) AS TotalRevenue,
            PS.AvailabilityStatus
        FROM dbo.ParkingSlots PS
        LEFT JOIN dbo.Parking P ON PS.SlotNumber = P.SlotNumber
        GROUP BY PS.SlotNumber, PS.AvailabilityStatus
        ORDER BY TotalRevenue DESC;
    END TRY
    BEGIN CATCH
        -- Error handling block
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO

EXEC dbo.sp_GetParkingRevenueReport;


-- Returns a list of passengers with the highest loyalty points.
IF OBJECT_ID('dbo.sp_GetTopFrequentFlyers', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetTopFrequentFlyers;
GO

CREATE PROCEDURE dbo.sp_GetTopFrequentFlyers
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Retrieve top 10 frequent flyers based on loyalty points
        SELECT TOP 10
            P.PassengerID,
            P.FirstName,
            P.LastName,
            LP.LoyaltyPoints,
            LP.LoyaltyStatus
        FROM dbo.Passenger P
        JOIN dbo.LoyaltyProgram LP ON P.PassengerID = LP.PassengerID
        ORDER BY LP.LoyaltyPoints DESC;
    END TRY
    BEGIN CATCH
        -- Error handling block
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO

EXEC dbo.sp_GetTopFrequentFlyers;

-- Inserts or updates luggage details for a passenger.
IF OBJECT_ID('dbo.sp_RecordLuggageDetails', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RecordLuggageDetails;
GO

CREATE PROCEDURE dbo.sp_RecordLuggageDetails
    @LuggageID INT = NULL,
    @AirportID INT,
    @TicketID INT,
    @PassengerID INT,
    @NumberOfBags INT,
    @Weight DECIMAL(10, 2),
    @Status VARCHAR(20),
    @BaggageLocation VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @LuggageID IS NULL
        BEGIN
            -- Insert new luggage record
            INSERT INTO dbo.Luggage (AirportID, TicketID, PassengerID, NumberOfBags, [Weight], [Status], BaggageLocation)
            VALUES (@AirportID, @TicketID, @PassengerID, @NumberOfBags, @Weight, @Status, @BaggageLocation);
            
            PRINT 'Luggage record inserted successfully.';
        END
        ELSE
        BEGIN
            -- Update existing luggage record
            UPDATE dbo.Luggage
            SET
                AirportID = @AirportID,
                TicketID = @TicketID,
                PassengerID = @PassengerID,
                NumberOfBags = @NumberOfBags,
                [Weight] = @Weight,
                [Status] = @Status,
                BaggageLocation = @BaggageLocation
            WHERE LuggageID = @LuggageID;

            PRINT 'Luggage record updated successfully.';
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO

EXEC dbo.sp_RecordLuggageDetails
    @LuggageID = NULL,
    @AirportID = 1,
    @TicketID = 1,
    @PassengerID = 3000,
    @NumberOfBags = 2,
    @Weight = 45.5,
    @Status = 'Checked In',
    @BaggageLocation = 'Terminal 1 - Area B';

-- Retrieves details of lost luggage based on PassengerID or LuggageID.
IF OBJECT_ID('dbo.sp_TrackLostLuggage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_TrackLostLuggage;
GO

CREATE PROCEDURE dbo.sp_TrackLostLuggage
    @LuggageID INT = NULL,
    @PassengerID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Fetch lost luggage details based on provided parameters
        SELECT
            L.LuggageID,
            L.PassengerID,
            P.FirstName + ' ' + P.LastName AS PassengerName,
            L.NumberOfBags,
            L.[Weight],
            L.[Status],
            L.BaggageLocation
        FROM dbo.Luggage L
        JOIN dbo.Passenger P ON L.PassengerID = P.PassengerID
        WHERE L.[Status] = 'Lost'
        AND (@LuggageID IS NULL OR L.LuggageID = @LuggageID)
        AND (@PassengerID IS NULL OR L.PassengerID = @PassengerID);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO

EXEC dbo.sp_TrackLostLuggage
    @LuggageID = NULL,
    @PassengerID = 3003;

-- Allocates an available runway for a flight.
IF OBJECT_ID('dbo.sp_AllocateRunwayToFlight', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_AllocateRunwayToFlight;
GO

CREATE PROCEDURE dbo.sp_AllocateRunwayToFlight
    @FlightID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @RunwayID INT;

        -- Find an available runway
        SELECT TOP 1 @RunwayID = RunwayID
        FROM dbo.RunwayManagement
        WHERE OccupiedStatus = 'Available'
        ORDER BY RunwayID;

        IF @RunwayID IS NULL
        BEGIN
            RAISERROR('No available runway found.', 16, 1);
            RETURN;
        END

        -- Update the flight with the allocated runway
        UPDATE dbo.Flight
        SET RunwayID = @RunwayID
        WHERE FlightID = @FlightID;

        -- Mark the runway as occupied
        UPDATE dbo.RunwayManagement
        SET OccupiedStatus = 'Occupied'
        WHERE RunwayID = @RunwayID;

        PRINT 'Runway allocated successfully.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO

EXEC dbo.sp_AllocateRunwayToFlight
    @FlightID = 5;

-- Provides a report on baggage load distribution for a specific flight.
IF OBJECT_ID('dbo.sp_GetBaggageLoadDistribution', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetBaggageLoadDistribution;
GO

CREATE PROCEDURE dbo.sp_GetBaggageLoadDistribution
    @FlightID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Retrieve baggage load distribution for the specified flight
        SELECT
            F.FlightNumber,
            F.FlightName,
            COUNT(L.LuggageID) AS TotalBags,
            SUM(L.[Weight]) AS TotalWeight,
            AVG(L.[Weight]) AS AverageWeight,
            MAX(L.[Weight]) AS MaxWeight,
            MIN(L.[Weight]) AS MinWeight
        FROM dbo.Flight F
        JOIN dbo.FlightBooking FB ON F.FlightID = FB.FlightID
        JOIN dbo.Luggage L ON FB.TicketID = L.TicketID
        WHERE F.FlightID = @FlightID
        GROUP BY F.FlightNumber, F.FlightName;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;
GO

EXEC dbo.sp_GetBaggageLoadDistribution
    @FlightID = 1;

-- Updates employee information such as salary and assigned area.
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_UpdateEmployeeDetails;
GO

CREATE PROCEDURE sp_UpdateEmployeeDetails
    @EmployeeID INT,
    @Salary DECIMAL(10, 2) = NULL,
    @AssignedArea VARCHAR(100) = NULL,
    @message VARCHAR(200) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate EmployeeID
        IF NOT EXISTS (SELECT 1 FROM dbo.Employee WHERE EmployeeID = @EmployeeID)
        BEGIN
            SET @message = 'Invalid EmployeeID: ' + CAST(@EmployeeID AS VARCHAR);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Update Salary if provided
        IF @Salary IS NOT NULL
        BEGIN
            UPDATE dbo.Employee
            SET Salary = @Salary
            WHERE EmployeeID = @EmployeeID;
        END

        -- Update AssignedArea if provided (for SecurityStaff)
        IF @AssignedArea IS NOT NULL
        BEGIN
            UPDATE dbo.SecurityStaff
            SET AssignedArea = @AssignedArea
            WHERE EmployeeID = @EmployeeID;
        END

        SET @message = 'Employee details updated successfully for EmployeeID: ' + CAST(@EmployeeID AS VARCHAR);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET @message = 'Error updating employee details: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test sp_UpdateEmployeeDetails
DECLARE @message VARCHAR(200);

EXEC sp_UpdateEmployeeDetails
    @EmployeeID = 10002,
    @AssignedArea = 'Loading/Unloading',
    @message = @message OUTPUT;
PRINT @message;

-- Allocates ground support equipment to ground staff.
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_AssignEquipmentToGroundStaff;
GO

CREATE PROCEDURE sp_AssignEquipmentToGroundStaff
    @EquipmentID INT,
    @EmployeeID INT,
    @AssignDate DATETIME,
    @message VARCHAR(200) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate EquipmentID
        IF NOT EXISTS (SELECT 1 FROM dbo.GroundSupport WHERE EquipmentID = @EquipmentID)
        BEGIN
            SET @message = 'Invalid EquipmentID: ' + CAST(@EquipmentID AS VARCHAR);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validate EmployeeID (must be GroundStaff)
        IF NOT EXISTS (SELECT 1 FROM dbo.GroundStaff WHERE EmployeeID = @EmployeeID)
        BEGIN
            SET @message = 'Invalid EmployeeID: ' + CAST(@EmployeeID AS VARCHAR);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Check if the assignment already exists
        IF EXISTS (SELECT 1 FROM dbo.EquipmentAssignment WHERE EquipmentID = @EquipmentID AND EmployeeID = @EmployeeID)
        BEGIN
            SET @message = 'EquipmentID ' + CAST(@EquipmentID AS VARCHAR) + ' is already assigned to EmployeeID ' + CAST(@EmployeeID AS VARCHAR);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Assign equipment
        INSERT INTO dbo.EquipmentAssignment (EquipmentID, EmployeeID, Assign_Date)
        VALUES (@EquipmentID, @EmployeeID, @AssignDate);

        SET @message = 'Equipment assigned successfully to EmployeeID: ' + CAST(@EmployeeID AS VARCHAR);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET @message = 'Error assigning equipment: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Declare the output variable
DECLARE @message VARCHAR(200);

-- Test Case: Assigning EquipmentID 440 to EmployeeID 10002 (already exists)
EXEC sp_AssignEquipmentToGroundStaff
    @EquipmentID = 440,
    @EmployeeID = 10002,
    @AssignDate = '2024-11-16',
    @message = @message OUTPUT;
PRINT @message;

-- Test Case: Assigning EquipmentID 441 to EmployeeID 10002 (new assignment)
EXEC sp_AssignEquipmentToGroundStaff
    @EquipmentID = 441,
    @EmployeeID = 10002,
    @AssignDate = '2024-11-16',
    @message = @message OUTPUT;
PRINT @message;


-- Retrieves maintenance schedule details for an aircraft.
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_GetAircraftMaintenanceSchedule;
GO

CREATE PROCEDURE sp_GetAircraftMaintenanceSchedule
    @AircraftID INT,
    @message VARCHAR(200) OUTPUT
AS
BEGIN
    BEGIN TRY
        -- Validate AircraftID
        IF NOT EXISTS (SELECT 1 FROM dbo.Aircraft WHERE AircraftID = @AircraftID)
        BEGIN
            SET @message = 'Invalid AircraftID: ' + CAST(@AircraftID AS VARCHAR);
            RETURN;
        END

        -- Retrieve maintenance schedule details
        SELECT MaintenanceID, MaintenanceDate, MaintenanceType, MaintenanceStatus, NextScheduledMaintenance
        FROM dbo.Maintenance
        WHERE AircraftID = @AircraftID
        ORDER BY MaintenanceDate DESC;

        SET @message = 'Maintenance schedule retrieved successfully for AircraftID: ' + CAST(@AircraftID AS VARCHAR);
    END TRY
    BEGIN CATCH
        SET @message = 'Error retrieving maintenance schedule: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Declare the output variable before testing
DECLARE @message VARCHAR(200);
-- Test sp_GetAircraftMaintenanceSchedule
EXEC sp_GetAircraftMaintenanceSchedule
    @AircraftID = 1,
    @message = @message OUTPUT;
PRINT @message;

-- Updates the maintenance status for aircraft or ground support equipment.
-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_UpdateMaintenanceStatus;
GO

CREATE PROCEDURE sp_UpdateMaintenanceStatus
    @MaintenanceID INT,
    @NewStatus VARCHAR(20),
    @message VARCHAR(200) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validate MaintenanceID
        IF NOT EXISTS (SELECT 1 FROM dbo.Maintenance WHERE MaintenanceID = @MaintenanceID)
        BEGIN
            SET @message = 'Invalid MaintenanceID: ' + CAST(@MaintenanceID AS VARCHAR);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validate NewStatus
        IF @NewStatus NOT IN ('Pending', 'In Progress', 'Completed')
        BEGIN
            SET @message = 'Invalid MaintenanceStatus. Allowed values are: Pending, In Progress, Completed.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Update MaintenanceStatus
        UPDATE dbo.Maintenance
        SET MaintenanceStatus = @NewStatus
        WHERE MaintenanceID = @MaintenanceID;

        SET @message = 'Maintenance status updated successfully for MaintenanceID: ' + CAST(@MaintenanceID AS VARCHAR);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        SET @message = 'Error updating maintenance status: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Declare the output variable before testing
DECLARE @message VARCHAR(200);
-- Test sp_UpdateMaintenanceStatus
EXEC sp_UpdateMaintenanceStatus
    @MaintenanceID = 1230001,
    @NewStatus = 'Completed',
    @message = @message OUTPUT;
PRINT @message;

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS sp_GetAirportNameByID;
GO

CREATE PROCEDURE sp_GetAirportNameByID
    @AirportID INT
AS
BEGIN
    SELECT AirportName
    FROM Airport
    WHERE AirportID = @AirportID;
END;
