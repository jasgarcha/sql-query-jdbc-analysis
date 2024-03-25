-- "Simple query should have up to 2 tables joined."															   
-- "Medium query should have from 2 to 3 tables joined, use built-in SQL functions, and group by summarization." 
-- "Complex query should have from 3 or more tables joined, custom scalar functions, use built-in SQL functions, and group by summarization."

-- Problem 01: Find the total cost at checkout for each shopping cart, in the AdventureWorks2014 database.
USE AdventureWorks2014

SELECT SCI.ShoppingCartID
	,CONCAT (
		'$'
		,SUM(SCI.Quantity * P.ListPrice)
		) AS TotalCostAtCheckout
FROM Sales.ShoppingCartItem AS SCI
INNER JOIN Production.Product AS P ON SCI.ProductID = P.ProductID
GROUP BY SCI.ShoppingCartID

-- Problem 02: Find the vehicle and warehouse with the greatest difference in temperature, in the WideWorldImporters database. 
USE WideWorldImporters

SELECT VT.VehicleRegistration
	,CRT.ColdRoomSensorNumber
	,MAX(ABS(CRT.Temperature - VT.Temperature)) AS MaximumTemperatureDifference
FROM Warehouse.VehicleTemperatures AS VT
	,Warehouse.ColdRoomTemperatures AS CRT
GROUP BY VT.VehicleRegistration
	,CRT.ColdRoomSensorNumber
ORDER BY MaximumTemperatureDifference DESC;

-- Problem 03: Determine the unit price of stock items from the warehouse involved in transactions, from most to least expensive, in the WideWorldImporters database. 
USE WideWorldImporters

SELECT WSI.StockItemName
	,WSI.UnitPrice
FROM Warehouse.StockItems AS WSI
INNER JOIN Warehouse.StockItemTransactions AS WSIT ON WSI.StockItemID = WSIT.StockItemID
GROUP BY WSI.StockItemID
	,WSI.StockItemName
	,WSI.UnitPrice
ORDER BY WSI.UnitPrice DESC;

-- Problem 04: Find number of business entities in each city, from greatest to least, in the AdventureWorks2014 database. 
USE AdventureWorks2014

SELECT A.City
	,COUNT(BE.BusinessEntityID) AS NumberOfBusinessEntities
FROM Person.BusinessEntity AS BE
INNER JOIN Person.BusinessEntityAddress AS BEA ON BE.BusinessEntityID = BEA.BusinessEntityID
INNER JOIN Person.[Address] AS A ON BEA.AddressID = A.AddressID
GROUP BY A.City
ORDER BY NumberOfBusinessEntities DESC;

-- Problem 05: Find the number of employees in each department, from greatest to least, in the AdventureWorks2014 database.
USE AdventureWorks2014

SELECT HRD.[Name] AS Department
	,COUNT(HRE.BusinessEntityID) AS NumberOfEmployees
FROM HumanResources.Employee AS HRE
INNER JOIN HumanResources.EmployeeDepartmentHistory AS HREDH ON HRE.BusinessEntityID = HREDH.BusinessEntityID
INNER JOIN HumanResources.Department AS HRD ON HREDH.DepartmentID = HRD.DepartmentID
GROUP BY HREDH.DepartmentID
	,HRD.[Name]
ORDER BY NumberOfEmployees DESC;

-- Problem 06: Find the name of products out of stock, in the AdventureWorks2014 database.
USE AdventureWorks2014

SELECT PP.[Name] AS ProductOutOfStock
FROM Production.Product AS PP
INNER JOIN Production.ProductInventory AS PPI ON PP.ProductID = PPI.ProductID
GROUP BY PPI.Quantity
	,PP.[Name]
HAVING PPI.Quantity = 0

-- Problem 07: Find the state province with the highest tax rate, in the AdventureWorks2014 database.
USE AdventureWorks2014

SELECT TOP 1 SP.[Name]
	,TR.TaxRate
FROM Sales.SalesTaxRate AS TR
INNER JOIN Person.StateProvince AS SP ON TR.StateProvinceID = SP.StateProvinceID
ORDER BY TR.TaxRate DESC;

-- Problem 08: Find the number of employees per sales territory region, from greatest to least, in the AdventureWorksDW2016 database.
USE AdventureWorksDW2016

SELECT DST.SalesTerritoryRegion
	,COUNT(DE.EmployeeKey) AS NumberOfEmployees
FROM dbo.DimEmployee AS DE
INNER JOIN dbo.DimSalesTerritory DST ON DE.SalesTerritoryKey = DST.SalesTerritoryKey
GROUP BY DST.SalesTerritoryRegion
ORDER BY NumberOfEmployees DESC;

-- Problem 09: Find the number of customers per sales territory region, from greatest to least, in the AdventureWorksDW2016 database.
USE AdventureWorksDW2016

SELECT DST.SalesTerritoryRegion
	,COUNT(DC.CustomerKey) AS NumberOfCustomers
