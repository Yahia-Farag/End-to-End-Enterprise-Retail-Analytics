USE Data_Detective;

SELECT COUNT(*) AS Total_Orders
FROM data_detective_sales_training;

SELECT COUNT(DISTINCT Branch) AS Count_Branches
FROM data_detective_sales_training;

SELECT COUNT(DISTINCT Category) AS Count_Categories
FROM data_detective_sales_training;

SELECT COUNT(DISTINCT Product) AS Count_Products
FROM data_detective_sales_training;

SELECT Sales_Channel, COUNT(*) AS Count_Sales_Channel
FROM data_detective_sales_training
GROUP BY Sales_Channel;

SELECT customer_type, COUNT(*) AS Customer_Count
FROM data_detective_sales_training
GROUP BY customer_type;

SELECT ROUND(SUM(Net_Revenue),0) AS Total_Revenue
FROM data_detective_sales_training;

SELECT ROUND(SUM(Profit),0) AS Total_Revenue
FROM data_detective_sales_training;

SELECT TOP 1 Branch,
ROUND(SUM(Net_Revenue),0) AS Total_Revenue
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Total_Revenue DESC;

SELECT TOP 1 Product,
ROUND(SUM(Net_Revenue),0) AS Total_Revenue
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Total_Revenue DESC;

SELECT TOP 1 Branch,
ROUND(SUM(Profit),0) AS Total_Profit
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Total_Profit DESC;

SELECT TOP 1 Product,
ROUND(SUM(Profit),0) AS Total_Profit
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Total_Profit DESC;

SELECT TOP 1 Category,
SUM(Quantity * Unit_Price) AS Total_Sales
FROM data_detective_sales_training
GROUP BY Category
ORDER BY Total_Sales DESC;

SELECT TOP 1 Salesperson,
ROUND(SUM(Profit),0) AS Total_Profit
FROM data_detective_sales_training
GROUP BY Salesperson
ORDER BY Total_Profit DESC;

SELECT ROUND(AVG(Discount_Pct),2) AS Avg_Discount_Pct
FROM data_detective_sales_training;

SELECT TOP 1 Product,
ROUND(AVG(Discount_Pct),2) AS Avg_Discount_Pct
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Avg_Discount_Pct DESC;

SELECT PRODUCT,
ROUND(AVG(Discount_Pct),2) AS Avg_Discount_Pct,
SUM(Quantity * Unit_Price) AS Total_Sales
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Avg_Discount_Pct DESC;

SELECT COUNT(*) AS Count_Orders_Greeter_Than_15
FROM data_detective_sales_training
WHERE Discount_Pct > 15.00;

SELECT TOP 1 Branch,
ROUND(AVG(Discount_Pct),2) AS Avg_Discount_Pct
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Avg_Discount_Pct DESC;

SELECT TOP 1 Product,
ROUND((SUM(Profit) / SUM(Net_Revenue)) * 100,2) AS Profit_Margin
FROM data_detective_sales_training
WHERE Profit <> 0 AND Net_Revenue <> 0
GROUP BY Product
ORDER BY Profit_Margin ASC;

SELECT Sales_Channel,
ROUND(SUM(Net_Revenue),0) AS Total_Net_Revenue
FROM data_detective_sales_training
GROUP BY Sales_Channel
ORDER BY Total_Net_Revenue DESC;

SELECT Sales_Channel,
ROUND(SUM(Profit),0) AS Total_Profit
FROM data_detective_sales_training
GROUP BY Sales_Channel
ORDER BY Total_Profit DESC;

SELECT Customer_Type,
SUM(Net_Revenue) AS Total_Net_Revenue
FROM data_detective_sales_training
GROUP BY Customer_Type
ORDER BY Total_Net_Revenue DESC;

SELECT Branch,
CAST(SUM(CASE WHEN Customer_Type ='Returning' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100
AS Returning_Customer_Percentage
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Returning_Customer_Percentage DESC;

WITH OrderTotal AS (
SELECT Order_ID,Customer_Type,SUM(Quantity * Unit_Price) AS Order_Total
FROM data_detective_sales_training
GROUP BY Order_ID,Customer_Type
)
SELECT Customer_Type,AVG(Order_Total) AS Avg_Order_Value
FROM OrderTotal
GROUP BY Customer_Type
ORDER BY Avg_Order_Value DESC;

SELECT CAST(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS Pct_Returned
FROM data_detective_sales_training;

SELECT Branch,
CAST(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS Pct_Returned
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Pct_Returned DESC;

SELECT TOP 1 Product,
SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) AS Count_Returned
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Count_Returned DESC;

SELECT AVG(Delivery_Days) AS Avg_Delivery_Days
FROM data_detective_sales_training;

SELECT TOP 1 Branch,
AVG(Delivery_Days) AS Avg_Delivery_Days
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Avg_Delivery_Days DESC;

SELECT TOP 1 Branch,
CAST(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS Pct_Returned,
SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) AS Total_Returned,
AVG(Delivery_Days) AS Avg_Delivery_Days
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Avg_Delivery_Days DESC;

SELECT * FROM data_detective_sales_training;

SELECT Branch,
ROUND(SUM(Net_Revenue),0) AS Total_Revenue,
SUM(Quantity * Unit_Price) AS Total_Sales,
SUM(Quantity) AS Total_Qty_Sold,
ROUND(AVG(CAST(Delivery_Days AS FLOAT)),0) AS Avg_Delivery_Days,
ROUND(CAST(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END)AS FLOAT) / COUNT(*) * 100,0) AS Returned_Pct,
ROUND(CAST(SUM(CASE WHEN Customer_Type = 'Returning' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100,2) AS Returning_Customer_Pct
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Total_Revenue ASC;

SELECT Product,
ROUND(SUM(Net_Revenue),0) AS Total_Revenue,
ROUND(SUM(Profit),0) AS Total_Profit,
SUM(Quantity) AS Total_Qty_Sold,
ROUND(CAST(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END)AS FLOAT) / COUNT(*) * 100,2) AS Returned_Pct,
MAX(Unit_Price) AS Highest_Price
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Total_Profit ASC;

SELECT Product,
ROUND(MAX(Discount_Pct),2) AS Highest_Discount_Pct,
ROUND(SUM(Profit),0) AS Total_Profit,
ROUND(SUM(Net_Revenue),0) AS Total_Revenue
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Highest_Discount_Pct DESC;

SELECT Sales_Channel,
ROUND(SUM(Profit),0) AS Total_Profit,
ROUND(SUM(Net_Revenue),0) AS Total_Revenue,
SUM(Quantity) AS Total_Qty_Sold,
ROUND(CAST(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END)AS FLOAT) / COUNT(*) * 100,2) AS Returned_Pct
FROM data_detective_sales_training
GROUP BY Sales_Channel;

