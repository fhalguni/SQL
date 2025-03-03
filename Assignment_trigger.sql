create table Customers2(
	customerId int primary key,
	customerName varchar(30),
	email varchar(30),
	PhoneNumber varchar(10)
);



INSERT INTO Customers2 (customerId, customerName, email, PhoneNumber) VALUES
(1, 'John Doe', 'john.doe@example.com', '1234567890'),
(2, 'Jane Smith', 'jane.smith@example.com', '0987654321'),
(3, 'Alice Johnson', 'alice.johnson@example.com', '5555555555');

--------------------------------------------------------------------------------------------------------------------------------------
create table Accounts2(
	AccountId int primary key,
	customerId int,
	AccountNumber varchar(20),
	Balance decimal,
	AccountType varchar(30),
	foreign key (customerId) references Customers2(customerId)
);

INSERT INTO Accounts2 (AccountId, customerId, AccountNumber, Balance, AccountType) VALUES
(1, 1, 'ACC123456', 1000.50, 'Savings'),
(2, 2, 'ACC654321', 2500.75, 'Checking'),
(3, 3, 'ACC987654', 1500.00, 'Savings');
truncate table Accounts2;
select * from Accounts2;
------------------------------------------------------------------------------------------------------------------------------------------
create table Transactions1(
	transactionId int primary key,
	AccountId int,
	transactionType varchar(30),
	Amount decimal,
	transactionDate date,
	foreign key (AccountId) references Accounts2(AccountId)
);

INSERT INTO Transactions1 (transactionId, AccountId, transactionType, Amount, transactionDate) VALUES
(1, 1, 'Deposit', 500.00, '2025-02-01'),
(2, 2, 'Withdrawal', 200.00, '2025-02-05'),
(3, 3, 'Deposit', 300.00, '2025-02-10');

--------------------------------------------------------------------------------------------------------------------------------------------
create table Audit_Transactions1(
	AuditId int primary key,
	AccountId int,
	Amount decimal,
	transactionDate date,
	Action1 varchar(30),
	foreign key (AccountId) references Accounts2(AccountId)
);
select * from Accounts2;
INSERT INTO Audit_Transactions1 (AuditId, AccountId, Amount, transactionDate, Action1) VALUES
(1, 1, 500.00, '2025-02-01', 'Deposit'),
(2, 2, 200.00, '2025-02-05', 'Withdrawal'),
(3, 3, 300.00, '2025-02-10', 'Deposit');


--------------------------------------------------------------------------------------------------------------------------------------------
create clustered index account_index on Accounts2(AccountId);

create nonclustered index customer_index on Customers2(customerName);

create index composite_index on Transactions1(transactionDate,Amount);

create unique index unique_index on Accounts2(AccountNumber);
--------------------------------------------------------------------------------------------------------------------------------------------

create function getCalculateInterest(@AccountId int)
returns decimal(10,2) as
begin
declare @interest decimal(10,2)
select  @interest= (Balance-Balance*0.05) from Accounts2 where AccountId=@AccountId
return @interest
end;

drop function getCalculateInterest;

select dbo.getCalculateInterest(1) as Interest;
------------------------------------------------------------------------------------------------------------------------------------------

drop procedure TransferAmount;
--truncate table trasaction_Detail4;
create table trasaction_Detail4(
	fromAccount int,
	toAccount int,
	amount decimal,
	transactionDate date
);

create Procedure TransferAmount 
	@FromAccountId int,
	@ToAccountId int,
	@Amount decimal
As
Begin
	declare @Balance decimal
	
	select @Balance=Balance from Accounts2 where AccountId=@FromAccountId;
	print @Balance
	print @Amount
	if @Balance is null
	begin
	rollback
	print 'Balance is null'
	return
	end

	if @Balance < @Amount
	begin
	rollback
	print 'Insufficient balance'
	return 
	end

	update Accounts2 set Balance=Balance-@Amount where AccountId = @FromAccountId;

	update Accounts2 set Balance=Balance+@Amount where AccountId = @ToAccountId;

	insert into trasaction_Detail4 values(@FromAccountId,@ToAccountId,@Amount, getdate())

	commit;
	end;

	exec TransferAmount 2,3,500.00;

	select * from trasaction_Detail4;

----------------------------------------------------------------------------------------------------------------------------------------

CREATE TRIGGER prevent_insufficient_withdrawal
ON Accounts2
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Balance < 0)
    BEGIN
        RAISERROR ('Insufficient Balance', 16, 1);
        ROLLBACK TRANSACTION;
    END

END;

update Accounts2 set Balance=balance-10000 where AccountId=3;

---------------------------------------------------------------------------------------------------------------------------------------
--Task 5
CREATE TRIGGER AuditTransactions2 ON Transactions1
AFTER INSERT
AS 
BEGIN
	declare @AuditId int=6, @AccountId int, @Amount decimal,@transactionDate date, @Action1 varchar(30)='Deposite'
	SELECT @AccountId = AccountId, 
           @Amount = Amount, 
           @transactionDate = transactionDate 
    FROM inserted;
    INSERT INTO Audit_Transactions1 (AuditId, AccountId, Amount, transactionDate, Action1)values(@AuditId, @AccountId, @Amount, @transactionDate, @Action1) 
     
END;



INSERT INTO Transactions1 (transactionId, AccountId, transactionType, Amount, transactionDate)
VALUES (6, 1, 'Withdrawal', 500.00, GETDATE());


drop trigger AuditTransactions1;
SELECT * FROM Audit_Transactions1;