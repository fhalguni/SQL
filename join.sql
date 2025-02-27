CREATE TABLE Departments4 (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Employees10 (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    DepartmentID INT,
    HireDate DATE,
    BaseSalary DECIMAL(10,2),
    Bonus DECIMAL(10,2),
    ManagerID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments4(DepartmentID),
    FOREIGN KEY (ManagerID) REFERENCES Employees10(EmployeeID)
);

-- Inserting sample data
INSERT INTO Departments4 (DepartmentID, DepartmentName) VALUES
(1, 'HR'), (2, 'IT'), (3, 'Finance');



select * from Departments4;
INSERT INTO Employees10 (EmployeeID, EmployeeName, DepartmentID, HireDate, BaseSalary, Bonus, ManagerID) VALUES
(1, 'Alice', 1, '2020-01-10', 50000, 5000, NULL),
(2, 'Bob', 2, '2019-03-15', 60000, 6000, 1),
(3, 'Charlie', 2, '2018-06-20', 55000, 5500, 1),
(4, 'David', 3, '2021-07-25', 70000, 7000, 2);

select * from Employees10;

--Find Employees and Their Department Names Using INNER JOIN
SELECT 
    Employees10.EmployeeName, 
    Departments4.DepartmentName, 
    Employees10.HireDate
FROM 
    Employees10
INNER JOIN 
    Departments4 ON Employees10.DepartmentID = Departments4.DepartmentID;

--List Employees Without a Manager (SELF JOIN or LEFT JOIN):

	SELECT 
    e1.EmployeeName
FROM 
    Employees10 e1
LEFT JOIN 
    Employees10 e2 ON e1.ManagerID = e2.EmployeeID
WHERE 
    e1.ManagerID IS NULL;


--Find Departments Without Any Employees (LEFT JOIN)
insert into Employees10 values (5, 'Bob', null, '2019-03-15', 60000, 6000, 1)
SELECT 
    Departments4.DepartmentName
FROM 
    Departments4
LEFT JOIN 
    Employees10 ON Departments4.DepartmentID = Employees10.DepartmentID
WHERE 
    Employees10.EmployeeID IS NULL;


--Get the Total Salary (Base + Bonus) for Each Employee (JOIN Calculation)

SELECT 
    EmployeeName, 
    (BaseSalary + Bonus) AS TotalSalary
FROM 
    Employees10;


--Identify the Employee with the Highest Salary (Subquery)
SELECT 
    EmployeeName
FROM 
    Employees10
WHERE 
    (BaseSalary + Bonus) = (
        SELECT 
            MAX(BaseSalary + Bonus)
        FROM 
            Employees10
    );

--Find Employees Earning More Than Their Manager (SELF JOIN)
SELECT 
    e1.EmployeeName
FROM 
    Employees10 e1
INNER JOIN 
    Employees10 e2 ON e1.ManagerID = e2.EmployeeID
WHERE 
    e1.BaseSalary + e1.Bonus > e2.BaseSalary + e2.Bonus;

--Create a View for HR to See Employee Salary Details
CREATE VIEW SalaryView AS
SELECT 
    e.EmployeeID, 
    e.EmployeeName, 
    d.DepartmentName, 
    e.BaseSalary, 
    e.Bonus, 
    (e.BaseSalary + e.Bonus) AS TotalSalary

from Employees10 e
join Departments4 d on e.DepartmentID=d.DepartmentID

select * from SalaryView;


select * from Employees10 
where DATEDIFF(curdate() , HireDate) >3 *365;


------------------------------------------------------------------------------------------------------------------------------------------------
create function getTotalSalary(@BaseSalary DECIMAL(10,2)) 
returns DECIMAL(10,2) as

begin 
 return @BaseSalary*0.10 ;
end;

select EmployeeID,EmployeeName, dbo.getTotalSalary(BaseSalary) As Bonus from Employees10;

create function getDepartment(@DeptId int)
returns TABLE as
return 

(select EmployeeID,EmployeeName from Employees10 where DepartmentID=@DeptId);
;

select * from dbo.getDepartment(1);
------------------------------------------------------------------------------------------------------------------------------

create procedure addEmployee 
	@EmployeeID INT ,
    @EmployeeName VARCHAR(100),
    @DepartmentID INT,
    @HireDate DATE,
    @BaseSalary DECIMAL(10,2),
    @Bonus DECIMAL(10,2),
    @ManagerID INT
  AS
  begin 
  insert into Employees10 values (@EmployeeID,@EmployeeName,@DepartmentID,@HireDate,@BaseSalary,@Bonus,@ManagerID);
  end;

  exec addEmployee 5, 'Ashu', 3, '2021-07-25', 70000, 7000, 2;
  select * from Employees10;

  create trigger onDelete
  on Employees10
  instead of delete
  as
  begin
  update Employees10
  set HireDate=null, DepartmentID=null
  where EmployeeID in(select EmployeeID from deleted)
  end;

  delete from Employees10 where EmployeeID=1;

  select * from Employees10;