-- -- Drop the trigger if it already exists
-- DROP TRIGGER IF EXISTS trg_UpdateCheckInStatus;
-- GO

-- -- Create a trigger for updating CheckInStatus
-- CREATE TRIGGER trg_UpdateCheckInStatus
-- ON dbo.BoardingPass
-- AFTER INSERT, DELETE
-- AS
-- BEGIN
--     -- Update CheckInStatus to 1 if a boarding pass is issued
--     UPDATE p
--     SET p.CheckInStatus = 1
--     FROM dbo.Passenger p
--     WHERE EXISTS (SELECT 1 FROM dbo.BoardingPass bp WHERE bp.PassengerID = p.PassengerID);

--     -- Update CheckInStatus to 0 if no boarding pass exists
--     UPDATE p
--     SET p.CheckInStatus = 0
--     FROM dbo.Passenger p
--     WHERE NOT EXISTS (SELECT 1 FROM dbo.BoardingPass bp WHERE bp.PassengerID = p.PassengerID);
-- END;
-- GO
DROP TRIGGER IF EXISTS trg_AutoUpdateFlightStatus;
GO

CREATE TRIGGER trg_AutoUpdateFlightStatus
ON Flight
AFTER INSERT, UPDATE
AS
BEGIN
    BEGIN TRY
        UPDATE Flight
        SET FlightStatus = 
            CASE 
                WHEN ActualDepartureTime IS NOT NULL AND ActualArrivalTime IS NULL THEN 'In Air'
                WHEN ActualArrivalTime IS NOT NULL THEN 'Arrived'
                ELSE 'Scheduled'
            END
        WHERE FlightID IN (SELECT FlightID FROM inserted);
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_AutoUpdateFlightStatus: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO

DROP TRIGGER IF EXISTS trg_UpdateLoyaltyPoints;
GO

CREATE TRIGGER trg_UpdateLoyaltyPoints
ON dbo.FlightBooking
AFTER INSERT
AS
BEGIN
    BEGIN TRY
        UPDATE dbo.LoyaltyProgram
        SET LoyaltyPoints = LoyaltyPoints + (SELECT TicketPrice / 10 FROM inserted)
        WHERE PassengerID IN (SELECT PassengerID FROM inserted);
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_UpdateLoyaltyPoints: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO


DROP TRIGGER IF EXISTS trg_CheckMaintenanceStatus;
GO

CREATE TRIGGER trg_CheckMaintenanceStatus
ON dbo.Aircraft
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM dbo.Maintenance WHERE MaintenanceStatus = 'Pending')
        BEGIN
            RAISERROR ('Pending maintenance found, cannot update AircraftStatus.', 16, 1);
            ROLLBACK TRANSACTION;
        END;
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_CheckMaintenanceStatus: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO

DROP TABLE IF EXISTS dbo.LuggageLog;
GO

CREATE TABLE dbo.LuggageLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    LuggageID INT NOT NULL,
    IncidentType VARCHAR(50) NOT NULL,
    LogTimestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (LuggageID) REFERENCES Luggage(LuggageID) ON DELETE CASCADE
);
GO


DROP TRIGGER IF EXISTS trg_LogBaggageIssue;
GO

CREATE TRIGGER trg_LogBaggageIssue
ON dbo.Luggage
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        INSERT INTO dbo.LuggageLog (LuggageID, IncidentType, LogTimestamp)
        SELECT LuggageID, [Status], GETDATE()
        FROM inserted
        WHERE [Status] IN ('Lost', 'Damaged');
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_LogBaggageIssue: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO


DROP TRIGGER IF EXISTS trg_ValidateParkingStatus;
GO

CREATE TRIGGER trg_ValidateParkingStatus
ON dbo.ParkingSlots
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM inserted WHERE AvailabilityStatus = 'Available' AND SlotNumber IN (SELECT SlotNumber FROM dbo.Parking WHERE CheckOutTime IS NULL))
        BEGIN
            RAISERROR ('Cannot mark slot as Available while it is occupied.', 16, 1);
            ROLLBACK TRANSACTION;
        END
        ELSE
        BEGIN
            -- Proceed with the insert or update operation
            IF EXISTS (SELECT * FROM inserted)
            BEGIN
                INSERT INTO dbo.ParkingSlots (SlotNumber, AirportID, AvailabilityStatus)
                SELECT SlotNumber, AirportID, AvailabilityStatus
                FROM inserted;
            END
        END
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_ValidateParkingStatus: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO

