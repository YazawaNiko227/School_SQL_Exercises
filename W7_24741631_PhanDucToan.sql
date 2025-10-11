--1.  Liệt kê danh sách các orders ứng với tổng tiền của từng hóa đơn. Thông tin 
--bao gồm OrderID, OrderDate, Total. Trong đó Total là Sum của Quantity * 
--Unitprice, kết nhóm theo OrderID.
SELECT o.OrderID, o.OrderDate, SUM(Quantity * UnitPrice) AS Total
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate;
--2.  Liệt kê danh sách các orders  mà địa chỉ nhận hàng ở  thành phố    ‘Madrid’
--(Shipcity). Thông tin bao gồm OrderID, OrderDate, Total. Trong đó Total
--là tổng trị giá hóa đơn, kết nhóm theo OrderID. 
SELECT o.OrderID, o.OrderDate, SUM(od.Quantity * od.UnitPrice) AS Total
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.ShipCity = 'Madrid'
GROUP BY o.OrderID, o.OrderDate;
--3.  Viết các truy vấn để thống kê số lượng các hóa đơn : 
---  Trong mỗi năm. Thông tin hiển thị : Year , CoutOfOrders ?
---  Trong  mỗi  tháng/năm  .  Thông  tin  hiển  thị  :  Year  ,  Month, 
--CoutOfOrders ? Trong mỗi tháng/năm và ứng với mỗi nhân viên. Thông tin hiển 
--thị : Year, Month, EmployeeID, CoutOfOrders ?
SELECT YEAR(o.OrderDate) AS Nam, COUNT(*) AS CoutOfOrders
FROM Orders o
GROUP BY YEAR(o.OrderDate)
ORDER BY Nam;

SELECT MONTH(o.OrderDate) AS Thang, YEAR(o.OrderDate) Nam, o.EmployeeID, COUNT(*) AS CoutOfOrders
FROM Orders o
GROUP BY  MONTH(o.OrderDate), YEAR(o.OrderDate), o.EmployeeID
ORDER BY Thang, Nam;
--4.  Cho  biết  mỗi  Employee  đã  lập  bao  nhiêu  hóa  đơn.  Thông  tin  gồm 
--EmployeeID,  EmployeeName,  CountOfOrder. Trong đó CountOfOrder là 
--tổng  số  hóa  đơn  của  từng  employee.  EmployeeName  được  ghép  từ 
--LastName và FirstName.
SELECT e.EmployeeID, e.LastName + ' ' + e.FirstName AS EmployeeName, COUNT(*) AS CountOfOrder
FROM Employees e
GROUP BY e.EmployeeID, e.LastName + ' ' + e.FirstName
ORDER BY e.EmployeeID
--5.  Cho biết mỗi Employee đã lập được bao nhiêu hóa đơn, ứng với tổng tiền
--các  hóa  đơn  tương  ứng.  Thông  tin  gồm  EmployeeID,  EmployeeName, 
--CountOfOrder , Total.
SELECT e.EmployeeID, e.LastName + ' ' + e.FirstName AS EmployeeName, 
		COUNT(*) AS CountOfOrder , SUM(Quantity * UnitPrice) AS Total
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
	JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.LastName + ' ' + e.FirstName
ORDER BY e.EmployeeID
--6.  Liệt  kê  bảng  lương  của  mỗi  Employee  theo  từng  tháng  trong  năm  1996 
--gồm  EmployeeID,  EmployName,  Month_Salary,  Salary  = 
--sum(quantity*unitprice)*10%.  Được  sắp  xếp  theo  Month_Salary,  cùmg 
--Month_Salary thì sắp xếp theo Salary giảm dần.
SELECT e.EmployeeID,  e.LastName + ' ' + e.FirstName AS EmployeeName,	
		MONTH(o.OrderDate) AS Thang,  
		SUM(od.Quantity * od.UnitPrice) * 0.1 AS Salary
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
		JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY e.EmployeeID,  e.LastName + ' ' + e.FirstName, MONTH(o.OrderDate)
ORDER BY Thang, Salary DESC
--7.  Tính tổng số hóa đơn và tổng tiền các hóa đơn  của mỗi nhân viên đã bán 
--trong  tháng  3/1997,  có  tổng  tiền  >4000.  Thông  tin  gồm  EmployeeID, 
--LastName, FirstName, CountofOrder, Total.
SELECT e.EmployeeID, LastName, FirstName,COUNT(*) AS CountofOrder, SUM(od.Quantity * od.UnitPrice) AS Total
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
		JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE MONTH(o.OrderDate) = 3 AND YEAR(o.OrderDate) = 1997
GROUP BY e.EmployeeID, LastName, FirstName
HAVING SUM(od.Quantity * od.UnitPrice) > 4000
--8.Liệt kê danh sách các customer ứng với tổng số hoá đơn, tổng tiền các hoá 
--đơn, mà các hóa đơn được lập từ 31/12/1996 đến 1/1/1998 và tổng tiền các 
--hóa  đơn  >20000.  Thông  tin  được  sắp  xếp  theo  CustomerID,  cùng  mã  thì 
--sắp xếp theo tổng tiền giảm dần.
SET DATEFORMAT dmy
SELECT C.CustomerID, C.CompanyName, 
		COUNT(*) AS CountofOrder, SUM(OD.Quantity * OD.UnitPrice) AS TOTAL
