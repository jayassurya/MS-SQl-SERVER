-- DAY 8 - SET 2: RANKING AND RUNNING REVENUE REPORT
-- Run booking_transaction.sql first.

USE Hexaware_Day8_Airline;
GO

-- Add extra completed bookings to create fare ties for demonstration.
-- Seat 101 is already booked by Task 1.
INSERT dbo.Bookings(FlightID, SeatID, PassengerID, Fare)
SELECT 1, 102, 2, 5500
WHERE NOT EXISTS (SELECT 1 FROM dbo.Bookings WHERE SeatID=102);

INSERT dbo.Bookings(FlightID, SeatID, PassengerID, Fare)
SELECT 1, 103, 3, 6200
WHERE NOT EXISTS (SELECT 1 FROM dbo.Bookings WHERE SeatID=103);

INSERT dbo.Bookings(FlightID, SeatID, PassengerID, Fare)
SELECT 2, 201, 4, 7000
WHERE NOT EXISTS (SELECT 1 FROM dbo.Bookings WHERE SeatID=201);

-- Mark sample seats booked.
UPDATE s SET SeatStatus='Booked'
FROM dbo.Seats s
JOIN dbo.Bookings b ON b.SeatID=s.SeatID;

-- RANK and DENSE_RANK: tied fares share rank; RANK leaves gaps, DENSE_RANK does not.
;WITH FareRanks AS
(
    SELECT f.FlightNumber, p.PassengerName, b.Fare, b.BookingDate,
           RANK() OVER(PARTITION BY b.FlightID ORDER BY b.Fare DESC) AS FareRank,
           DENSE_RANK() OVER(PARTITION BY b.FlightID ORDER BY b.Fare DESC) AS DenseFareRank,
           SUM(b.Fare) OVER
             (PARTITION BY b.FlightID ORDER BY b.BookingDate, b.BookingID
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningFlightRevenue
    FROM dbo.Bookings b
    JOIN dbo.Flights f ON f.FlightID=b.FlightID
    JOIN dbo.Passengers p ON p.PassengerID=b.PassengerID
)
SELECT FlightNumber, PassengerName, Fare, FareRank, DenseFareRank, RunningFlightRevenue
FROM FareRanks
ORDER BY FlightNumber, Fare DESC, PassengerName;
GO
