-- Step 1: Close All Open Symmetric Keys
IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'PII_SymmetricKey')
    CLOSE SYMMETRIC KEY PII_SymmetricKey;

IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'Financial_SymmetricKey')
    CLOSE SYMMETRIC KEY Financial_SymmetricKey;

IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'Operational_SymmetricKey')
    CLOSE SYMMETRIC KEY Operational_SymmetricKey;

IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'Security_SymmetricKey')
    CLOSE SYMMETRIC KEY Security_SymmetricKey;

IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'TimeSensitive_SymmetricKey')
    CLOSE SYMMETRIC KEY TimeSensitive_SymmetricKey;

PRINT 'All symmetric keys closed successfully.';
GO

-- Step 2: Drop Existing Symmetric Keys
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'PII_SymmetricKey')
    DROP SYMMETRIC KEY PII_SymmetricKey;

IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'Financial_SymmetricKey')
    DROP SYMMETRIC KEY Financial_SymmetricKey;

IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'Operational_SymmetricKey')
    DROP SYMMETRIC KEY Operational_SymmetricKey;

IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'Security_SymmetricKey')
    DROP SYMMETRIC KEY Security_SymmetricKey;

IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'TimeSensitive_SymmetricKey')
    DROP SYMMETRIC KEY TimeSensitive_SymmetricKey;

PRINT 'All symmetric keys dropped successfully.';
GO

-- Step 3: Drop Existing Certificates
IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'PII_Certificate')
    DROP CERTIFICATE PII_Certificate;

IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'Financial_Certificate')
    DROP CERTIFICATE Financial_Certificate;

IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'Operational_Certificate')
    DROP CERTIFICATE Operational_Certificate;

IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'Security_Certificate')
    DROP CERTIFICATE Security_Certificate;

IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'TimeSensitive_Certificate')
    DROP CERTIFICATE TimeSensitive_Certificate;

PRINT 'All certificates dropped successfully.';
GO

-- Step 4: Drop the Master Key (If Needed)
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
    DROP MASTER KEY;

PRINT 'Master key dropped successfully.';
GO

-- Create Master Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AirportMan@gementSystem!Fall2024';
GO

-- Create Certificates
CREATE CERTIFICATE PII_Certificate WITH SUBJECT = 'PII Data Encryption';
CREATE CERTIFICATE Financial_Certificate WITH SUBJECT = 'Financial Data Encryption';
CREATE CERTIFICATE Operational_Certificate WITH SUBJECT = 'Operational Data Encryption';
CREATE CERTIFICATE Security_Certificate WITH SUBJECT = 'Security Data Encryption';
CREATE CERTIFICATE TimeSensitive_Certificate WITH SUBJECT = 'Time-Sensitive Data Encryption';
GO

-- Create Symmetric Keys
CREATE SYMMETRIC KEY PII_SymmetricKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE PII_Certificate;

CREATE SYMMETRIC KEY Financial_SymmetricKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE Financial_Certificate;

CREATE SYMMETRIC KEY Operational_SymmetricKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE Operational_Certificate;

CREATE SYMMETRIC KEY Security_SymmetricKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE Security_Certificate;

CREATE SYMMETRIC KEY TimeSensitive_SymmetricKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE TimeSensitive_Certificate;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    -- -- Drop Existing Constraints
    -- IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CHK_PhoneNumberLength')
    -- BEGIN
    --     ALTER TABLE Phone DROP CONSTRAINT CHK_PhoneNumberLength;
    --     PRINT 'Constraint CHK_PhoneNumberLength dropped successfully.';
    -- END

    -- Alter Column Data Types for Encryption (VARCHAR(MAX))

    -- ALTER TABLE Phone
    -- ALTER COLUMN PhoneNumber VARBINARY(MAX);

    ALTER TABLE AirplaneStaff
    ALTER COLUMN LicenseNumber VARCHAR(MAX);

    PRINT 'Column data types altered successfully.';

    COMMIT TRANSACTION;
    PRINT 'Transaction committed successfully.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error occurred. Rolling back changes.';
    PRINT ERROR_MESSAGE();
    PRINT ERROR_LINE();
END CATCH;
GO

