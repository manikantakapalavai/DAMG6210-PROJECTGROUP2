-- Passenger Table: Index on Nationality and Age (Avoid encrypted columns like Nationality if applicable)
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Passenger_Nationality_Age')
    DROP INDEX idx_Passenger_Nationality_Age ON Passenger;
GO

CREATE NONCLUSTERED INDEX idx_Passenger_Nationality_Age
ON Passenger (Age);
GO

-- FlightBooking Table: Index on FlightID and BookingStatus
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_FlightBooking_FlightID_BookingStatus')
    DROP INDEX idx_FlightBooking_FlightID_BookingStatus ON FlightBooking;
GO

CREATE NONCLUSTERED INDEX idx_FlightBooking_FlightID_BookingStatus
ON FlightBooking (FlightID, BookingStatus);
GO

-- Flight Table: Index on DepartureTime and ArrivalTime
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Flight_DepartureTime_ArrivalTime')
    DROP INDEX idx_Flight_DepartureTime_ArrivalTime ON Flight;
GO

CREATE NONCLUSTERED INDEX idx_Flight_DepartureTime_ArrivalTime
ON Flight (DepartureTime, ArrivalTime);
GO

-- Employee Table: Index on Employee_Type and Salary
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Employee_Type_Salary')
    DROP INDEX idx_Employee_Type_Salary ON Employee;
GO

CREATE NONCLUSTERED INDEX idx_Employee_Type_Salary
ON Employee (Employee_Type, Salary);
GO

-- Luggage Table: Index on TicketID and Status
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Luggage_TicketID_Status')
    DROP INDEX idx_Luggage_TicketID_Status ON Luggage;
GO

CREATE NONCLUSTERED INDEX idx_Luggage_TicketID_Status
ON Luggage (TicketID, Status);
GO

-- Gate Table: Index on Terminal and GateStatus
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Gate_Terminal_GateStatus')
    DROP INDEX idx_Gate_Terminal_GateStatus ON Gate;
GO

CREATE NONCLUSTERED INDEX idx_Gate_Terminal_GateStatus
ON Gate (Terminal, GateStatus);
GO

-- Aircraft Table: Index on AircraftType and AircraftAge
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Aircraft_AircraftType_AircraftAge')
    DROP INDEX idx_Aircraft_AircraftType_AircraftAge ON Aircraft;
GO

CREATE NONCLUSTERED INDEX idx_Aircraft_AircraftType_AircraftAge
ON Aircraft (AircraftType, AircraftAge);
GO

-- Maintenance Table: Index on MaintenanceStatus and AircraftID
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Maintenance_Status_AircraftID')
    DROP INDEX idx_Maintenance_Status_AircraftID ON Maintenance;
GO

CREATE NONCLUSTERED INDEX idx_Maintenance_Status_AircraftID
ON Maintenance (MaintenanceStatus, AircraftID);
GO

-- GroundSupport Table: Index on GSM_Status and EquipmentType
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_GroundSupport_GSM_Status_EquipmentType')
    DROP INDEX idx_GroundSupport_GSM_Status_EquipmentType ON GroundSupport;
GO

CREATE NONCLUSTERED INDEX idx_GroundSupport_GSM_Status_EquipmentType
ON GroundSupport (GSM_Status, EquipmentType);
GO

-- Airline Table: Index on AirlineName
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Airline_AirlineName')
    DROP INDEX idx_Airline_AirlineName ON Airline;
GO

CREATE NONCLUSTERED INDEX idx_Airline_AirlineName
ON Airline (AirlineName);
GO

-- Flight Table: Index on GateID
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_Flight_GateID')
    DROP INDEX idx_Flight_GateID ON Flight;
GO

CREATE NONCLUSTERED INDEX idx_Flight_GateID 
ON dbo.Flight (GateID);


SELECT
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    c.name AS ColumnName,
    i.is_unique AS IsUnique,
    i.is_primary_key AS IsPrimaryKey,
    i.is_disabled AS IsDisabled
FROM
    sys.indexes i
JOIN
    sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN
    sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
JOIN
    sys.tables t ON i.object_id = t.object_id
WHERE
    i.type_desc = 'NONCLUSTERED'
ORDER BY
    t.name, i.name, ic.key_ordinal;