FROM dbo.DimCustomer AS DC
INNER JOIN dbo.DimGeography AS DG ON DC.GeographyKey = DG.GeographyKey
INNER JOIN dbo.DimSalesTerritory AS DST ON DG.SalesTerritoryKey = DST.SalesTerritoryKey
GROUP BY DST.SalesTerritoryRegion
ORDER BY NumberOfCustomers DESC;

-- Problem 10: Find all products and their subcategory names, in the AdventureWorksDW2016 database.
USE AdventureWorksDW2016

SELECT DP.EnglishProductName
	,DPC.EnglishProductCategoryName
	,DPC.SpanishProductCategoryName
	,DPC.FrenchProductCategoryName
FROM dbo.DimProduct AS DP
INNER JOIN dbo.DimProductSubcategory AS DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
INNER JOIN dbo.DimProductCategory AS DPC ON DPS.ProductCategoryKey = DPC.ProductCategoryKey

-- Problem 11: Enumerate the employees who work each shift, in the AdventureWorks2014 database.
USE AdventureWorks2014

SELECT S.[Name] AS [Shift]
	,COUNT(E.BusinessEntityID) AS NumberOfEmployees
FROM HumanResources.Employee AS E
INNER JOIN HumanResources.EmployeeDepartmentHistory AS EDH ON E.BusinessEntityID = EDH.BusinessEntityID
INNER JOIN HumanResources.[Shift] AS S ON EDH.ShiftID = S.ShiftID
GROUP BY S.ShiftID
	,S.[Name]

-- Problem 12: Find the number of employees hired each month, from least to greatest, in the AdventureWorks2014 database.
USE AdventureWorks2014

SELECT DATENAME(Month, E.HireDate) AS [Month]
	,COUNT(MONTH(E.HireDate)) AS NumberHired
FROM HumanResources.Employee AS E
GROUP BY DATENAME(Month, E.HireDate)
ORDER BY NumberHired;

-- Problem 13: Return the names and numbers of all entities involved in the transaction chain of an order: from customer tied to the order ID, to the sales person, to the supplier, to the shipper; in the NorthwindsTSQLV5 database.
USE Northwinds2019TSQLV5

SELECT C.CustomerContactName AS Customer
	,O.OrderId
	,REPLACE(P.ProductName, 'Product', '') AS ProductName
	,CONCAT (
		HRE.EmployeeFirstName
		,' '
		,HRE.EmployeeLastName
		) AS SalesPerson
	,HRE.EmployeePhoneNumber AS SalesPersonNumber
	,SUP.SupplierContactName
	,SUP.SupplierPhoneNumber
	,REPLACE(SH.ShipperCompanyName, 'Shipper', '') AS ShipperCompany
	,SH.PhoneNumber AS ShipperCompanyNumber
FROM Sales.[Order] AS O
INNER JOIN HumanResources.Employee AS HRE ON O.EmployeeId = HRE.EmployeeId
INNER JOIN Sales.Customer AS C ON O.CustomerId = C.CustomerId
INNER JOIN Sales.Shipper AS SH ON O.ShipperId = SH.ShipperId
INNER JOIN Sales.OrderDetail AS OD ON O.OrderId = OD.OrderId
INNER JOIN Production.Product AS P ON OD.ProductId = P.ProductId
INNER JOIN Production.Supplier AS SUP ON P.SupplierId = SUP.SupplierId

-- Problem 14: Find cities with more than 20 customers, who placed orders in 2016, in the WideWorldImporters database.
USE WideWorldImporters

SELECT AC.CityName
	,COUNT(C.CustomerID) AS NumberOfCustomers
FROM Sales.Orders AS O
INNER JOIN Sales.Customers AS C ON O.CustomerID = C.CustomerID
INNER JOIN [Application].Cities AS AC ON C.DeliveryCityID = AC.CityID
WHERE O.OrderDate BETWEEN '20160101'
		AND '20170101'
GROUP BY AC.CityID
	,AC.CityName
HAVING COUNT(C.CustomerID) > 20;

-- Problem 15: Find the numbers of sales made in each city, in the WideWorldImportersDW database.
USE WideWorldImportersDW

SELECT C.City
	,COUNT(S.[Sale Key]) AS NumberOfSales
FROM Fact.Sale AS S
INNER JOIN Dimension.City AS C ON S.[City Key] = C.[City Key]
GROUP BY C.[City Key]
	,C.City
ORDER BY NumberOfSales DESC;

-- Problem 16: Find the number of customers with an outstanding balance, whose information is missing, in the WideWorldImportersDW database.
USE WideWorldImportersDW

SELECT C.[Primary Contact]
	,COUNT(C.[Customer Key]) AS NumberWithOutstandingBalance
FROM Fact.[Transaction] AS T
INNER JOIN [Dimension].[Customer] AS C ON T.[Customer Key] = C.[Customer Key]
WHERE T.[Outstanding Balance] <> 0.00
GROUP BY C.[Customer Key]
	,C.[Primary Contact]
