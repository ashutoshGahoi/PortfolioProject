CREATE TABLE `online retail analysis`.online_analysis_bi(
id INT AUTO_INCREMENT PRIMARY KEY,
InvoiceNo bigint, 
CustomerID varchar(265), 
StockCode varchar(265), 
Product_Category varchar(500),
Description varchar(1000), 
Quantity int, 
UnitPrice float, 
Country varchar(265), 
InvoiceDate date, 
Sales float,
add_InvoiceNo bigint, 
add_CustomerID varchar(265), 
Add_Qty int, 
Add_fee float,
Add_sales float
);