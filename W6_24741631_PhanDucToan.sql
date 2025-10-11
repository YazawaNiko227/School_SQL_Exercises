--1.  Hiển  thị  thông  tin  về  hóa  đơn  có  mã  ‘10248’,  bao  gồm:  OrderID, 
--OrderDate,  CustomerID,  EmployeeID,  ProductID,  Quantity,  Unitprice, 
--Discount.
SELECT o.OrderID, o.OrderDate,  o.CustomerID,  o.EmployeeID, 
		 ProductID,  Quantity,  Unitprice, Discount
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.OrderID = 10248
--2.  Liệt  kê  các  khách  hàng  có  lập  hóa  đơn  trong  tháng  7/1997  và  9/1997. 
--Thông  tin  gồm  CustomerID,  CompanyName,  Address,  OrderID, 
--Orderdate. Được sắp xếp theo CustomerID, cùng CustomerID thì sắp xếp 
--theo OrderDate giảm dần.
SELECT c.CustomerID,  c.CompanyName,  c.Address,  o.OrderID, o.Orderdate
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE YEAR(O.OrderDate) = 1997 AND (MONTH(o.OrderDate) = 7 OR MONTH(o.OrderDate) = 9)
ORDER BY OrderDate DESC
--3.  Liệt kê danh sách các  mặt hàng  xuất bán vào ngày 19/7/1996. Thông tin 
--gồm : ProductID, ProductName, OrderID, OrderDate, Quantity.
SET DATEFORMAT dmy
SELECT p.ProductID, p.ProductName, od.OrderID, o.OrderDate, od.Quantity
FROM Orders o JOIN [Order Details] od on o.OrderID = od.OrderID
	 JOIN Products p on p.ProductID = od.ProductID
WHERE o.OrderDate = '19/7/1996'
--4.  Liệt kê danh sách các mặt hàng từ nhà cung cấp (supplier) có mã 1,3,6 và
--đã  xuất  bán  trong  quý  2  năm  1997.  Thông  tin  gồm  :  ProductID, 
--ProductName,  SupplierID,  OrderID,  Quantity.  Được  sắp  xếp  theo  mã 
--nhà  cung  cấp  (SupplierID),  cùng  mã  nhà  cung  cấp  thì  sắp  xếp  theo 
--ProductID.
SELECT DATEPART(QQ,o.OrderDate), p.ProductID, p.ProductName,  SupplierID,  od.OrderID,  od.Quantity
FROM Orders o JOIN [Order Details] od ON o.OrderID= od.OrderID
	 JOIN Products p ON p.ProductID =od.ProductID
WHERE SupplierID IN(1, 3, 6) AND DATEPART(QQ,o.OrderDate) = 2 AND YEAR(o.OrderDate) = 1997
--5.  Liệt kê danh sách các mặt hàng có đơn giá bán bằng đơn giá mua.
SELECT p.ProductName
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE P.UnitPrice = OD.UnitPrice
--6.  Danh sách các  mặt hàng  bán trong ngày thứ 7 và chủ nhật của tháng 12 
--năm 1996, thông tin gồm ProductID, ProductName, OrderID, OrderDate, 
--CustomerID, Unitprice, Quantity, ToTal= Quantity*UnitPrice. Được sắp 
--xếp theo ProductID, cùng ProductID thì sắp xếp theo Quantity giảm dần.
SELECT DATENAME(DW, o.OrderDate), p.ProductID, ProductName, o.OrderID, OrderDate, CustomerID, od.Unitprice, Quantity, ToTal = Quantity * od.UnitPrice
FROM Orders o JOIN [Order Details] od ON o.OrderID= od.OrderID
	 JOIN Products p ON p.ProductID =od.ProductID
WHERE DATENAME(DW, o.OrderDate) NOT IN ('SATURDAY', 'SUNDAY') 
	  AND MONTH(o.OrderDate) = 12 AND YEAR(o.OrderDate) = 1996
ORDER BY p.ProductID DESC
--7.  Liệt kê danh sách các nhân viên  đã lập hóa đơn trong tháng 7 của năm 
--1996.  Thông  tin  gồm  :  EmployeeID,  EmployeeName,  OrderID, 
--Orderdate.
SELECT e.EmployeeID, EmployeeName = e.LastName + ' ' + e.FirstName, OrderID, Orderdate
FROM Orders o JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE MONTH(o.OrderDate) = 7 AND YEAR(o.OrderDate) = 1996
--8.  Liệt kê danh sách các hóa đơn do nhân viên có Lastname  là  ‘Fuller’  lập.
--Thông tin gồm : OrderID, Orderdate, ProductID, Quantity, Unitprice.
SELECT o.OrderID, Orderdate, ProductID, Quantity, Unitprice
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
	 JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE e.LastName = 'Fuller'
--9.  Liệt kê chi tiết bán hàng của mỗi nhân viên theo từng hóa đơn  trong năm 
--1996. Thông tin  gồm:  EmployeeID, EmployName, OrderID, Orderdate, 
--ProductID, quantity, unitprice, ToTalLine=quantity*unitprice. 
SELECT e.EmployeeID, EmployName = e.LastName + ' ' + e.FirstName, o.OrderID, Orderdate,ProductID, quantity, unitprice, ToTalLine = quantity * unitprice
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
	 JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 1996
--10.  Danh sách các đơn hàng sẽ được giao trong các thứ 7 của tháng 12 năm 
--1996. 
SELECT *
FROM Orders o
WHERE DATENAME(DW, o.ShippedDate) != 'SATURDAY' AND MONTH(o.ShippedDate) = 12 AND YEAR(o.ShippedDate) = 1996
--11.  Liệt  kê  danh  sách  các  nhân  viên  chưa  lập  hóa  đơn  (dùng  LEFT 
--JOIN/RIGHT JOIN).
SELECT e.EmployeeID, e.LastName, e.FirstName
FROM Employees e LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
WHERE o.OrderID IS NULL;
--12.  Liệt  kê  danh  sách  các  sản  phẩm  chưa  bán  được  (dùng  LEFT 
--JOIN/RIGHT JOIN).
SELECT p.ProductID, p.ProductName
FROM Products p LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL
--13.  Liệt kê danh sách các khách hàng chưa mua hàng lần nào (dùng LEFT 
--JOIN/RIGHT JOIN)
SELECT c.CustomerID, c.CompanyName
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL