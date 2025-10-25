--1.  Liệt kê  các product  có đơn giá  mua  lớn hơn đơn giá  mua  trung bình  của 
--tất cả các product.
SELECT *
FROM Products P0
WHERE EXISTS (
	SELECT *
	FROM Products P1
	HAVING P0.UnitPrice > AVG(P1.UnitPrice)
);
--2.  Liệt kê các product có đơn giá mua lớn hơn đơn giá mua nhỏ nhất của tất 
--cả các product. 
SELECT *
FROM Products
WHERE UnitPrice > (
	SELECT MIN(UnitPrice)
	FROM Products
)
--3.  Liệt kê các product có đơn giá  bán  lớn hơn đơn giá  bán  trung bình của 
--các  product.  Thông  tin  gồm  ProductID,  ProductName,  OrderID, 
--Orderdate,  Unitprice .
SELECT P.ProductID, OD.OrderID, O.OrderDate, OD.UnitPrice
FROM Products P JOIN [Order Details] OD ON P.ProductID = OD.ProductID
	JOIN Orders O ON OD.OrderID = O.OrderID
WHERE OD.UnitPrice > (
	SELECT AVG(UnitPrice)
	FROM [Order Details]
)
--4.  Liệt kê các  product có đơn giá  bán  lớn hơn đơn giá  bán  trung bình của 
--các product có ProductName bắt đầu là ‘N’.
SELECT *
FROM Products
WHERE UnitPrice > (
	SELECT AVG(UnitPrice)
	FROM Products
	WHERE ProductName LIKE ('N%')
)
--5.  Cho biết  những sản phẩm có tên  bắt đầu bằng  ‘T’  và  có  đơn giá bán  lớn 
--hơn  đơn giá bán của  (tất cả) những  sản phẩm có tên bắt đầu bằng chữ 
--‘V’.
SELECT *
FROM Products P LEFT JOIN [Order Details] OD ON P.ProductID = OD.ProductID
WHERE P.ProductName LIKE ('T%') AND OD.UnitPrice > ALL (
	SELECT UnitPrice
	FROM [Order Details]
	WHERE P.ProductName LIKE ('V%')
)
--6.  Cho biết sản phẩm nào có đơn giá bán cao nhất trong số những sản phẩm 
--có đơn vị tính có chứa chữ ‘box’ .
SELECT *
FROM Products P LEFT JOIN [Order Details] OD ON P.ProductID = OD.ProductID
WHERE  QuantityPerUnit LIKE ('%box%') AND OD.UnitPrice >= ALL (
	SELECT OD.UnitPrice
	FROM [Order Details] OD JOIN Products P ON P.ProductID = OD.ProductID
	WHERE QuantityPerUnit LIKE ('%box%')
)
--7.  Liệt kê các product  có  tổng  số lượng bán  (Quantity)  trong năm 1998  lớn 
--hơn tổng số lượng bán trong năm 1998 của mặt hàng có mã 71
SELECT P.ProductID, P.ProductName, SUM(OD.Quantity) AS TotalQuantity
FROM Products P 
LEFT JOIN [Order Details] OD ON P.ProductID = OD.ProductID
LEFT JOIN Orders O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = 1998
GROUP BY P.ProductID, P.ProductName
HAVING SUM(OD.Quantity) > (
    SELECT SUM(OD.Quantity)
    FROM Products P 
    LEFT JOIN [Order Details] OD ON P.ProductID = OD.ProductID
    LEFT JOIN Orders O ON OD.OrderID = O.OrderID
    WHERE YEAR(O.OrderDate) = 1998 AND P.ProductID = 71
)
--8.  Thực hiện :
---  Thống kê  tổng số lượng bán  ứng với  mỗi  mặt hàng thuộc nhóm 
--hàng  có  CategoryID  là  4.  Thông  tin  :  ProductID,  QuantityTotal 
--(tập A) 
---  Thống kê tổng số lượng bán  ứng với  mỗi mặt hàng thuộc nhóm 
--hàng khác 4 . Thông tin : ProductID, QuantityTotal (tập B)
---  Dựa vào 2 truy vấn trên : Liệt kê  danh sách các mặt hàng trong 
--tập A có QuantityTotal lớn hơn tất cả QuantityTotal của tập B
SELECT P.ProductID, SUM(OD.Quantity) AS QuantityTotal
FROM Products P 
LEFT JOIN [Order Details] OD ON P.ProductID = OD.ProductID
LEFT JOIN Orders O ON OD.OrderID = O.OrderID 
WHERE P.CategoryID = 4
GROUP BY P.ProductID
HAVING SUM(OD.Quantity) > ALL (
    SELECT SUM(OD.Quantity)
    FROM Products P 
    LEFT JOIN [Order Details] OD ON P.ProductID = OD.ProductID
    LEFT JOIN Orders O ON OD.OrderID = O.OrderID 
    WHERE P.CategoryID != 4
    GROUP BY P.ProductID
)
--9.  Danh sách các Product  có tổng số lượng  bán  được lớn nhất trong năm 
--1998
--Lưu ý : Có nhiều phương án thực hiện các truy vấn sau (dùng JOIN hoặc 
--subquery ). Hãy đưa ra phương án sử dụng subquery.
SELECT P.ProductID, P.ProductName, SUM(OD.Quantity) AS TotalQuantity
FROM Products P 
LEFT JOIN [Order Details] OD ON P.ProductID = OD.ProductID
LEFT JOIN Orders O ON OD.OrderID = O.OrderID 
WHERE YEAR(O.OrderDate) = 1998
GROUP BY P.ProductID, P.ProductName
HAVING SUM(OD.Quantity) >= ALL (
    SELECT SUM(OD2.Quantity)
    FROM [Order Details] OD2
    JOIN Orders O2 ON OD2.OrderID = O2.OrderID
    WHERE YEAR(O2.OrderDate) = 1998
    GROUP BY OD2.ProductID
);
--10.  Danh sách các products đã có khách hàng mua hàng (tức là ProductID có 
--trong  [Order  Details]).  Thông  tin  bao  gồm  ProductID,  ProductName, 
--Unitprice
SELECT P.ProductID, P.ProductName, P.UnitPrice
FROM Products P
WHERE P.ProductID IN (
    SELECT DISTINCT OD.ProductID
    FROM [Order Details] OD
)
--11.  Danh sách các hóa đơn của những  khách hàng  ở thành phố LonDon và 
--Madrid.
SELECT *
FROM [Order Details] OD
JOIN Orders O ON OD.OrderID = O.OrderID
WHERE OD.OrderID IN (
	SELECT O.OrderID
	FROM Orders O JOIN Customers C ON O.CustomerID = C.CustomerID
	WHERE City IN ('London', 'Madrid')
)
--12.  Liệt kê các sản phẩm có trên 20 đơn hàng trong  quí 3  năm 1998, thông 
--tin gồm ProductID, ProductName.
--13.  Liệt kê danh sách các sản phẩm chưa bán được trong tháng 6 năm 1996
--14.  Liệt kê danh sách các Employes không lập hóa đơn vào ngày hôm nay
--15.  Liệt kê danh sách các Customers chưa mua hàng trong năm 1997
--16.  Tìm tất cả các Customers mua các sản phẩm có tên bắt đầu bằng chữ T 
--trong tháng 7 năm 1997
--17.  Liệt kê danh sách các khách hàng mua các hóa đơn mà các hóa đơn này 
--chỉ mua những sản phẩm có mã >=3  
--18.  Tìm các Customer chưa từng lập  hóa đơn (viết bằng ba cách: dùng NOT 
--EXISTS, dùng LEFT JOIN, dùng NOT IN )
--19.  Bạn hãy mô tả kết quả của các câu truy vấn sau ?
--Select ProductID, ProductName, UnitPrice  From [Products]
--Where Unitprice>ALL (Select Unitprice from [Products] where 
--ProductName like ‘N%’)
--Select ProductId, ProductName, UnitPrice From [Products]
--Where Unitprice>ANY (Select Unitprice from [Products] where 
--ProductName like ‘N%’)
--Select ProductId, ProductName, UnitPrice from [Products]
--Where Unitprice=ANY (Select Unitprice from [Products] where
--ProductName like ‘N%’)
--Select ProductId, ProductName, UnitPrice from [Products]
--Where ProductName like ‘N%’ and 
--Unitprice>=ALL (Select Unitprice from [Products] where
--ProductName like ‘N%’)