/* 
 * Sources: 
 * https://en.wikipedia.org/wiki/Java_Database_Connectivity
 * http://infolab.stanford.edu/~ullman/fcdb/oracle/or-jdbc.html
 * https://docs.microsoft.com/en-us/sql/connect/jdbc/reference/jdbc-driver-api-reference?view=sql-server-2017
 * https://www.oracle.com/technetwork/java/overview-141217.html
 * https://docs.oracle.com/javase/8/docs/technotes/guides/jdbc/
 * https://dzone.com/articles/building-simple-data-access-layer-using-jdbc * 
 * Research links to create JDBC Class Library for CSCI.pdf
 */

import java.sql.*;
import java.util.ArrayList;

public class group94JDBC {	
	//Write a query to show whether Employees had ever made a sale on their birthday and show the ones that have, first.
	public final static String TopQuery1 = 	"USE Northwinds2019TSQLV5; " +
											"SELECT O.EmployeeId " +
													",O.OrderDate " +
												    ",HR.BirthDate " +
												    ",dbo.HappyBirthday(O.OrderDate, HR.BirthDate) AS Made_Sale_On_Birthday " +
												    ",OD.Quantity " +
												    ",SUM(YEAR(O.OrderDate) - YEAR(HR.BirthDate)) AS HowOldWasTheEmp " +
										    "FROM Sales.[Order] AS O " + 
										    "INNER JOIN HumanResources.Employee AS HR ON O.EmployeeId = HR.EmployeeId " +
										    "INNER JOIN Sales.OrderDetail AS OD ON O.OrderId = OD.OrderId " +
										    "GROUP BY O.OrderDate " +
												    ",O.EmployeeId " +
												    ",HR.BirthDate " + 
												    ",OD.Quantity " +
										    "ORDER BY Made_Sale_On_Birthday DESC; ";
	
	//Find expired cards that are still being used to place orders, and find how many orders were placed after the expired date has passed?
	public final static String TopQuery2 = 	"USE AdventureWorks2014; " +
											"SELECT N1.CreditCardID " +
												    ",N1.CardType " +
												    ",ExpDate = EOMONTH(DATEFROMPARTS(N1.ExpYear, N1.ExpMonth, 1)) " +
												    ",LastOrderDate = CAST(N2.LastOrderDate AS DATE) " +
												    ",[OrdersAfterExp] = COUNT(DISTINCT N4.SalesOrderID) " +
										    "FROM Sales.CreditCard N1 " +
											"LEFT JOIN ( " +
											    "SELECT X1.CreditCardID " +
											        	",LAstOrderDate = MAX(X1.OrderDate) " +
											    "FROM Sales.SalesOrderHeader X1 " +
											    "GROUP BY X1.CreditCardID " +
											    ") N2 ON N1.CreditCardID = N2.CreditCardID " +
											"LEFT JOIN Sales.SalesOrderHeader N3 ON 1 = 1 " +
											    "AND N1.CreditCardId = N3.CreditCardID " +
											    "AND N3.OrderDate <= EOMONTH(DATEFROMPARTS(N1.ExpYear, N1.ExpMonth, 1)) " +
											"LEFT JOIN Sales.SalesOrderHeader N4 ON 1 = 1 " +
											    "AND N1.CreditCardID = N4.CreditCardID " +
											    "AND N4.OrderDate > EOMONTH(DATEFROMPARTS(N1.ExpYear, N1.ExpMonth, 1)) " +
											"GROUP BY N1.CreditCardID " +
											    ",N1.CardType " +
											    ",N2.LastOrderDate " +
											    ",N1.ExpYear " +
											    ",N1.ExpMonth ";
	
