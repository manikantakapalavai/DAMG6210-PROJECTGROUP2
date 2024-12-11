ALTER TABLE Phone
ALTER COLUMN PhoneNumber VARBINARY(MAX);


-- Step 1: Create a Master Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'PhoneEncryptionKey123!';
GO

-- Step 2: Create a Certificate
CREATE CERTIFICATE PhoneCert  
WITH SUBJECT = 'PhoneNumberEncryptionCertificate';  
GO

-- Step 3: Create a Symmetric Key
CREATE SYMMETRIC KEY PhoneSymmetricKey 
WITH ALGORITHM = AES_256  
ENCRYPTION BY CERTIFICATE PhoneCert;  
GO

-- Step 4: Encrypt Phone Numbers
OPEN SYMMETRIC KEY PhoneSymmetricKey  
DECRYPTION BY CERTIFICATE PhoneCert;

-- Encrypt the PhoneNumber column
UPDATE Phone
SET PhoneNumber = EncryptByKey(Key_GUID('PhoneSymmetricKey'), PhoneNumber);

CLOSE SYMMETRIC KEY PhoneSymmetricKey;
GO

SELECT * FROM Phone;

-- Open the Symmetric Key
OPEN SYMMETRIC KEY PhoneSymmetricKey  
DECRYPTION BY CERTIFICATE PhoneCert;

-- Decrypt and display PhoneNumber
SELECT 
    PassengerID,
    CAST(DECRYPTBYKEY(PhoneNumber) AS VARCHAR(50)) AS DecryptedPhoneNumber
FROM 
    Phone;

-- Close the Symmetric Key
CLOSE SYMMETRIC KEY PhoneSymmetricKey;
GO