IF OBJECT_ID('dbo.ShiftLog', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.ShiftLog;
END;
GO

CREATE TABLE dbo.ShiftLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    ShiftStart DATETIME,
    ShiftEnd DATETIME,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
GO


DROP TRIGGER IF EXISTS trg_TrackEmployeeShift;
GO

CREATE TRIGGER trg_TrackEmployeeShift
ON SecurityStaff
AFTER INSERT, UPDATE
AS
BEGIN
    BEGIN TRY
        INSERT INTO ShiftLog (EmployeeID, ShiftStart, ShiftEnd)
        SELECT EmployeeID, ShiftStart, ShiftEnd
        FROM inserted;
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_TrackEmployeeShift: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO


DROP TRIGGER IF EXISTS trg_AutoAssignGate;
GO

CREATE TRIGGER trg_AutoAssignGate
ON Flight
AFTER INSERT
AS
BEGIN
    BEGIN TRY
        DECLARE @FlightID INT, @GateID INT;

        SELECT @FlightID = FlightID FROM inserted WHERE GateID IS NULL;

        IF @FlightID IS NOT NULL
        BEGIN
            SELECT TOP 1 @GateID = GateID FROM Gate WHERE GateStatus = 'Available';
            IF @GateID IS NOT NULL
            BEGIN
                UPDATE Flight SET GateID = @GateID WHERE FlightID = @FlightID;
                UPDATE Gate SET GateStatus = 'Occupied' WHERE GateID = @GateID;
            END;
        END;
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_AutoAssignGate: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO


DROP TRIGGER IF EXISTS trg_CheckBookingCancellation;
GO

CREATE TRIGGER trg_CheckBookingCancellation
ON FlightBooking
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM inserted WHERE BookingStatus = 'Cancelled')
        BEGIN
            -- Assuming Capacity is the column representing available seats (adjust if there's another column for this)
            UPDATE Flight
            SET Capacity = Capacity + 1
            WHERE FlightID IN (SELECT FlightID FROM inserted);
        END;
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_CheckBookingCancellation: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO



DROP TRIGGER IF EXISTS trg_EnsureUniquePhoneNumber;
GO

CREATE TRIGGER trg_EnsureUniquePhoneNumber
ON Phone
INSTEAD OF INSERT
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Phone WHERE PhoneNumber IN (SELECT PhoneNumber FROM inserted))
        BEGIN
            RAISERROR ('Duplicate phone number detected.', 16, 1);
            ROLLBACK TRANSACTION;
        END;
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_EnsureUniquePhoneNumber: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO


DROP TRIGGER IF EXISTS trg_UpdateEquipmentStatus;
GO

CREATE TRIGGER trg_UpdateEquipmentStatus
ON GroundSupport
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        -- Update Maintenance table when the equipment status in GroundSupport is 'Out of Service'
        UPDATE m
        SET m.MaintenanceStatus = 'Pending'
        FROM Maintenance m
        JOIN inserted i ON m.EquipmentID = i.EquipmentID
        WHERE i.GSM_Status = 'Out of Service';
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_UpdateEquipmentStatus: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO

DROP TABLE IF EXISTS dbo.MaintenanceLog;
GO

CREATE TABLE MaintenanceLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    AircraftID INT NOT NULL,
    StatusUpdate VARCHAR(50) NOT NULL,
    UpdateTimestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AircraftID) REFERENCES Aircraft(AircraftID) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS trg_AutoUpdateMaintenanceLog;
GO

CREATE TRIGGER trg_AutoUpdateMaintenanceLog
ON Maintenance
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        INSERT INTO MaintenanceLog (AircraftID, StatusUpdate, UpdateTimestamp)
        SELECT AircraftID, MaintenanceStatus, GETDATE()
        FROM inserted
        WHERE MaintenanceStatus IN ('Under Maintenance', 'Completed');
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_AutoUpdateMaintenanceLog: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO

