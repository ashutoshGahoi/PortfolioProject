INSERT INTO `online retail analysis`.online_analysis_bi(
InvoiceNo, CustomerID, StockCode, Product_Category, Description, Quantity, UnitPrice, Country, InvoiceDate, Sales, add_InvoiceNo, add_CustomerID, Add_Qty, Add_fee, Add_sales
)
SELECT
pos.InvoiceNo, pos.CustomerID, pos.StockCode, pc.Product_Category, pos.Description, pos.Quantity, pos.UnitPrice, pos.Country, pos.InvoiceDate, pos.Sales,
ad.InvoiceNo AS add_InvoiceNo, 
ad.CustomerID AS add_CustomerID, 
ad.Add_Qty AS Add_Qty, 
ad.Add_fee AS Add_fee,
((Add_Qty*UnitPrice)+Add_fee) AS Add_sales
FROM `online retail analysis`.products_online_sales pos
LEFT JOIN `online retail analysis`.product_category pc
ON pos.StockCode = pc.StockCode AND pos.Description = pc.Description
LEFT JOIN `online retail analysis`.additional_online_sales ad
ON pos.InvoiceNo = ad.InvoiceNo AND pos.CustomerID = ad.CustomerID;
