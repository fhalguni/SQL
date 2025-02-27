create table Customers7(
	customerId int primary key identity,
	CustomerName varchar(30),
	email varchar(30),
	phone varchar(10),
	cusAddress varchar(30)
);

INSERT INTO Customers7 (CustomerName, email, phone, cusAddress) VALUES 
('Ravi Kumar', 'ravi@example.com', '9876543210', '123 MG Road, Bengaluru'),
('Priya Sharma', 'priya@example.com', '8765432109', '456 Nehru Place, New Delhi'),
('Amit Patel', 'amit@example.com', '7654321098', '789 SV Road, Mumbai'),
('Sneha Desai', 'sneha@example.com', '6543210987', '101 Park Street, Kolkata'),
('Vikram Singh', 'vikram@example.com', '5432109876', '202 Residency Road, Chennai');

INSERT INTO Customers7 (CustomerName, email, phone, cusAddress) VALUES ('Ashwini Patil', 'ashwnipatil@example.com', '1236598754', '202 Residency Road, kolhapur');
------------------------------------------------------------------------------------------------------------------------------

create table Rooms(
	RoomId int primary key identity,
	RoomType varchar(30) check(RoomType in ('AC','Non-AC')),
	pricePerNight decimal,
	RoomStatus varchar(30) check(RoomStatus in('Booked','Available'))
);

INSERT INTO Rooms (RoomType, pricePerNight, RoomStatus) VALUES 
('AC', 5000.00, 'Available'),
('Non-AC', 3000.00, 'Booked'),
('AC', 4500.00, 'Available'),
('Non-AC', 2500.00, 'Available'),
('AC', 4000.00, 'Booked');
--------------------------------------------------------------------------------------------------------------------------

create table Bookings_5(
	BookingId int primary key identity,
	customerId int,
	RoomId int,
	checkInDate date,
	checkOutDate date,
	totalAmount decimal
	foreign key (customerId) references Customers7(customerId),
	foreign key (RoomId) references Rooms(RoomId)
);

INSERT INTO Bookings_5 (customerId, RoomId, checkInDate, checkOutDate, totalAmount) VALUES 
(1, 1, '2025-03-01', '2025-03-05', 20000.00),
(2, 2, '2025-04-10', '2025-04-12', 6000.00),
(3, 3, '2025-05-15', '2025-05-20', 22500.00),
(4, 4, '2025-06-01', '2025-06-03', 7500.00),
(5, 5, '2025-07-10', '2025-07-15', 20000.00);

INSERT INTO Bookings_5 (customerId, RoomId, checkInDate, checkOutDate, totalAmount) VALUES (4, 4, '2025-07-10', '2025-07-15', 20000.00);
INSERT INTO Bookings_5 (customerId, RoomId, checkInDate, checkOutDate, totalAmount) VALUES (4, 4, '2025-03-10', '2025-03-15', 20000.00);

------------------------------------------------------------------------------------------------------------------------------
create table Payments(
	paymentId int primary key identity,
	BookingId int,
	paymentDate date,
	Amount decimal,
	paymentMethod varchar(20) check(paymentMethod in('cash','online')),
	foreign key (BookingId) references Bookings_5(BookingId),
);

INSERT INTO Payments (BookingId, paymentDate, Amount, paymentMethod) VALUES 
(1, '2025-03-01', 20000.00, 'online'),
(2, '2025-04-10', 6000.00, 'cash'),
(3, '2025-05-15', 22500.00, 'online'),
(4, '2025-06-01', 7500.00, 'cash'),
(5, '2025-07-10', 20000.00, 'online');

-----------------------------------------------------------------------------------------------------------------------------------
create table Employees_table(
	employeeId int primary key identity,
	EmpName varchar(30),
	Position varchar(30) check(Position in('Owner','Manager','Accountant')),
	salary decimal,
	HireDate date,
	ManagerId int,
	foreign key (ManagerId) references Employees_table(employeeId)
);

INSERT INTO Employees_table (EmpName, Position, salary, HireDate, ManagerId) VALUES 
('Rohit Verma', 'Manager', 80000.00, '2025-01-01', NULL),
('Kavita Mehta', 'Accountant', 60000.00, '2025-02-15', 1),
('Neha Gupta', 'Manager', 85000.00, '2025-03-10', NULL),
('Arjun Jain', 'Accountant', 65000.00, '2025-04-05', 1),
('Divya Nair', 'Manager', 90000.00, '2025-05-01', NULL);
-----------------------------------------------------------------------------------------------------------------------

create table Services_tbl(
	serviceId int primary key identity,
	serviceName varchar(30),
	price decimal
);

INSERT INTO Services_tbl (serviceName, price) VALUES 
('Room Service', 800.00),
('Laundry', 500.00),
('Spa', 2500.00),
('Gym Access', 1000.00),
('Airport Shuttle', 1200.00);

------------------------------------------------------------------------------------------------------------------------

create table HotelBranch(
	branchId int primary key identity,
	branchName varchar(30),
	hotelLocation varchar(30)
);

INSERT INTO HotelBranch (branchName, hotelLocation) VALUES 
('Bengaluru Residency', 'Bengaluru'),
('Delhi Heights', 'New Delhi'),
('Mumbai Retreat', 'Mumbai'),
('Kolkata Plaza', 'Kolkata'),
('Chennai Comfort', 'Chennai');

-----------------------------------------------------------------------------------------------------------------------------------
create table Booking_services(
 bookingServicesID int primary key identity,
 serviceId int,
 BookingId int,
 bookingAmount decimal,
 foreign key (serviceId) references Services_tbl(serviceId),
 foreign key (BookingId) references Bookings_5(BookingId),

);