BEGIN TRY
    BEGIN TRANSACTION;
    -- Step 1: Open the PII Symmetric Key
    OPEN SYMMETRIC KEY PII_SymmetricKey
    DECRYPTION BY CERTIFICATE PII_Certificate;
    PRINT 'Symmetric key opened successfully.';
    -- -- Encrypt Phone.PhoneNumber
    -- UPDATE Phone
    -- SET PhoneNumber = ENCRYPTBYKEY(KEY_GUID('PII_SymmetricKey'), CONVERT(VARCHAR(MAX), PhoneNumber))
    -- WHERE PhoneNumber IS NOT NULL;
    -- WAITFOR DELAY '00:00:05';
    -- Encrypt AirplaneStaff.MedicalClearance (Assuming it's a date converted to VARCHAR)
    UPDATE AirplaneStaff
    SET LicenseNumber = ENCRYPTBYKEY(KEY_GUID('PII_SymmetricKey'), CONVERT(VARCHAR(50), LicenseNumber, 120))
    WHERE LicenseNumber IS NOT NULL;
    WAITFOR DELAY '00:00:05';

    PRINT 'Encryption completed successfully.';

    -- Step 3: Close the Symmetric Key
    CLOSE SYMMETRIC KEY PII_SymmetricKey;
    PRINT 'Symmetric key closed successfully.';

    -- Step 4: Commit the Transaction
    COMMIT TRANSACTION;
    PRINT 'Transaction committed successfully.';
END TRY
BEGIN CATCH
    -- Error Handling
    PRINT 'Error occurred during encryption. Rolling back changes.';

    -- Ensure the Symmetric Key is Closed in Case of Error
    IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'PII_SymmetricKey')
    BEGIN
        CLOSE SYMMETRIC KEY PII_SymmetricKey;
        PRINT 'Symmetric key closed due to error.';
    END

    -- Rollback the Transaction
    ROLLBACK TRANSACTION;

    -- Output Error Details
    PRINT ERROR_MESSAGE();
    PRINT ERROR_LINE();
END CATCH;
GO



-- BEGIN TRY
--     BEGIN TRANSACTION;

--     -- Step 1: Open the PII Symmetric Key (Ensure it's open for decryption check)
--     OPEN SYMMETRIC KEY PII_SymmetricKey
--     DECRYPTION BY CERTIFICATE PII_Certificate;

--     PRINT 'Symmetric key opened successfully.';

--     -- -- Step 2: Re-add Phone Number Length Constraint
--     -- ALTER TABLE Phone
--     -- ADD CONSTRAINT CHK_PhoneNumberLength CHECK (
--     --     LEN(CONVERT(VARCHAR(15), DECRYPTBYKEY(PhoneNumber))) <= 15
--     -- );

--     PRINT 'Constraint CHK_PhoneNumberLength re-added successfully.';

--     -- Step 3: Close the Symmetric Key
--     CLOSE SYMMETRIC KEY PII_SymmetricKey;
--     PRINT 'Symmetric key closed successfully.';

--     -- Step 4: Commit the Transaction
--     COMMIT TRANSACTION;
--     PRINT 'Transaction committed successfully.';
-- END TRY
-- BEGIN CATCH
--     -- Step 5: Error Handling
--     PRINT 'Error occurred during constraint addition. Rolling back changes.';

--     -- Ensure the Symmetric Key is Closed in Case of Error
--     IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'PII_SymmetricKey')
--     BEGIN
--         CLOSE SYMMETRIC KEY PII_SymmetricKey;
--         PRINT 'Symmetric key closed due to error.';
--     END

--     -- Rollback the Transaction
--     ROLLBACK TRANSACTION;

--     -- Output Error Details
--     PRINT ERROR_MESSAGE();
--     PRINT ERROR_LINE();
-- END CATCH;
-- GO

-- Step 1: Open the Symmetric Key
OPEN SYMMETRIC KEY PII_SymmetricKey
DECRYPTION BY CERTIFICATE PII_Certificate;
PRINT 'Symmetric key opened successfully.';

-- Step 2: Decrypt and View Data Using SELECT Queries

-- -- Decrypt Phone Data
-- SELECT
--     PhoneSNo,
--     TRY_CAST(DECRYPTBYKEY(PhoneNumber) AS VARCHAR(15)) AS DecryptedPhoneNumber
-- FROM Phone;

-- Decrypt AirplaneStaff Data
SELECT
    EmployeeID,
    TRY_CAST(DECRYPTBYKEY(LicenseNumber) AS VARCHAR(50)) AS LicenseNumber
FROM AirplaneStaff;

-- Step 3: Close the Symmetric Key
CLOSE SYMMETRIC KEY PII_SymmetricKey;
PRINT 'Symmetric key closed successfully.';
GO

SELECT * FROM AirplaneStaff;