HAVING C.[Primary Contact] LIKE 'N/A';

-- Problem 17: Find The total amount of purchases handled by each supplier, from least to greatest, in the WideWorldImportersDW database.
USE WideWorldImportersDW

SELECT S.Supplier
	,SUM(P.[Purchase Key]) AS TotalPurchases
FROM [Fact].[Purchase] AS P
INNER JOIN [Dimension].[Supplier] AS S ON P.[Supplier Key] = S.[Supplier Key]
GROUP BY S.[Supplier Key]
	,S.Supplier
ORDER BY TotalPurchases;

-- Problem 18: Find products on sale, with the range of their discount rate, in the AdventureWorks2014 database. 
USE AdventureWorks2014

SELECT P.[Name] AS Product
	,CASE 
		WHEN MIN(SO.DiscountPCT) = MAX(SO.DiscountPCT)
			THEN dbo.SalePercentSign((MIN(SO.DiscountPCT) + MAX(SO.DiscountPCT)) / 2)
		ELSE CONCAT (
				dbo.SalePercentSign(MIN(SO.DiscountPCT))
				,' to '
				,dbo.SalePercentSign(MAX(SO.DiscountPCT))
				)
		END AS PercentOff
FROM Sales.SpecialOffer AS SO
INNER JOIN Sales.SpecialOfferProduct AS SOP ON SO.SpecialOfferID = SOP.SpecialOfferID
INNER JOIN Production.Product AS P ON SOP.ProductID = P.ProductID
WHERE SO.DiscountPCT > 0.00
GROUP BY P.ProductID
	,P.[Name]

-- Problem 19: Find sales made in a currency other than USD and convert the total amount due into the native currency used, in the AdventureWorks2014 database. 
USE AdventureWorks2014

SELECT SOD.SalesOrderId
	,CONCAT (
		SUM(SOH.[TotalDue])
		,' '
		,CR.FromCurrencyCode
		) AS TotalDue
	,CONCAT (
		SUM(SOH.[TotalDue] * CR.[AverageRate])
		,' '
		,CR.ToCurrencyCode
		) AS InternationalTotalDue
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader SOH ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.CurrencyRate AS CR ON SOH.CurrencyRateID = CR.CurrencyRateID
	AND SOH.CurrencyRateID IS NOT NULL
GROUP BY SOD.SalesOrderId
	,CR.CurrencyRateID
	,CR.FromCurrencyCode
	,CR.ToCurrencyCode
ORDER BY SalesOrderID;

-- Problem 20: Find the number of products shipped by each shipping method, in the AdventureWorks2014 database. 
USE AdventureWorks2014

SELECT SM.[Name] AS ShippingMethod
	,COUNT(P.ProductID) AS NumberOfProductsShipped
FROM Production.Product AS P
INNER JOIN Purchasing.PurchaseOrderDetail AS POD ON P.ProductID = POD.ProductID
INNER JOIN Purchasing.PurchaseOrderHeader AS POH ON POD.PurchaseOrderID = POH.PurchaseOrderID
INNER JOIN Purchasing.ShipMethod AS SM ON POH.ShipMethodID = SM.ShipMethodID
GROUP BY SM.ShipMethodID
	,SM.Name
ORDER BY NumberOfProductsShipped DESC;

-- User defined, custom Scalar functions.
GO

USE AdventureWorks2014
GO

DROP FUNCTION

IF EXISTS WordOneCommaSpaceWordTwoToWordTwoSpaceWordOne 
GO
	CREATE FUNCTION WordOneCommaSpaceWordTwoToWordTwoSpaceWordOne (@WordOneCommaWordTwo AS VARCHAR(25))
	RETURNS VARCHAR(25)
	AS
	BEGIN
		DECLARE @WordOne AS VARCHAR(50) = SUBSTRING(@WordOneCommaWordTwo, 0, CHARINDEX(',', @WordOneCommaWordTwo))
		DECLARE @WordTwo AS VARCHAR(50) = SUBSTRING(@WordOneCommaWordTwo, CHARINDEX(',', @WordOneCommaWordTwo) + 1, LEN(@WordOneCommaWordTwo))

		RETURN CONCAT (
				@WordTwo
				,' '
				,@WordOne
				)
	END;
/*
GO
USE AdventureWorks2014
GO
SELECT dbo.WordOneCommaSpaceWordTwoToWordTwoSpaceWordOne('Garcha, Jasminder');
-- Output: Jasminder Garcha
*/

GO

USE AdventureWorks2014
GO

DROP FUNCTION

IF EXISTS SalePercentSign 

GO
	CREATE FUNCTION SalePercentSign (@DiscountPercent AS SMALLMONEY)
	RETURNS VARCHAR(5)
	AS
	BEGIN
		RETURN CONCAT (
				CAST(@DiscountPercent * 100 AS INT)
				,'%'
				);
	END;
/*
GO
USE AdventureWorks2014
GO
SELECT dbo.SalePercentSign(0.10);
-- Output: 10%
*/