FROM Customers C JOIN Orders O ON C.CustomerID = O.CustomerID
		JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE O.OrderDate BETWEEN '31/12/1996' AND '1/1/1998'
GROUP BY C.CustomerID, C.CompanyName
HAVING SUM(OD.Quantity * OD.UnitPrice) > 20000
ORDER BY C.CustomerID, TOTAL DESC
--9.  Liệt kê danh sách các customer ứng với tổng tiền của các hóa đơn ở từng 
--tháng.  Thông  tin  bao  gồm  CustomerID,  CompanyName,  Month_Year, 
--Total. Trong đó Month_year là tháng và năm lập hóa đơn, Total là tổng của 
--Unitprice* Quantity.
SELECT C.CustomerID,  C.CompanyName, 
		FORMAT(O.OrderDate, 'MM/yyyy') AS Month_year, 
		SUM(OD.Quantity * OD.UnitPrice) AS TOTAL
FROM Customers C JOIN Orders O ON C.CustomerID = O.CustomerID
		JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID,  C.CompanyName, FORMAT(O.OrderDate, 'MM/yyyy')
--10.  Liệt  kê  danh  sách  các  nhóm  hàng  (category)  có  tổng  số  lượng  tồn 
--(UnitsInStock) lớn hơn 300, đơn giá trung bình nhỏ hơn 25. Thông tin bao 
--gồm CategoryID, CategoryName, Total_UnitsInStock, Average_Unitprice.
SELECT CA.CategoryID, CA.CategoryName, 
		SUM(PR.UnitsInStock) AS Total_UnitsInStock, 
		AVG(PR.UnitPrice) AS Average_Unitprice
FROM Categories CA JOIN Products PR ON CA.CategoryID = PR.CategoryID
GROUP BY CA.CategoryID, CA.CategoryName
HAVING SUM(PR.UnitsInStock) > 300 AND AVG(PR.UnitPrice) < 25
--11.  Liệt kê danh sách các  nhóm hàng (category)  có tổng số  mặt hàng  (product)
--nhỏ  hớn  10.  Thông  tin  kết  quả  bao  gồm  CategoryID,  CategoryName, 
--CountOfProducts.  Được sắp xếp theo CategoryName, cùng  CategoryName
--thì sắp theo CountOfProducts giảm dần.
SELECT CA.CategoryID, CA.CategoryName, COUNT(*) AS CountOfProducts
FROM Categories CA JOIN Products PR ON CA.CategoryID = PR.CategoryID
GROUP BY CA.CategoryID, CA.CategoryName
HAVING COUNT(*) < 10
ORDER BY CA.CategoryName, CountOfProducts DESC
--12.  Liệt kê danh sách các  Product  bán trong  quý  1 năm 1998 có tổng số lượng 
--bán ra >200, thông tin gồm [ProductID], [ProductName], SumofQuatity 
SELECT PR.ProductID, PR.ProductName, 
    SUM(OD.Quantity) AS SumOfQuantity
FROM Products PR JOIN [Order Details] OD ON PR.ProductID = OD.ProductID
	JOIN Orders O ON OD.OrderID = O.OrderID
WHERE DATEPART(YEAR, O.OrderDate) = 1998 AND DATEPART(QUARTER, O.OrderDate) = 1
GROUP BY PR.ProductID, PR.ProductName
HAVING SUM(OD.Quantity) > 200
--13.  Cho biết Employee nào bán được nhiều tiền nhất trong tháng 7 năm 1997
SELECT TOP 1 EM.EmployeeID, EM.FirstName, MAX(OD.UnitPrice * OD.Quantity) AS Total
FROM Employees EM JOIN Orders O ON EM.EmployeeID = O.EmployeeID
	JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE DATEPART(MM, O.OrderDate) = 7 AND DATEPART(YYYY, O.OrderDate) = 1997
GROUP BY EM.EmployeeID, EM.FirstName
ORDER BY Total DESC
--14.  Liệt kê danh sách 3 Customer có nhiều đơn hàng nhất của năm 1996.
SELECT TOP 3 C.CustomerID, C.CompanyName, MAX(OD.UnitPrice * OD.Quantity) AS Total
FROM Customers C JOIN Orders O ON C.CustomerID = O.CustomerID
	JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY C.CustomerID, C.CompanyName
ORDER BY Total DESC
--15.  Liệt  kê  danh  sách  các  Products  có  tổng  số  lượng  lập  hóa  đơn  lớn  nhất.
--Thông tin gồm ProductID, ProductName, CountOfOrders.
WITH ProductOrderCounts AS (
    SELECT 
        PR.ProductID, 
        PR.ProductName, 
        COUNT(*) AS CountOfOrders
    FROM Products PR
    JOIN [Order Details] OD ON PR.ProductID = OD.ProductID
    GROUP BY PR.ProductID, PR.ProductName
)
SELECT *
FROM ProductOrderCounts
WHERE CountOfOrders = (
    SELECT MAX(CountOfOrders) FROM ProductOrderCounts
)
