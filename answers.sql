# SQL Solutions for Normalization

## Question 1
SELECT 
    OrderID,
    CustomerName,
    TRIM(Product.value) AS Product,
    1 AS Quantity -- Assuming default quantity of 1 for each product
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

-- Create OrderItems table
CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
# SQL Solutions for Normalization

## Question 1: Achieving 1NF

To transform the `ProductDetail` table into 1NF, I'll split the comma-separated products into separate rows:

```sql
-- Create a new normalized table
CREATE TABLE OrderDetails_1NF AS
SELECT 
    OrderID,
    CustomerName,
    TRIM(Product.value) AS Product,
    1 AS Quantity -- Assuming default quantity of 1 for each product
FROM 
    ProductDetail
CROSS APPLY 
    STRING_SPLIT(Products, ',') AS Product;
```

If your SQL dialect doesn't support STRING_SPLIT (like MySQL), you could use:

```sql
-- For MySQL
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

To remove partial dependencies and achieve 2NF, I'll split the table into two: one for orders and one for order items:

```sql
-- Create Orders table (removes partial dependency)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Create OrderItems table
CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Populate Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Populate OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
```

This design ensures:
1. The `Orders` table contains order information where all non-key attributes depend on the entire primary key (OrderID)
2. The `OrderItems` table contains the product details that depend on both OrderID and Product (with a surrogate key OrderItemID as primary key)
-- Populate Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Populate OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantityduct, QuaerDetailsntity
(with a surrogate key OrderItemID as prntity)
SELECT OrderID, Product, Quantity
FROM Ordimary key