INSERT INTO Booking_services (serviceId, BookingId, bookingAmount) VALUES 
(1, 1, 800.00),
(2, 2, 500.00),
(3, 3, 2500.00),
(4, 4, 1000.00),
(5, 5, 1200.00);

------------------------------------------------------------------------------------------------------------------------

--Retrieve customers booking details name, roomtype, check-in date, total amount by using join
select 
    c.CustomerName, 
    r.RoomType, 
    b.checkInDate, 
    b.totalAmount
from 
    Bookings_5 b
join 
    Customers7 c on b.customerId = c.customerId
join 
    Rooms r on b.RoomId = r.RoomId;

-------------------------------------------------------------------------------------------------------------------------
--get a list of employees along with their managers
UPDATE Employees_table SET ManagerId = 1 WHERE employeeId = 2;
UPDATE Employees_table SET ManagerId = 1 WHERE employeeId = 3;
UPDATE Employees_table SET ManagerId = 3 WHERE employeeId =4;

select e1.EmpName as Employee, e2.EmpName as Manager
from Employees_table e1
left join  
Employees_table e2 on  e1.ManagerId=e2.employeeId;

SELECT * FROM Employees_table;

----------------------------------------------------------------------------------------------------------------------------------
--find rooms that have never been booked

INSERT INTO Rooms (RoomType, pricePerNight, RoomStatus) VALUES 

('Non-AC', 6500.00, 'Available');


select r.RoomId, r.RoomType
from Rooms r
left join Bookings_5 b on r.RoomId=b.RoomID
where b.RoomId is null

----------------------------------------------------------------------------------------------------------------------------------

--Identify customers who made multiple bookings.
select c.CustomerName
from Customers7 c
where c.customerId in (
        select b.customerId
        from Bookings_5 b
        group by b.customerId
        having COUNT(b.BookingId) > 1
    );
---------------------------------------------------------------------------------------------------------------------------------

--find the most expensive room booked
select RoomId,totalAmount
from Bookings_5 
where totalAmount in (select Max(totalAmount) from Bookings_5 )

----------------------------------------------------------------------------------------------------------------------------------
--create a view

create view ActiveBookings8 as
select  c.CustomerName, r.RoomType, b.checkInDate, b.checkOutDate
from 
    Bookings_5 b
join 
    Customers7 c on b.customerId = c.customerId
join 
    Rooms r on b.RoomId = r.RoomId
where 
    r.RoomStatus = 'Booked';

select * from ActiveBookings8;
------------------------------------------------------------------------------------------------------------------------------------
--create an index on room type in the rooms table to optimize room searches.

set statistics time on;
create index idx_RoomType on Rooms(RoomType);

select * from Rooms where RoomStatus='Available' ;

drop index Rooms.idx_RoomType;
-----------------------------------------------------------------------------------------------------------------------------------
--create a composite index on CheckInDate and CheckOutDate in the bookings table
create index composite_index on Bookings_5(checkInDate,checkOutDate);

-------------------------------------------------------------------------------------------------------------------------------------

--create a stored procedure to get the total revenue

create procedure calculateTotalRevenue @Month int,@Year int
as 
begin
	select sum(totalAmount) as totalRevenue
	from Bookings_5
	where MONTH(checkInDate)=@Month and YEAR(checkOutDate)=@Year
end;

exec calculateTotalRevenue @Month=3, @Year=2025;

-------------------------------------------------------------------------------------------------------------------------------------

--user-defined function to calculate the total number of days a customer stayed
create function totalNumberOfCustomerStay(@checkInDate date, @checkOutDate date) 
returns int as
begin
 return datediff(day,@checkInDate,@checkOutDate);
end;

select dbo.totalNumberOfCustomerStay('2025-03-01', '2025-03-05') as TotalDaysStayed;

------------------------------------------------------------------------------------------------------------------------------------

--Implement a trigger to automatically update the Rooms table status to "Available" when a booking is cancelled
alter table Bookings_5 add  bookingStatus varchar(10) DEFAULT 'Active';
alter table Bookings_5 drop column bookingStatus;
select * from Bookings_5;


CREATE TRIGGER trg_UpdateRoomStatusOnCancel
ON Bookings_5
after update
AS
BEGIN
	if Exists (select 1 from inserted where bookingStatus='Cancelled')
    BEGIN
        UPDATE Rooms
        SET RoomStatus = 'Available'
        FROM Rooms 
		where RoomId in (select RoomId from inserted where bookingStatus='Cancelled' )
        
    END
END;

update Bookings_5 set bookingStatus='Cancelled' where BookingId=3;
update Rooms set RoomStatus='Booked' where RoomId=3;
select * from Rooms;
select * from Bookings_5;
------------------------------------------------------------------------------------------------------------------------------------

alter table Rooms add description varchar(30);

select * from Rooms;
UPDATE Rooms
SET description = 'Spacious luxury room '
WHERE RoomId = 1;

UPDATE Rooms
SET description = 'Comfortable non-AC '
WHERE RoomId = 2;

UPDATE Rooms
SET description = 'Luxury AC room ,city view'
WHERE RoomId = 3;


IF NOT EXISTS (SELECT * FROM sys.fulltext_catalogs WHERE name = 'RoomsCatalog')
BEGIN
    CREATE FULLTEXT CATALOG RoomsCatalog AS DEFAULT;
END



CREATE FULLTEXT INDEX ON Rooms(description) 
    KEY INDEX PK__Rooms__328639393FE71A93 
    
select name from sys.indexes where object_id=OBJECT_ID('Rooms') and is_primary_key=1
SELECT RoomId, RoomType, pricePerNight, RoomStatus, description
FROM Rooms
WHERE CONTAINS(description, 'non-AC');