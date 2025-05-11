# SQL Solutions for Normalization

## Question 1
SELECT 
    OrderID,
    CustomerName,
    TRIM(Product.value) AS Product,
    1 AS Quantity
FROM 
    ProductDetail
CROSS APPLY 
    STRING_SPLIT(Products, ',') AS Product;
```


CREATE TABLE OrderDetails_1NF AS
SELECT 
    OrderID,
    CustomerName,
    SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.digit+1), ',', -1) AS Product,
    1 AS Quantity
FROM 
    ProductDetail
JOIN 
    (SELECT 0 AS digit UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) AS n
WHERE 
    LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) >= n.digit
ORDER BY 
    OrderID, n.digit;
```

## Question 2: Achieving 2NF
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

   
