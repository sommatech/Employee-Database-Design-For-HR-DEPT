--CRUD OPERATIONS
--C; CREATE-CREATE
--R; READ- SELECT
--U; UPDATE- UPDATE
--D; DELETE- DELETE
--CREATE DATABASE<DATABASENAME>
--CREATE TABLE <TABLENAME>(<COLOUMN NAME> <DATA TYPE> CONSTRAINTS, <COLUMN NAME> <DATA TYPE> CONSTRAINTS)
--INSERT INTO <TABLENAME>(<COLUMN1>,<COLUMN2>...OPTIONAL) VALUES(<VALUE1>,<VALUE2>, <VALUE3>)

CREATE DATABASE EmployeeDbForHrDepartt

USE EmployeeDbForHrDepartt

CREATE TABLE TestTabl
(
      [EmpID] NVARCHAR(20) PRIMARY KEY, 
	  [EmpName] NVARCHAR(50), 
	  [Salary] INT,
	  [DepartmentID] INT, 
	  [Stateid] INT
	  );

INSERT INTO TestTabl (EmpID,  EmpName, Salary, DepartmentID, Stateid)
VALUES   
     ('B01', 'Sunil Rana', '10000','3', '102'),
     ('B02', 'Saurav Rawat', '15000','2', '103'), 
     ('B03', 'Vivek Kataria', '19000','4', '104'),
     ('C01', 'ViPUL Gupta', '45000','2', '105'),
     ('C02', 'Geetika Basin', '33000','3', '101'),
     ('C03', 'Satish sharama', '45000','1', '103'),
	 ('C04', 'Sagar kumar', '50000','2', '102'),
     ('C05', 'Amitabh singh', '37000','3', '108');

SELECT * FROM TestTabl




CREATE TABLE De_partment
(
     [DepartmentID] INT,
	  [DepartmentName] NVARCHAR(50)
	  );

INSERT INTO De_partment (DepartmentID, DepartmentName)
VALUES  
	('1', 'IT'),
	('2', 'HR'),
	('3', 'Admin'),
	('4', 'Account');

SELECT * FROM De_partment




CREATE TABLE ProjectManager
(
	 [ProjectManagerID] INT,
	 [ProjectManagerName] NVARCHAR(50),
     [DepartmentID] INT,
	 );

INSERT INTO ProjectManager (ProjectManagerID, ProjectManagerName, DepartmentID)
VALUES  
	('1', 'Monika','1'),
	('2', 'Vivek','1'),
	('3', 'Vipul','2'),
	('4', 'satish','2'),
	('5','Amitabh','3');

SELECT * FROM ProjectManager




CREATE TABLE StateMaster
(
       [Stateid] INT PRIMARY KEY,
	   [StateName] NVARCHAR(50)
	  );

INSERT INTO StateMaster (Stateid, StateName)
VALUES
    ('101', 'Lagos'),
	('102', 'Abuja'),
	('103', 'Kano'),
	('104', 'Delta'),
	('105', 'Ido'),
	('106', 'Ibadan');

SELECT * FROM StateMaster
	

--SECOND ASSIGNMENT

--write a SQL query to fetch the list of employees with same salary
SELECT * FROM [EmployeeDbForHrDepart]..TestTabl
WHERE Salary IN (
SELECT (Salary)
FROM [EmployeeDbForHrDepart]..TestTabl
GROUP BY Salary
HAVING COUNT (Salary)>1
)


--2. write a SQL query to fetch Find the second highest salary and department
 
SELECT T.EmpName,T. Salary, DP. DepartmentName
FROM [EmployeeDbForHrDepart]..De_partment DP 
INNER JOIN [EmployeeDbForHrDepart].. Testtabl T
ON  T. DepartmentID = DP.  DepartmentID 
ORDER BY Salary DESC
OFFSET  1 ROW
FETCH NEXT 1 ROW ONLY



--3. WRITE A QUERY TO GET THE MAXIMUM SALARY FROM EACH DEPARTMEENT, THE NAME OF THE DEPARTMENT AND THEE NAME OF THE EANER 