DROP TABLE IF EXISTS dbo.GateLog;
GO

CREATE TABLE dbo.GateLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    FlightID INT NOT NULL,
    GateID INT NOT NULL,
    AssignmentTimestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID) ON DELETE CASCADE,
    FOREIGN KEY (GateID) REFERENCES Gate(GateID) ON DELETE NO ACTION
);
GO

DROP TRIGGER IF EXISTS trg_LogGateAssignment;
GO

CREATE TRIGGER trg_LogGateAssignment
ON Flight
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM inserted WHERE GateID IS NOT NULL)
        BEGIN
            INSERT INTO GateLog (FlightID, GateID, AssignmentTimestamp)
            SELECT FlightID, GateID, GETDATE()
            FROM inserted
            WHERE GateID IS NOT NULL;
        END;
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_LogGateAssignment: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO

DROP TRIGGER IF EXISTS trg_PreventDuplicateLuggageTag;
GO
DROP TRIGGER IF EXISTS trg_PreventDuplicateLuggageEntry;
GO

CREATE TRIGGER trg_PreventDuplicateLuggageEntry
ON dbo.Luggage
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Prevent duplicate luggage entries based on TicketID and PassengerID
        IF EXISTS (
            SELECT 1
            FROM dbo.Luggage l
            JOIN inserted i ON l.TicketID = i.TicketID AND l.PassengerID = i.PassengerID
        )
        BEGIN
            RAISERROR ('Duplicate luggage entry detected for the same TicketID and PassengerID.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Proceed with the insert or update if no duplicates are found
        IF NOT EXISTS (SELECT 1 FROM deleted)
        BEGIN
            -- Insert new record
            INSERT INTO dbo.Luggage (AirportID, TicketID, PassengerID, NumberOfBags, [Weight], [Status], BaggageLocation)
            SELECT AirportID, TicketID, PassengerID, NumberOfBags, [Weight], [Status], BaggageLocation
            FROM inserted;
        END
        ELSE
        BEGIN
            -- Update existing record
            UPDATE l
            SET l.AirportID = i.AirportID,
                l.NumberOfBags = i.NumberOfBags,
                l.[Weight] = i.[Weight],
                l.[Status] = i.[Status],
                l.BaggageLocation = i.BaggageLocation
            FROM dbo.Luggage l
            JOIN inserted i ON l.TicketID = i.TicketID AND l.PassengerID = i.PassengerID;
        END;

        COMMIT;
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_PreventDuplicateLuggageEntry: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO


DROP TRIGGER IF EXISTS trg_UpdatePassengerLoyaltyStatus;
GO

CREATE TRIGGER trg_UpdatePassengerLoyaltyStatus
ON dbo.LoyaltyProgram
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Update LoyaltyStatus based on the duration of enrollment
        UPDATE lp
        SET LoyaltyStatus = 
            CASE 
                WHEN DATEDIFF(YEAR, lp.EnrollmentDate, GETDATE()) >= 3 THEN 'Platinum'
                WHEN DATEDIFF(YEAR, lp.EnrollmentDate, GETDATE()) >= 1 THEN 'Gold'
                ELSE 'Silver'
            END
        FROM dbo.LoyaltyProgram lp
        JOIN inserted i ON lp.LoyaltyID = i.LoyaltyID;

        COMMIT;
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_UpdatePassengerLoyaltyStatus: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO

DROP TABLE IF EXISTS dbo.SeatChangeLog;
GO

CREATE TABLE dbo.SeatChangeLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    BoardingPassID INT NOT NULL,
    OldSeatNumber VARCHAR(10),
    NewSeatNumber VARCHAR(10),
    ChangeTimestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BoardingPassID) REFERENCES BoardingPass(BoardingPassID) ON DELETE CASCADE
);
GO



DROP TRIGGER IF EXISTS trg_LogSeatChange;
GO

