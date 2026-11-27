-- DAY 8 - SET 2: AIRLINE SEAT BOOKING TRANSACTION
-- Run in SSMS. Setup is repeatable and recreates the assignment database.

USE master;
GO
IF DB_ID(N'Hexaware_Day8_Airline') IS NOT NULL
BEGIN
    ALTER DATABASE Hexaware_Day8_Airline SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Hexaware_Day8_Airline;
END;
GO
CREATE DATABASE Hexaware_Day8_Airline;
GO
USE Hexaware_Day8_Airline;
GO

CREATE TABLE dbo.Flights
(
    FlightID INT PRIMARY KEY,
    FlightNumber VARCHAR(10) NOT NULL UNIQUE,
    Origin VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    FlightDate DATE NOT NULL
);
CREATE TABLE dbo.Seats
(
    SeatID INT PRIMARY KEY,
    FlightID INT NOT NULL REFERENCES dbo.Flights(FlightID),
    SeatNumber VARCHAR(5) NOT NULL,
    SeatStatus VARCHAR(12) NOT NULL CHECK (SeatStatus IN ('Available','Booked')),
    CONSTRAINT UQ_Seats_Flight_Seat UNIQUE(FlightID, SeatNumber)
);
CREATE TABLE dbo.Passengers
(
    PassengerID INT PRIMARY KEY,
    PassengerName NVARCHAR(100) NOT NULL,
    Email VARCHAR(120) NOT NULL UNIQUE
);
CREATE TABLE dbo.Bookings
(
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    FlightID INT NOT NULL REFERENCES dbo.Flights(FlightID),
    SeatID INT NOT NULL REFERENCES dbo.Seats(SeatID),
    PassengerID INT NOT NULL REFERENCES dbo.Passengers(PassengerID),
    Fare DECIMAL(10,2) NOT NULL CHECK (Fare > 0),
    BookingDate DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT UQ_Bookings_Seat UNIQUE(SeatID)
);

INSERT dbo.Flights VALUES
(1,'HX101','Chennai','Bengaluru','2026-12-15'),
(2,'HX202','Chennai','Mumbai','2026-12-16');

INSERT dbo.Seats VALUES
(101,1,'1A','Available'),(102,1,'1B','Available'),
(103,1,'1C','Available'),(104,1,'1D','Available'),
(201,2,'2A','Available'),(202,2,'2B','Available');

INSERT dbo.Passengers VALUES
(1,N'Arun Kumar','arun@example.com'),
(2,N'Priya Sharma','priya@example.com'),
(3,N'Rahul Raj','rahul@example.com'),
(4,N'Divya S','divya@example.com');

-- TASK 1: atomic booking. Change the values below for another test.
DECLARE @FlightID INT=1, @SeatID INT=101, @PassengerID INT=1, @Fare DECIMAL(10,2)=5500;
BEGIN TRY
    BEGIN TRANSACTION;

    -- UPDLOCK + HOLDLOCK serializes attempts to reserve the same seat.
    IF NOT EXISTS
       (SELECT 1 FROM dbo.Seats WITH (UPDLOCK, HOLDLOCK)
        WHERE SeatID=@SeatID AND FlightID=@FlightID AND SeatStatus='Available')
        THROW 51001, 'Seat is unavailable or does not belong to this flight.', 1;

    INSERT dbo.Bookings(FlightID, SeatID, PassengerID, Fare)
    VALUES(@FlightID, @SeatID, @PassengerID, @Fare);

    UPDATE dbo.Seats
    SET SeatStatus='Booked'
    WHERE SeatID=@SeatID AND SeatStatus='Available';

    IF @@ROWCOUNT <> 1 THROW 51002, 'Seat status update failed.', 1;

    COMMIT TRANSACTION;
    PRINT 'Booking completed successfully.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    PRINT CONCAT('Booking failed: ', ERROR_MESSAGE());
END CATCH;
GO

SELECT f.FlightNumber, s.SeatNumber, s.SeatStatus,
       p.PassengerName, b.Fare, b.BookingDate
FROM dbo.Bookings b
JOIN dbo.Flights f ON f.FlightID=b.FlightID
JOIN dbo.Seats s ON s.SeatID=b.SeatID
JOIN dbo.Passengers p ON p.PassengerID=b.PassengerID;
GO