SELECT T. Salary MAXSalary,DP.DepartmentName, T.EmpName
FROM [EmployeeDbForHrDepart].. Testtabl T
JOIN [EmployeeDbForHrDepart]..De_partment DP
ON  T.DepartmentID = DP.DepartmentID
JOIN (SELECT DepartmentID, MAX (Salary) AS MAXSalary
FROM [EmployeeDbForHrDepart]..TestTabl T
GROUP BY DepartmentID) M ON T.DepartmentID=M.DepartmentID
AND T.Salary=M.MAXSalary

 SELECT*FROM Testtabl 
  SELECT*FROM De_partment
  SELECT*FROM StateMaster

 --4. WRITE A SQL QUERY TO FETCH PROJECT MANAGER-WISE COUNT OF EMPLOYEE SORTED BY PROJECTMANAGER'S COUNT IN DESCENDING ORDER

 SELECT COUNT(DISTINCT T.EmpName,P.ProjectManagerName,DepartmentID,EmpID
 FROM [EmployeeDbForHrDepart].. Testtabl T,[EmployeeDbForHrDepart]..ProjectManager P
 WHERE T. DepartmentID = P.DepartmentID 
 SELECT DepartmentID,ProjectManagerName,ProjectManagerID 
 FROM [EmployeeDbForHrDepart]..ProjectManager
 GROUP BY ProjectManagerID 
 ORDER BY COUNT(*) DESC
 
 --5.query to fetch only the first name from the empname column of employee table and after add salary.
SELECT CONCAT(LEFT(EmpName,
        CHARINDEX (' ', EmpName)-1), '_',Salary) FirstName_Salary
FROM Testtabl T

--6. query to fetch only the odd salaries from the employee table
SELECT Salary FROM Testtabl T
WHERE Salary % 2 = 1

--7. create view to fetch EmpID, EmpName, DepartmentName, ProjectManagerName, where salary is greater than 30000

CREATE VIEW vw_t_salary_30000 
AS
 SELECT T.EmpID, T.EmpName,T.Salary, DP.DepartmentName, P.ProjectManagerName
 FROM [EmployeeDbForHrDepart]..TestTabl T
 INNER JOIN [EmployeeDbForHrDepart]..De_partment DP 
 ON T.DepartmentID = DP.DepartmentID
INNER JOIN[EmployeeDbForHrDepart]..ProjectManager P 
 ON DP.DepartmentID = P.DepartmentID
 WHERE T.Salary > 30000
SELECT*FROM [EmployeeDbForHrDepart]..vw_t_salary_30000 

--8. create view to fetch the top earnerrs from each department, the employee name and the department they belong to

CREATE VIEW vw_highest_S_earners
AS
SELECT T. Salary MAXSalary,DP.DepartmentName, T.EmpName
FROM [EmployeeDbForHrDepart].. Testtabl T
JOIN [EmployeeDbForHrDepart]..De_partment DP
ON  T.DepartmentID = DP.DepartmentID
JOIN (SELECT DepartmentID, MAX (Salary) AS MAXSalary
FROM [EmployeeDbForHrDepart]..TestTabl T
GROUP BY DepartmentID) M ON T.DepartmentID=M.DepartmentID
AND T.Salary=M.MAXSalary
 SELECT*FROM [EmployeeDbForHrDepart]..vw_highest_S_earners



 --9 create a stored procedure to update the employee's salary by 25% where department (IT) and projectmanager not in vivek,satish.
CREATE PROCEDURE sp_salary_increase
AS
 BEGIN 
	UPDATE T
	SET T.Salary = T.Salary * 1.25
	FROM [EmployeeDbForHrDepart]..TestTabl T
	INNER JOIN De_partment DP ON T.DepartmentID = DP.DepartmentID
	INNER JOIN Projectmanager  PM ON DP.DepartmentID = PM.DepartmentID
	WHERE DP.DepartmentName ='IT' 
	  AND PM.ProjectManagerName NOT IN ('Vivek', 'Satish');
END;
GO
EXEC sp_salary_increase;
GO	
	select*from [EmployeeDbForHrDepart]..TestTabl


--10 Create a stored procedures to fetch all the Empname,projectmanaqge name,statename and use error handling also

CREATE PROCEDURE sp_fetch_testabl_details
AS
BEGIN
    BEGIN TRY
        SELECT 
            T.EmpName, 
            PM.ProjectManagerName, 
            DP.DepartmentName, 
            S.StateName
        FROM [EmployeeDbForHrDepart]..TestTabl T
        INNER JOIN [EmployeeDbForHrDepart]..De_partment DP ON T.DepartmentID = DP.DepartmentID
        INNER JOIN [EmployeeDbForHrDepart]..Projectmanager PM ON DP.DepartmentID = PM.DepartmentID
        INNER JOIN [EmployeeDbForHrDepart]..StateMaster S ON T.StateID = S.StateID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(400), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        PRINT 'Error occurred: ' + @ErrorMessage;
        
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
	
	


--3RD Assignment


CREATE DATABASE Retail_InventoryDb;

USE Retail_InventoryDb;

CREATE TABLE Pro_duct(
      [ProductID] NVARCHAR(20), 
	  [ProductName] NVARCHAR(20), 
	  [CategoryID] INT,
	  [Price] INT, 
	  [Quantity] INT,
	  [SupplierID] INT
	  );

INSERT INTO Pro_duct (ProductID, ProductName, CategoryID, Price, Quantity, SupplierID)
VALUES   
     ('P01', 'Laptop', '1','1200','50', '101'),
     ('P02', 'Smartphone','1', '800','100', '102'), 
     ('P03', 'TV', '2', '1500','30', '103'),
     ('P04', 'Refrigerator', '2', '900','25', '104'),
     ('P05', 'Microwave', '3', '200','60', '105'),
     ('P06', 'Washing Machine', '2', '1100','20', '106'),
	 ('P07', 'Headphone', '4', '100','200', '107'),
     ('P08', 'Camera', '1', '700','15', '108'),
	 ('P09', 'Air Conditioner', '2', '1300','10', '109'),
	 ('P10', 'Blender', '3','150','80', '110');


CREATE TABLE Category
(
     [CategoryID] INT,
	  [CategoryName] NVARCHAR(20)
	  );

INSERT INTO Category (CategoryID, CategoryName)
VALUES  
	('1', 'Electronics'),
	('2', 'Appliances'),
	('3', 'Kitchenware'),
	('4', 'Accessories');





CREATE TABLE Supplier
(
	 [SupplierID] INT,
	 [SupplierName] NVARCHAR(20),
     [ContactNumber] NVARCHAR(20)
	 );

INSERT INTO Supplier (SupplierID, SupplierName, ContactNumber)
VALUES  
	('101', 'SupplierA','123-456-7890'),
	('102', 'SupplierB','234-567-8901'),
	('103', 'SupplierC','345-678-9012'),
	('104', 'SupplierD','456-789-0123'),
	('105','SupplierE','567-890-1234'),
	('106','SupplierF','678-901-2345'),
	('107','SupplierG','789-012-3456'),
	('108','SupplierH','890-123-4567'),
	('109','SupplierI','901-234-5678'),
	('110','SupplierJ','012-345-6789');




CREATE TABLE Warehouse
(
       [WarehouseID] NVARCHAR(20),
	   [WarehouseName] NVARCHAR(30),
	   [Location] NVARCHAR(20)
	  );

INSERT INTO Warehouse (WarehouseID, WarehouseName, Location)
VALUES
    ('W01', 'MainWarehouse', 'NewYork'),
	('W02','EastWarehouse', 'Boston'),
	('W03','WestWarehouse', 'San Diego'),
	('W04', 'NorthWarehouse', 'Chicago'),
	('W05', 'SouthWarehouse', 'Miami'),
	('W06', 'CentralWarehouse', 'Dallas'),
	('W07', 'PacificWarehouse', 'San Francisco'),
	('W08', 'MountainWarehouse', 'Denver'),
    ('W09','SouthernWarehouse', 'Atlanta'),
    ('W10', 'GulfWarehouse', 'Houston');


--solutions to the questions

--1. write a SQL query to fetch products with the same price.

SELECT * 
FROM Pro_duct
WHERE Price IN (
   SELECT (Price)
   FROM Pro_duct
   GROUP BY Price
   HAVING COUNT (Price) > 1
);


--2. write a SQL query to fetch find the second highest priced product and its category.
 
SELECT P.ProductID, P.ProductName,P.Price,C.CategoryName
FROM Pro_duct P
INNER JOIN Category C
ON P.CategoryID = C.CategoryID
ORDER BY Price DESC
OFFSET  1 ROW
FETCH NEXT 1 ROW ONLY



--3. WRITE A QUERY TO GET THE MAXIMUM SALARY FROM EACH DEPARTMEENT, THE NAME OF THE DEPARTMENT AND THEE NAME OF THE EANER 

SELECT P. Price MAXPrice,C.CategoryName, P.ProductName
FROM Pro_duct P
JOIN Category C
ON  P.CategoryID = C.CategoryID
JOIN (SELECT CategoryID, MAX (Price) AS MAXPrice
FROM Pro_duct P
GROUP BY CategoryID) M ON C.CategoryID=M.CategoryID
AND P. Price = MAXPrice
 
 
 --4. WRITE A SQL QUERY TO FETCH Supplier-wise count of products sorted by count in descending order

 SELECT COUNT(DISTINCT P.ProductName) count_of_sw ,P.SupplierID,S.SupplierName
 FROM Pro_duct P, Supplier S
 WHERE P.SupplierID = S.SupplierID 
 GROUP BY P.SupplierID,S.SupplierName 
 ORDER BY COUNT(*) DESC


 
 --5.query to fetch only the first word from the ProductName and append the price..
SELECT CONCAT(LEFT(ProductName,
        CHARINDEX ('',ProductName )+1), '_',Price) FirstWord_Price
FROM Pro_duct P


--6. query to fetch products with odd prices.
SELECT Price FROM Pro_duct P
WHERE Price % 2 = 1


--7. Create a view to fetch products with a price greater than $500.
CREATE VIEW vw_pt_price_$500 
AS
 SELECT P.ProductID, P.ProductName,P.Price, P.Quantity, C.CategoryName, S.SupplierName
 FROM Pro_duct P
 INNER JOIN Category C 
 ON P.CategoryID = C.CategoryID
INNER JOIN Supplier S
 ON P.SupplierID = S.SupplierID
 WHERE P.Price > $500
SELECT*FROM [HealthcarePatientDb]..vw_pt_price_$500 

--8. 2.	Create a procedure to update product prices by 15% where the category is 'Electronics' and the supplier is not 'SupplierA'.

CREATE PROCEDURE sp_price_increase
AS
 BEGIN 
	UPDATE P
	SET P.Price = P.Price * 1.15
	FROM Pro_duct P
	INNER JOIN Category C ON P.CategoryID = C.CategoryID
	INNER JOIN Supplier S ON P.SupplierID = S.SupplierID
	WHERE C.CategoryName ='Electronics' 
	  AND S.SupplierName NOT IN ('SupplierA');
END;
EXEC sp_price_increase;
GO

--9.Create a stored procedure to fetch product details along with their category, and how to screenshot using keyboardsupplier, including error handling.

CREATE PROCEDURE sp_fetch_retail_details
AS
BEGIN
    BEGIN TRY
        SELECT 
            P.ProductName, 
            C.CategoryName, 
            S.supplierName
        FROM Pro_duct P
        INNER JOIN Category C ON P.CategoryID = C.CategoryID
        INNER JOIN Supplier S ON P.SupplierID = S.SupplierID
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(400), @ErrorSeverity INT, @ErrorState INT;
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        PRINT 'Error occurred: ' + @ErrorMessage;
        
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO


--4th Assignmeent


HealthcarePatientDb

	
CREATE DATABASE HealthcarePatientDb;

USE HealthcarePatientDb;

CREATE TABLE Patient(
      [PatientID] NVARCHAR(20), 
	  [PatientName] NVARCHAR(30), 
	  [Age] INT,
	  [Gender] NVARCHAR(3), 
	  [DoctorID] INT,
	  [StateID] INT
	  );

INSERT INTO Patient(PatientID, PatientName, Age, Gender, DoctorID, StateID)
VALUES   
     ('PT01','John Doe', '45', 'M', '1', '101'),
     ('PT02', 'Jane Smith','30', 'F','2', '102'), 
     ('PT03', 'Mercy johnson', '60', 'F','3', '103'),
     ('PT04', 'Michael Brown', '50', 'M','4', '104'),
     ('PT05', 'Patricia Davis', '40', 'F','1', '105'),
     ('PT06', 'Robert Miller', '55', 'M','2', '106'),
	 ('PT07', 'Linda Wilson', '35', 'F','3', '107'),
     ('PT08', 'William Moore', '65', 'M','4', '108'),
	 ('PT09', 'Barbara Taylor', '28', 'F','1', '109'),
	 ('PT10', 'James Anderson', '70','M','2', '110');



CREATE TABLE Doctor
(
     [DoctorID] INT,
	  [DoctorName] NVARCHAR(20),
	  [Specialization] NVARCHAR(30)
	  );

INSERT INTO Doctor (DoctorID, DoctorName,Specialization)
VALUES  
	('1', 'Dr. Smith', 'Cardiology'),
	('2', 'Dr. Adams', 'Neurology'),
	('3', 'Dr. White','Orthopedics'),
	('4', 'Dr. Johnson', 'Dermatology');


CREATE TABLE State_master
(
	 [StateID] INT,
	 [StateName] NVARCHAR(20)
	 );

INSERT INTO State_master(StateID, StateName)
VALUES  
	('101', 'Lagos'),
	('102', 'Abuja'),
	('103', 'Kano'),
	('104', 'Delta'),
	('105','Ido'),
	('106','Ibadan'),
	('107','Enugu'),
	('108','Kaduna'),
	('109','Ogun'),
	('110','Anambra');




CREATE TABLE  Depart_ment
(
       [DepartmentID] INT,
	   [DepartmentName] NVARCHAR(30)
	  );

INSERT INTO  Depart_ment(DepartmentID, DepartmentName)
VALUES
    ('1', 'Cardiology'),
	('2','Neurology'),
	('3','Orthopedics'),
	('4', 'Dermatology');


--1. write a SQL query to fetch products with the same Age
	
SELECT * 
FROM Patient
WHERE Age IN (
   SELECT (Age)
   FROM Patient
   GROUP BY Age
   HAVING COUNT (Age) > 1
);


--2. write a SQL query to fetch find the second oldest patient and their doctor and department..
 
SELECT PT.PatientID, PT.PatientName,PT.Age,D.DoctorName
FROM Patient PT
INNER JOIN Doctor D
ON PT.DoctorID = d.DoctorID
ORDER BY Age DESC
OFFSET  1 ROW
FETCH NEXT 1 ROW ONLY



--3. write a query to get the maximum age per department and the patient name.

SELECT PT.PatientName, PT.Age MAXAge, DM.DepartmentName
FROM  Patient PT
JOIN Doctor D
ON  PT.DoctorID = D.DoctorID
JOIN Depart_ment DM 
ON D.DoctorID = DM.DepartmentID
JOIN (SELECT PT.DoctorID, MAX (Age) AS MAXAge
FROM Patient PT
GROUP BY DoctorID) M ON D.DoctorID = D.DoctorID
AND PT. Age = MAXAge
 
 

 --4. write a query to fetch doctor-wise count of patients sorted by count in descending order.

 SELECT COUNT(DISTINCT PT.PatientName) count_of_dw, PT.DoctorID, D.DoctorName
 FROM Patient PT, Doctor D
 WHERE PT.DoctorID = D.DoctorID 
 GROUP BY PT.DoctorID, D.DoctorName 
 ORDER BY COUNT(*) DESC


 
 --5.query to fetch only the first name from the PatientName and append the age.
SELECT CONCAT(LEFT(PatientName,
        CHARINDEX (' ',PatientName )-1), '_',Age) FirstName_Age
FROM Patient PT


--6. query to fetch patients with odd ages.
SELECT PatientName, Age FROM Patient PT
WHERE Age % 2 = 1

--7. Create a view to fetch patient details with an age greater than 50
CREATE VIEW vw_pt_age_50 
AS
 SELECT PT.PatientID, PT.PatientName,PT.Age, PT.Gender, DM.DepartmentName, SM.StateID
 FROM Patient PT
 INNER JOIN Doctor D 
 ON PT.DoctorID = D.DoctorID
INNER JOIN State_master SM 
 ON PT.StateID = SM.StateID
 INNER JOIN Depart_ment DM 
 ON D.DoctorID = DM.DepartmentID
 WHERE PT.Age > 50
SELECT*FROM [HealthcarePatientDb]..vw_pt_age_50 

--8.Create a procedure to update the patient's age by 10% where the department is 'Cardiology' and the doctor is not 'Dr. Smith'.

CREATE PROCEDURE PatientAgerise
AS
 BEGIN 
	UPDATE PT
	SET PT.Age = PT.Age * 1.10
	FROM Patient PT
	INNER JOIN Doctor D ON PT.DoctorID = D.DoctorID
	INNER JOIN Depart_ment DM ON D.DoctorID = DM.DepartmentID
	WHERE DM.DepartmentName ='Cardiology' 
	  AND D.DoctorName NOT IN ('Dr. Smith')
END
GO;
EXEC PatientAgerise;
GO 


--9.Create a stored procedure to fetch patient details along with their doctor, department, and state, including error handling.

CREATE PROCEDURE sp_fetch_testabl_details
AS
BEGIN
    BEGIN TRY
        SELECT 
            PT.PatientID,
			PT.PatientName,
			PT.Age,
            D.DoctorName,
			DM.DepartmentName,
			SM.StateName
        FROM Patient PT
        INNER JOIN Doctor D ON D.DoctorID = PT.DoctorID
        INNER JOIN Depart_ment DM ON D.DoctorID = DM.DepartmentID
        INNER JOIN State_Master SM ON PT.StateID = SM.StateID;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(500)
		SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR (@ErrorMessage, 16,1);
    END CATCH
END;
GO



-- 5TH ASSIGNMENT

CREATE DATABASE FinanceLoanDb;

USE FinanceLoanDb;

CREATE TABLE Customer(
      [CustomerID] NVARCHAR(20), 
	  [CustomerName] NVARCHAR(30), 
	  [LoanID] NVARCHAR(50),
	  [LoanAmount] INT, 
	  [InterestRate] NVARCHAR(20),
	  [StateID] NVARCHAR(20)
	  );

INSERT INTO Customer(CustomerID, CustomerName, LoanID, LoanAmount, InterestRate, StateID)
VALUES   
     ('C01','Alice Johnson', 'L01', '50000', '5.50%', '101'),
     ('C02', 'Bob Smith','L02', '75000','6.00%', '102'), 
     ('C03', 'Carol white', 'L03', '60000','4.80%', '103'),
     ('C04', 'Dave Williams', 'L04', '85000','5.20%', '104'),
     ('C05', 'Emma Brown', 'L05', '55000','4.50%', '105'),
     ('C06', 'Frank Miller', 'L06', '40000','6.50%', '106'),
	 ('C07', 'Grace Davis', 'L07', '95000','5.80%', '107'),
     ('C08', 'Henry Willson', 'L08', '30000','6.20%', '108'),
	 ('C09', 'Irene Moore', 'L09', '70000','5.00%', '109'),
	 ('C10', 'Jack Taylor', 'L10','80000','5.70%', '110');

SELECT*FROM[dbo].[Customer]

CREATE TABLE Loan
(
     [LoanID] NVARCHAR(20),
	  [LoanType] NVARCHAR(20),
	  [LoanAmount] INT,
	  [CustomerID] NVARCHAR(30)
	  );

INSERT INTO Loan (LoanID, LoanType, LoanAmount, CustomerID)
VALUES  
	('L01', 'Home Loan', '50000','C01'),
	('L02', 'Auto Loan', '75000', 'C02'),
	('L03', 'Personal Loan','60000', 'C03'),
	('L04', 'Education Loan', '85000','C04'),
	('L05', 'Business Loan', '55000','C05'),
	('L06', 'Home Loan', '40000','C06'),
	('L07', 'Auto Loan', '95000','C07'),
	('L08', 'Personal Loan', '30000','C08'),
	('L09', 'Education Loan', '70000','C09'),
	('L10', 'Business Loan', '80000','C10');


CREATE TABLE Statemaster
(
	 [StateID] INT,
	 [StateName] NVARCHAR(20)
	 );

INSERT INTO Statemaster(StateID, StateName)
VALUES  
	('101', 'Lagos'),
	('102', 'Abuja'),
	('103', 'Kano'),
	('104', 'Delta'),
	('105','Ido'),
	('106','Ibadan'),
	('107','Enugu'),
	('108','Kaduna'),
	('109','Ogun'),
	('110','Anambra');




CREATE TABLE  Branchmaster
(
       [BranchmasterID] NVARCHAR(20),
	   [BranchmasterName] NVARCHAR(30),
	   [Location]NVARCHAR(20)
	  );

INSERT INTO  Branchmaster(BranchmasterID, BranchmasterName, Location)
VALUES
    ('B01', 'MainBranch', 'Lagos'),
	('B02','EastBranch', 'Abuja'),
	('B03','WestBranch', 'Kano'),
	('B04', 'NorthBranch', 'Delta'),
	('B05', 'SouthBranch', 'Ido'),
	('B06', 'CentralBranch', 'Ibadan'),
	('B07', 'PacificBranch', 'Enugu'),
	('B08', 'MountainBranch', 'Kaduna'),
	('B09', 'SouthernBranch', 'Ogun'),
	('B10', 'GulfBranch', 'Anambra');
	SELECT *FROM [dbo].[Branchmaster]

--1.Fetch customers with the same loan amount.

SELECT * 
FROM Customer
WHERE LoanAmount IN (
   SELECT (LoanAmount)
   FROM Customer
   GROUP BY LoanAmount
   HAVING COUNT (LoanAmount) > 1
);

--2.	Find the second highest loan amount and the customer and branch associated with it

SELECT C.CustomerID, C.CustomerName,C.LoanAmount,StateName, B.BranchmasterName
FROM Customer C
INNER JOIN Statemaster S
ON C.StateID = S.StateID
INNER JOIN Branchmaster B
ON S.StateName = B.Location
ORDER BY LoanAmount DESC
OFFSET  1 ROW
FETCH NEXT 1 ROW ONLY


--3.	Get the maximum loan amount per branch and the customer name.


SELECT C.CustomerName, C.LoanAmount MAXLoanAmount, StateName, B.BranchmasterName
FROM Customer C
INNER JOIN Statemaster S
ON C.StateID = S.StateID
INNER JOIN Branchmaster B
ON S.StateName = B.Location
JOIN (SELECT C.CustomerName, MAX (LoanAmount) AS MAXLoanAmount
FROM Customer C
GROUP BY StateID,CustomerName ) M ON C.StateID = C.StateID
AND C.LoanAmount = MAXLoanAmount


--4.	Branch-wise count of customers sorted by count in descending order.

SELECT COUNT(DISTINCT C.CustomerName) count_of_bw, B.BranchmasterName
 FROM Customer C, Branchmaster B, Statemaster S
 WHERE C.StateID = S.StateID
 AND S.StateName = B.Location
 GROUP BY C.CustomerName, B.BranchmasterName
 ORDER BY COUNT(*) DESC


--5.	Fetch only the first name from the CustomerName and append the loan amount.

SELECT CONCAT(LEFT(CustomerName,
        CHARINDEX (' ',CustomerName )-1), '_',LoanAmount) FirstName_Age
FROM Customer C


--6.	Fetch loans with odd amounts.

SELECT CustomerName,LoanAmount  FROM Customer C
WHERE LoanAmount % 2 = 1


--7.	Create a view to fetch loan details with an amount greater than $50,000.

CREATE VIEW vw_pt_loanamount_$50000 
AS
 SELECT C.CustomerID, C.CustomerName,C.LoanAmount, C.InterestRate, L.LoanType, S.StateName, B.BranchmasterName
 FROM Customer C
 INNER JOIN Loan L
 ON L.LoanID = C.LoanID
 INNER JOIN Statemaster S
 ON C.StateID = S.StateID
INNER JOIN Branchmaster B 
 ON S.StateName = B.Location
 WHERE C.LoanAmount > $50000

--8.Create a procedure to update the loan interest rate by 2% where the loan type is 'Home Loan' and the branch is not 'MainBranch'.

CREATE PROCEDURE InterestRate
AS
 BEGIN 
	UPDATE C
	SET C.InterestRate = C.InterestRate * 1.02
	FROM Customer C
	INNER JOIN Loan L ON C.LoanID = L.LoanID
	INNER JOIN Branchmaster B ON S.StateName = B.Location
	WHERE L.LoanType = 'HomeLoan' 
	  AND B.BranchmasterName NOT IN ('MainBranch')
END
GO;
EXEC InterestRate;
GO 


--9.Create a stored procedure to fetch loan details along with the customer, branch, and state, including error handling.
CREATE PROCEDURE sp_fetch_loan_details
AS
BEGIN
    BEGIN TRY
        SELECT 
            C.LoanID,
			C.LoanAmount,
            C.CustomerID,
			C.CustomerName,
			L.LoanType,
			B.BranchmasterName
        FROM Customer C
        INNER JOIN Loan L ON C.CustomerID = L.CustomerID
        INNER JOIN Statemaster S ON S.StateName = B.Location
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(3000)
		SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR (@ErrorMessage, 20,1);
    END CATCH
END;
GO



--6TH ASSIGNMENT

CREATE DATABASE  Education_StudentDb;

USE Education_StudentDb;

CREATE TABLE Student(
      [StudentID] NVARCHAR(20), 
	  [StudentName] NVARCHAR(30), 
	  [Age] INT,
	  [ClassID]INT,
	  [StateID] INT,
	  );

INSERT INTO Student(StudentID,	StudentName,	Age,	ClassID,	StateID)
VALUES   
     ('S01','Alice Brown', '16', '1', '101'),
     ('S02', 'Bob White','15','2', '102'), 
     ('S03', 'Charlie Black', '17','3', '103'),
     ('S04', 'Daisy Green', '16','4', '104'),
     ('S05', 'Edward Blue', '14','1', '105'),
     ('S06', 'Fiona Red', '18','2', '106'),
	 ('S07', 'George Yellow', '15','3', '107'),
     ('S08', 'Hannah Purple', '16','4', '108'),
	 ('S09', 'Ian Orange', '17','1', '109'),
	 ('S10', 'Jane Grey', '14','2', '110');

SELECT*FROM[dbo].[Student]

CREATE TABLE ClassMaster
(
     [ClassID] INT,
	  [ClassName] NVARCHAR(20),
	  [TeacherID] NVARCHAR(30)
	  );

INSERT INTO ClassMaster (ClassID, ClassName,TeacherID)
VALUES  
	('1', '10th Grade', 'T01'),
	('2', '9th Grade', 'T02'),
	('3', '11th Grade','T03'),
	('4', '12th Grade', 'T04');


CREATE TABLE  TeacherMaster
(
       [TeacherID] NVARCHAR(20),
	   [TeacherName] NVARCHAR(30),
	   [Subject] NVARCHAR(20)
	  );

INSERT INTO TeacherMaster(TeacherID,TeacherName,Subject)
VALUES
    ('T01',	'Mr. Johnson','Mathematics'),
	('T02',	'Ms. Smith','Science'),
	('T03',	'Mr. Williams',	'English'),
	('T04',	'Ms. Brown','History');

CREATE TABLE StateMaster
(
	 [StateID] INT,
	 [StateName] NVARCHAR(20)
	 );

INSERT INTO StateMaster(StateID, StateName)
VALUES  
	('101', 'Lagos'),
	('102', 'Abuja'),
	('103', 'Kano'),
	('104', 'Delta'),
	('105','Ido'),
	('106','Ibadan'),
	('107','Enugu'),
	('108','Kaduna'),
	('109','Ogun'),
	('110','Anambra');

	SELECT * FROM StateMaster

--1.Fetch students with the same age.

SELECT * 
FROM Student
WHERE Age IN (
   SELECT Age
   FROM Student
   GROUP BY Age
   HAVING COUNT (Age) > 1
);
select*from Student



--2.	Find the second youngest student and their class and teacher.

SELECT S.StudentID, S.StudentName,S.Age,C.ClassName, T.TeacherName
FROM Student S
INNER JOIN Classmaster C
ON S.ClassID = C.ClassID
INNER JOIN Teachermaster T
ON C.TeacherID = T.TeacherID
ORDER BY Age 
OFFSET  1 ROW
FETCH NEXT 1 ROW ONLY


--3.	Get the maximum age per class and the student name.

SELECT  S.StudentName, S.Age MAXAge, C.ClassName, T.TeacherName
FROM Student S
INNER JOIN Classmaster C
ON S.ClassID = C.ClassID
INNER JOIN Teachermaster T
ON C.TeacherID = T.TeacherID
JOIN (SELECT ClassID, MAX (Age) AS MAXAge
FROM Student S
GROUP BY ClassID) M ON S.ClassID = M.ClassID
AND S.Age = M.MAXAge



--4.	Teacher-wise count of students sorted by count in descending order.

SELECT COUNT(DISTINCT S.StudentName) count_of_tw, T.TeacherName
 FROM Student S, TeacherMaster T, ClassMaster C
 WHERE C.TeacherID = T.TeacherID
 AND S.ClassID = C.ClassID
 GROUP BY S.StudentName, T.TeacherName
 ORDER BY COUNT(*) DESC


--5.	Fetch only the first name from the StudentName and append the age.

SELECT CONCAT(LEFT(StudentName,
        CHARINDEX (' ',StudentName )-1), '_',Age) FirstName_Age
FROM Student S


--6.	Fetch students with odd ages.

SELECT StudentName,Age  FROM Student S
WHERE Age % 2 = 1


--7.	Create a view to fetch student details with an age greater than 15.

CREATE VIEW vw_pt_age_15 
AS
 SELECT S.StudentID, S.StudentName,S.Age, C.ClassName, T.TeacherName, T.Subject, ST.StateName
 FROM Student S
 INNER JOIN Classmaster C
ON S.ClassID = C.ClassID
INNER JOIN Teachermaster T
ON C.TeacherID = T.TeacherID
INNER JOIN Statemaster ST 
 ON S.StateID = ST.StateID
 WHERE S.Age > 15

--8.Create a procedure to update the student's age by 1 year where the class is '10th Grade' and the teacher is not 'Mr. Johnson'.

CREATE PROCEDURE IncreaseAge
AS
 BEGIN 
	UPDATE S
	SET S.Age = S.Age + 1
	FROM Student S
	INNER JOIN ClassMaster C ON S.ClassID = C.ClassID
    INNER JOIN TeacherMaster T ON C.TeacherID = T.TeacherID
	WHERE C.ClassName = '10th Grade' 
	AND T.TeacherName NOT IN ('Mr. Johnson');
END;
GO;
EXEC increaseAge;
GO 


--9.Create a stored procedure to fetch loan details along with the customer, branch, and state, including error handling.
CREATE PROCEDURE sp_fetch_loan_details
AS
BEGIN
    BEGIN TRY
        SELECT  
		 S.StudentID,
		 S.StudentName,
		 S.Age, 
		 C.ClassName, 
		 T.TeacherName, 
		 T.Subject, 
		 ST.StateName
        FROM Student S
  INNER JOIN Classmaster C ON S.ClassID = C.ClassID
  INNER JOIN Teachermaster T ON C.TeacherID = T.TeacherID
  INNER JOIN Statemaster ST ON S.StateID = ST.StateID
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(3000)
		SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR (@ErrorMessage, 20,1);
    END CATCH
END;
GO



--7TH QUESTION

CREATE DATABASE HospitalityHotelDb;

USE HospitalityHotelDb;

CREATE TABLE GuestMaster(
      [GuestID] NVARCHAR(20), 
	  [GuestName] NVARCHAR(30), 
	  [RoomID] NVARCHAR(10),
	  [CheckInDate] NVARCHAR(10),
	  [CheckOutDate] NVARCHAR(10),
	  [StateID] INT
	  );

INSERT INTO GuestMaster(GuestID,GuestName,	RoomID,	CheckInDate,CheckOutDate,	StateID)
VALUES   
			 ('G01','John Doe',	'R01',	'8/1/2024',	'8/5/2024',	'101'),
			 ('G02','Jane Smith','R02',	'8/2/2024',	'8/7/2024','102'), 
			 ('G03','Mike Johnson','R03',	'8/3/2024',	'8/8/2024',	'103'),
			 ('G04','Sara Williams','R04','8/4/2024','8/9/2024','104'),
			 ('G05','David Brown', 'R05',	'8/5/2024',	'8/10/2024','105'),
			 ('G06','Emma Davis',  'R06','8/6/2024','8/11/2024','106'),
			 ('G07','Frank Miller','R07','8/7/2024','8/12/2024','107'),
			 ('G08', 'Grace Wilson','R08', '8/8/2024',	'8/13/2024',	'108'),
			 ('G09','Henry Moore', 'R09', '8/9/2024','8/14/2024',	'109'),
		     ('G10','Linda Taylor','R10',	'8/10/2024',	'8/15/2024',	'110');



CREATE TABLE Room
(
     [RoomID] NVARCHAR(10),
	  [RoomType] NVARCHAR(20),
	  [Price] INT,
	  [Status] NVARCHAR(20)
	  );

INSERT INTO Room (RoomID,RoomType,Price,Status)
VALUES  
	('R01',	'Single',	'100',	'Booked'),
	('R02',	'Double',	'200',	'Booked'),
	('R03',	'Suite',	'500',	'Booked'),
	('R04',	'Deluxe',	'300',	'Booked'),
	('R05',	'Single',	'100',	'Booked'),
	('R06',	'Double',	'200',	'Booked'),
	('R07',	'Suite',	'500',	'Booked'),
	('R08',	'Deluxe',	'300',	'Booked'),
	('R09',	'Single',	'100',	'Booked'),
	('R10',	'Suite',	'500',	'Booked');


CREATE TABLE  Booking
(
       [BookingID] NVARCHAR(20),
	   [GuestID] NVARCHAR(10),
	   [RoomID] NVARCHAR(10),
	   [CheckInDate] NVARCHAR(20),
	   [CheckOutDate] NVARCHAR(20),
	   [TotalAmount] INT
	  );

INSERT INTO Booking(BookingID,GuestID,RoomID,CheckInDate,CheckOutDate,TotalAmount)
VALUES
		('B01',	'G01',	'R01',	'8/1/2024',	'8/5/2024',	'400'),
		('B02',	'G02',	'R02',	'8/2/2024',	'8/7/2024',	'1000'),
		('B03',	'G03',	'R03',	'8/3/2024',	'8/8/2024',	'2500'),
		('B04',	'G04',	'R04',	'8/4/2024',	'8/9/2024',	'1500'),
		('B05',	'G05',	'R05',	'8/5/2024',	'8/10/2024','500'),
		('B06',	'G06',	'R06',	'8/6/2024',	'8/11/2024','1000'),
		('B07',	'G07',	'R07',	'8/7/2024',	'8/12/2024','2500'),
		('B08',	'G08',	'R08',	'8/8/2024',	'8/13/2024','1500'),
		('B09',	'G09',	'R09',	'8/9/2024',	'8/14/2024','500'),
		('B10',	'G10',	'R10',	'8/10/2024','8/15/2024','2500');

CREATE TABLE Statemaster
(
	 [StateID] INT,
	 [StateName] NVARCHAR(20)
	 );

INSERT INTO StateMaster(StateID, StateName)
VALUES  
	('101', 'Lagos'),
	('102', 'Abuja'),
	('103', 'Kano'),
	('104', 'Delta'),
	('105','Ido'),
	('106','Ibadan'),
	('107','Enugu'),
	('108','Kaduna'),
	('109','Ogun'),
	('110','Anambra');


--QUESTIONS ANDD ANWSERS

--1.Fetch guests who stayed for the same number of days.

SELECT GuestName,CheckInDate,CheckOutDate,RoomID, DATEDIFF (day, CheckInDate,CheckOutDate) AS StayedDays
FROM GuestMaster
WHERE DATEDIFF(day, CheckInDate, CheckOutDate) IN (
        SELECT DATEDIFF(day, CheckInDate, CheckOutDate)
        FROM GuestMaster
        GROUP BY DATEDIFF(day, CheckInDate, CheckOutDate)
        HAVING COUNT(*) > 1
    )
  

--2.	Find the second most expensive booking and the guest associated with it.
SELECT G.GuestID, G.GuestName,R.RoomType,R.Price, B.BookingID, B.TotalAmount
FROM GuestMaster G
INNER JOIN Room R
ON G.RoomID = R.RoomID
INNER JOIN Booking B
ON G.RoomID = B.RoomID
ORDER BY TotalAmount DESC
OFFSET  1 ROW
FETCH NEXT 1 ROW ONLY


--3.	Get the maximum room price per room type and the guest name.

SELECT  G.GuestID, G.GuestName, R.Price MAXPrice, R.RoomType
FROM GuestMaster G
INNER JOIN Room R
ON G.RoomID = R.RoomID
JOIN (SELECT RoomID, MAX(Price) AS MAXPrice
FROM Room R
GROUP BY RoomID) M ON G.RoomID = M.RoomID
AND R.Price = M.MAXPrice


--4.	Room type-wise count of guests sorted by count in descending order.

SELECT COUNT(DISTINCT G.GuestName) count_of_tws, R.RoomType
 FROM GuestMaster G, Room R
 WHERE G.RoomID = R.RoomID
 GROUP BY G.GuestName, R.RoomType
 ORDER BY COUNT(*) DESC


--5.	Fetch only the first name from the GuestName and append the total amount spent.

SELECT CONCAT(LEFT(GuestName,
        CHARINDEX (' ',GuestName )-1), '_',TotalAmount) FirstName_Age
FROM GuestMaster G
INNER JOIN Booking B ON G.GuestID = B.GuestID


--6.	Fetch bookings with odd total amounts.

SELECT GuestName,TotalAmount  FROM GuestMaster G
INNER JOIN Booking B ON G.GuestID = B.GuestID
WHERE TotalAmount % 2 = 1




--7.	Create a view to fetch bookings with a total amount greater than $1000.

CREATE VIEW vw_pt_totalamount_$1000 
AS
 SELECT G.GuestID, G.GuestName, B.BookingID, R.RoomType, B.TotalAmount
 FROM GuestMaster G
 INNER JOIN Room R
ON G.RoomID = R.RoomID
INNER JOIN Booking B
ON G.GuestID = B.GuestID
 WHERE B.TotalAmount > $1000

--8.Create a procedure to update the room prices by 10% where the room type is 'Suite' and the state is not 'Lagos'.
CREATE PROCEDURE IncreasePrice
AS
 BEGIN 
	UPDATE R
	SET R.Price = R.Price  * 1.10
	FROM Room R
	INNER JOIN GuestMaster G ON R.RoomID = G.RoomID
	INNER JOIN StateMaster SM ON G.StateID = SM.StateID
	WHERE R.RoomType = 'Suite' 
	AND SM.StateName NOT IN ('Lagos');
END;
GO
EXEC increasePrice;
GO 

--9.Create a stored procedure to fetch booking details along with the guest, room, and state, including error handling.
CREATE PROCEDURE sp_fetch_booking_details
AS
BEGIN
    BEGIN TRY
        SELECT  
		 G.GuestID,
		 G.GuestName,
		 G.CheckInDate, 
		 G.CheckOutDate, 
		 R.RoomType,
		 R.Price,
		 B.BookingID,
		 B.TotalAmount, 
		 SM.StateName
        FROM GuestMaster G
  INNER JOIN Room R ON G.RoomID = R.RoomID
  INNER JOIN Booking B ON G.GuestID = B.GuestID
  INNER JOIN StateMaster SM ON G.StateID = SM.StateID
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(3000)
		SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR (@ErrorMessage, 20,1);
    END CATCH
END;
GO