CREATE TRIGGER trg_LogSeatChange
ON BoardingPass
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM inserted WHERE SeatNumber <> (SELECT SeatNumber FROM deleted))
        BEGIN
            INSERT INTO SeatChangeLog (BoardingPassID, OldSeatNumber, NewSeatNumber, ChangeTimestamp)
            SELECT i.BoardingPassID, d.SeatNumber, i.SeatNumber, GETDATE()
            FROM inserted i
            JOIN deleted d ON i.BoardingPassID = d.BoardingPassID;
        END;
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_LogSeatChange: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH;
END;
GO


-- Run this during the live  demo:

-- Trigger for phoneupdate log summary for a given passenger
CREATE TABLE PhoneUpdateLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    PassengerID INT NOT NULL,
    OldPhoneNumber VARCHAR(20),
    NewPhoneNumber VARCHAR(20),
    UpdateDateTime DATETIME DEFAULT GETDATE(),
    PhoneType VARCHAR(20)
);

DROP TRIGGER IF EXISTS trg_OnPhoneNumberUpdate;
GO

CREATE TRIGGER trg_OnPhoneNumberUpdate
ON Phone
FOR UPDATE
AS
BEGIN
    BEGIN TRY
        -- Check if PhoneNumber or PhoneType is being updated
        IF UPDATE(PhoneNumber) OR UPDATE(PhoneType)
        BEGIN
            -- Validate that the new combination of PhoneNumber and PhoneType does not already exist
            IF EXISTS (
                SELECT 1
                FROM Phone p
                JOIN inserted i
                    ON p.PhoneNumber = i.PhoneNumber
                    AND p.PhoneType = i.PhoneType
                    AND p.PassengerID <> i.PassengerID -- Exclude updates for the same passenger
            )
            BEGIN
                RAISERROR ('Duplicate phone number and type combination detected.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END;

            -- Log the update for auditing
            INSERT INTO PhoneUpdateLog (PassengerID, OldPhoneNumber, NewPhoneNumber, UpdateDateTime, PhoneType)
            SELECT d.PassengerID,
                   d.PhoneNumber AS OldPhoneNumber,
                   i.PhoneNumber AS NewPhoneNumber,
                   GETDATE(),
                   i.PhoneType
            FROM inserted i
            JOIN deleted d 
                ON i.PassengerID = d.PassengerID 
               AND i.PhoneType = d.PhoneType;
        END;
    END TRY
    BEGIN CATCH
        PRINT 'Error in trg_OnPhoneNumberUpdate: ' + ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO


-- Update the phone number for a specific PassengerID in the Phone table
UPDATE Phone
SET PhoneNumber = '1111111111'
WHERE PassengerID = 3130 AND PhoneType = 'Mobile';

Delete FROM Phone WHERE PhoneSNo = 105;
SELECT * from Phone where PassengerID = 3130;

SELECT * from PhoneUpdateLog;

-- DROP TABLE PhoneUpdateLog;

-- -- Step 1: Add Temporary Columns
-- ALTER TABLE PhoneUpdateLog ADD Temp_OldPhoneNumber VARBINARY(MAX);
-- ALTER TABLE PhoneUpdateLog ADD Temp_NewPhoneNumber VARBINARY(MAX);

-- -- Step 2: Convert Existing Data and Populate Temporary Columns
-- UPDATE PhoneUpdateLog
-- SET Temp_OldPhoneNumber = CONVERT(VARBINARY(MAX), OldPhoneNumber),
--     Temp_NewPhoneNumber = CONVERT(VARBINARY(MAX), NewPhoneNumber);

-- -- Step 3: Drop Original Columns
-- ALTER TABLE PhoneUpdateLog DROP COLUMN OldPhoneNumber;
-- ALTER TABLE PhoneUpdateLog DROP COLUMN NewPhoneNumber;

-- EXEC sp_rename 'PhoneUpdateLog.Temp_OldPhoneNumber', 'OldPhoneNumber', 'COLUMN';
-- EXEC sp_rename 'PhoneUpdateLog.Temp_NewPhoneNumber', 'NewPhoneNumber', 'COLUMN';

-- -- Optional: Verify the Changes
-- SELECT * FROM PhoneUpdateLog;