	//Find sales made in a currency other than USD and convert the total amount due into the native currency used, in the AdventureWorks2014 database. 
	public final static String TopQuery3 = 	"USE AdventureWorks2014; " + 	
											"SELECT SOD.SalesOrderId " + 
											",CONCAT ( " + 
												"SUM(SOH.[TotalDue]) " + 
												",' ' " + 
												",CR.FromCurrencyCode " + 
												") AS TotalDue " + 
											",CONCAT ( " + 
												"SUM(SOH.[TotalDue] * CR.[AverageRate]) " + 
												",' ' " + 
												",CR.ToCurrencyCode " + 
												") AS InternationalTotalDue " + 
										"FROM Sales.SalesOrderDetail AS SOD " + 
										"INNER JOIN Sales.SalesOrderHeader SOH ON SOD.SalesOrderID = SOH.SalesOrderID " + 
										"INNER JOIN Sales.CurrencyRate AS CR ON SOH.CurrencyRateID = CR.CurrencyRateID " + 
											"AND SOH.CurrencyRateID IS NOT NULL " + 
										"GROUP BY SOD.SalesOrderId " + 
											",CR.CurrencyRateID " + 
											",CR.FromCurrencyCode " + 
											",CR.ToCurrencyCode " + 
										"ORDER BY SalesOrderID; ";
			
	//Find all the single women, in each department
	public final static String WorstQuery1 = 	"USE AdventureWorks2014; " + 
												"SELECT HumanResources.Department.[Name] AS [Name] " +
														",COUNT(HumanResources.Employee.MaritalStatus) AS [Not Married] " + 
												"FROM( " +
												  	 	"( " +
												  			"HumanResources.EmployeeDepartmentHistory INNER JOIN HumanResources.Employee ON HumanResources.EmployeeDepartmentHistory.BusinessEntityID = HumanResources.Employee.BusinessEntityID " +
												  		") INNER JOIN HumanResources.Department ON HumanResources.Department.DepartmentID = HumanResources.EmployeeDepartmentHistory.DepartmentID " +
												  	") " +
												  	"WHERE HumanResources.Employee.Gender = 'F' " +
												  		"AND HumanResources.Employee.MaritalStatus = 'S' " +
												  	"GROUP BY [Name] " +
												  			",HumanResources.Employee.MaritalStatus; ";
	
	//Employees that have a bonus amount of $5000.00?
	public final static String WorstQuery2 = "USE AdventureWorks2014; " +
											 "SELECT DISTINCT p.LastName " +
											 				",p.FirstName " +
											"FROM Person.Person AS p " +
											"INNER JOIN HumanResources.Employee AS e ON e.BusinessEntityID = p.BusinessEntityID " +
											"WHERE 5000.00 IN ( " +
											       " SELECT Bonus " +
											        "FROM Sales.SalesPerson AS sp " +
											        "WHERE e.BusinessEntityID = sp.BusinessEntityID); ";
	
	//Find the sale percentage of items with a special offer.
	public final static String WorstQuery3 = 	"USE AdventureWorks2014; " +
												"SELECT P.[Name] AS Product " +
												", SO.DiscountPct " +
												"FROM Sales.SpecialOffer AS SO " +
												"INNER JOIN Sales.SpecialOfferProduct AS SOP ON SO.SpecialOfferID = SOP.SpecialOfferID " +
												"INNER JOIN Production.Product AS P ON SOP.ProductID = P.ProductID " +
												"WHERE SO.DiscountPCT > 0.00 " +
												"GROUP BY P.ProductID, SO.DiscountPct " +
														",P.[Name]; ";
	
	public final static String FixedQuery1 = "USE AdventureWorks2014; " + 
											"SELECT Distinct HumanResources.Department.[Name] AS [Department Name] " +
															 ",COUNT(HumanResources.Employee.MaritalStatus) AS [Not Married] " +
															 ",HumanResources.Employee.NationalIDNumber " +
															 ",HumanResources.EmployeePayHistory.Rate " +
											"FROM ( " +
													"( " +
														"(HumanResources.EmployeeDepartmentHistory INNER JOIN HumanResources.Employee ON HumanResources.EmployeeDepartmentHistory.BusinessEntityID = HumanResources.Employee.BusinessEntityID) " +
											              "INNER JOIN HumanResources.Department ON HumanResources.Department.DepartmentID = HumanResources.EmployeeDepartmentHistory.DepartmentID) " + 
											               "INNER JOIN HumanResources.EmployeePayHistory ON HumanResources.EmployeePayHistory.BusinessEntityID = HumanResources.EmployeeDepartmentHistory.BusinessEntityID) " +
											"WHERE HumanResources.Employee.Gender = 'F' " +
											        "AND HumanResources.Employee.MaritalStatus = 'S' " +
											"GROUP BY [Name] " +
											        ",HumanResources.Employee.MaritalStatus " +
											      	",HumanResources.Employee.NationalIDNumber " +
											        ",HumanResources.EmployeePayHistory.Rate; ";				
	
	public final static String FixedQuery2 = 	"USE AdventureWorks2014; " +	 
												"SELECT DISTINCT p.LastName " +
												  	",p.FirstName " +
												  	",sp.bonus " +
												  	",e.hiredate " +
												  	",sp.SalesQuota " +
												  	",sp.SalesLastYear " +
												"FROM Person.Person AS p " +
												"INNER JOIN HumanResources.Employee AS e ON e.BusinessEntityID = p.BusinessEntityID " +
												"INNER JOIN HumanResources.EmployeePayHistory AS h ON h.BusinessEntityID = p.BusinessEntityID " +
												"INNER JOIN Sales.SalesPerson AS sp ON e.BusinessEntityID = sp.BusinessEntityID " +
												"GROUP BY sp.bonus " +
												  	",h.PayFrequency " +
												  	",p.LastName " +
												  	",p.FirstName " +
												  	",p.FirstName " +
												  	",e.HireDate " +
												  	",sp.SalesQuota " +
												  	",sp.SalesLastYear " +
												"ORDER BY sp.bonus DESC"; 
	
	//Find products on sale, with the range of their discount rate, in the AdventureWorks2014 database.
	public final static String FixedQuery3 = 	"USE AdventureWorks2014; " +
												"SELECT P.[Name] AS Product " +
														",CASE " +
														"WHEN MIN(SO.DiscountPCT) = MAX(SO.DiscountPCT) " +
															"THEN dbo.SalePercentSign((MIN(SO.DiscountPCT) + MAX(SO.DiscountPCT)) / 2) " +
														"ELSE CONCAT ( " +
																	"dbo.SalePercentSign(MIN(SO.DiscountPCT)) " +
																	",' to ' " +
																	",dbo.SalePercentSign(MAX(SO.DiscountPCT)) " +
																	") " +
														"END AS PercentOff " +
												"FROM Sales.SpecialOffer AS SO " +
												"INNER JOIN Sales.SpecialOfferProduct AS SOP ON SO.SpecialOfferID = SOP.SpecialOfferID " +
												"INNER JOIN Production.Product AS P ON SOP.ProductID = P.ProductID " +
												"WHERE SO.DiscountPCT > 0.00 " +
												"GROUP BY P.ProductID, P.[Name]";
	
	public static void main(String[] args) throws SQLException {
		String Queries[] = {TopQuery1, TopQuery2, TopQuery3, WorstQuery1, WorstQuery2, WorstQuery3, FixedQuery1, FixedQuery2, FixedQuery3};
		Connection con = null;
		Statement stmnt = null;
		try { con = DriverManager.getConnection("jdbc:sqlserver://localhost;integratedSecurity=true;authenticationScheme=NativeAuthentication"); }
		catch(Exception e) { System.out.println(e.getMessage()); }
		try { stmnt = con.createStatement(); } 
		catch (Exception e) { System.out.println(e.getMessage()); }
		
		for(int q = 0; q < Queries.length; q++) {
		    ArrayList<String> columnNames = new ArrayList<String>();	    
			ResultSet rs = stmnt.executeQuery(Queries[q]);
			ResultSetMetaData columns = rs.getMetaData();		
			
			for(int i = 1; i <= columns.getColumnCount(); i++) {
				if(i == columns.getColumnCount())
		          System.out.print(columns.getColumnName(i));
				else
					System.out.print(columns.getColumnName(i) + " - ");
				columnNames.add(columns.getColumnName(i));
		    }
			System.out.println();
	
		    while (rs.next()) {
		    	for (int i = 0; i < columnNames.size(); i++) {
		    		if(i == columnNames.size()-1)
		    			System.out.print(rs.getString(columnNames.get(i)));
		    		else
		    			System.out.print(rs.getString(columnNames.get(i)) + " - ");
		    	}
		        System.out.println();
		    }
		    System.out.println();
		}
	    con.close();
	}		
}