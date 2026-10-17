-- Select and use the target database
USE Data_Detective;


-- ===============================================================================
-- 📌 PART 1: UNDERSTAND THE DATA (EXPLORATION & COUNTS)
-- ===============================================================================

-- 1. Total number of orders in the dataset
SELECT COUNT(*) AS Total_Orders
FROM data_detective_sales_training;

-- 2. Count of unique branches
SELECT COUNT(DISTINCT Branch) AS Count_Branches
FROM data_detective_sales_training;

-- 3. Count of unique product categories
SELECT COUNT(DISTINCT Category) AS Count_Categories
FROM data_detective_sales_training;

-- 4. Count of unique products
SELECT COUNT(DISTINCT Product) AS Count_Products
FROM data_detective_sales_training;

-- 5. Order volume breakdown by sales channel
SELECT Sales_Channel,
       COUNT(*) AS Count_Sales_Channel
FROM data_detective_sales_training
GROUP BY Sales_Channel;

-- 6. Customer distribution by customer type
SELECT customer_type,
       COUNT(*) AS Customer_Count
FROM data_detective_sales_training
GROUP BY customer_type;


-- ===============================================================================
-- 💰 PART 2: SALES PERFORMANCE & TOP PERFORMERS
-- ===============================================================================

-- 7. Total Net Revenue across all orders
SELECT ROUND(SUM(Net_Revenue),0) AS Total_Revenue
FROM data_detective_sales_training;

-- 8. Total Profit across all orders
SELECT ROUND(SUM(Profit),0) AS Total_Revenue
FROM data_detective_sales_training;

-- 9. Top-performing branch by total net revenue
SELECT TOP 1 Branch,
       ROUND(SUM(Net_Revenue),0) AS Total_Revenue
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Total_Revenue DESC;

-- 10. Top-performing product by total net revenue
SELECT TOP 1 Product,
       ROUND(SUM(Net_Revenue),0) AS Total_Revenue
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Total_Revenue DESC;

-- 11. Top branch generating the highest overall profit
SELECT TOP 1 Branch,
       ROUND(SUM(Profit),0) AS Total_Profit
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Total_Profit DESC;

-- 12. Top product generating the highest overall profit
SELECT TOP 1 Product,
       ROUND(SUM(Profit),0) AS Total_Profit
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Total_Profit DESC;

-- 13. Top product category by gross sales (Quantity * Unit Price)
SELECT TOP 1 Category,
       SUM(Quantity * Unit_Price) AS Total_Sales
FROM data_detective_sales_training
GROUP BY Category
ORDER BY Total_Sales DESC;

-- 14. Top sales representative by total profit generated
SELECT TOP 1 Salesperson,
       ROUND(SUM(Profit),0) AS Total_Profit
FROM data_detective_sales_training
GROUP BY Salesperson
ORDER BY Total_Profit DESC;


-- ===============================================================================
-- 🏷️ PART 3: DISCOUNTS & PROFITABILITY ANALYSIS
-- ===============================================================================

-- 15. Average discount percentage across all sales
SELECT ROUND(AVG(Discount_Pct),2) AS Avg_Discount_Pct
FROM data_detective_sales_training;

-- 16. Product with the highest average discount percentage
SELECT TOP 1 Product,
       ROUND(AVG(Discount_Pct),2) AS Avg_Discount_Pct
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Avg_Discount_Pct DESC;

-- 17. Average discount and total gross sales breakdown by product
SELECT PRODUCT,
       ROUND(AVG(Discount_Pct),2) AS Avg_Discount_Pct,
       SUM(Quantity * Unit_Price) AS Total_Sales
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Avg_Discount_Pct DESC;

-- 18. Count of high-discount orders (Discount > 15%)
SELECT COUNT(*) AS Count_Orders_Greeter_Than_15
FROM data_detective_sales_training
WHERE Discount_Pct > 15.00;

-- 19. Branch with the highest average discount percentage applied
SELECT TOP 1 Branch,
       ROUND(AVG(Discount_Pct),2) AS Avg_Discount_Pct
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Avg_Discount_Pct DESC;

-- 20. Product with the lowest profit margin %
SELECT TOP 1 Product,
       ROUND((SUM(Profit) / SUM(Net_Revenue)) * 100,2) AS Profit_Margin
FROM data_detective_sales_training
WHERE Profit <> 0 AND Net_Revenue <> 0
GROUP BY Product
ORDER BY Profit_Margin ASC;


-- ===============================================================================
-- 👥 PART 4: CUSTOMERS & SALES CHANNELS ANALYSIS
-- ===============================================================================

-- 21. Net Revenue distribution across sales channels
SELECT Sales_Channel,
       ROUND(SUM(Net_Revenue),0) AS Total_Net_Revenue
FROM data_detective_sales_training
GROUP BY Sales_Channel
ORDER BY Total_Net_Revenue DESC;

-- 22. Profit distribution across sales channels
SELECT Sales_Channel,
       ROUND(SUM(Profit),0) AS Total_Profit
FROM data_detective_sales_training
GROUP BY Sales_Channel
ORDER BY Total_Profit DESC;

-- 23. Net Revenue generation comparison between customer types
SELECT Customer_Type,
       SUM(Net_Revenue) AS Total_Net_Revenue
FROM data_detective_sales_training
GROUP BY Customer_Type
ORDER BY Total_Net_Revenue DESC;

-- 24. Returning customer percentage by branch
SELECT Branch,
       CAST(SUM(CASE WHEN Customer_Type ='Returning' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100
       AS Returning_Customer_Percentage
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Returning_Customer_Percentage DESC;

-- 25. Average Order Value (AOV) by customer type
WITH OrderTotal AS (
    SELECT Order_ID,
           Customer_Type,
           SUM(Quantity * Unit_Price) AS Order_Total
    FROM data_detective_sales_training
    GROUP BY Order_ID, Customer_Type
)
SELECT Customer_Type,
       AVG(Order_Total) AS Avg_Order_Value
FROM OrderTotal
GROUP BY Customer_Type
ORDER BY Avg_Order_Value DESC;


-- ===============================================================================
-- 🚚 PART 5: RETURNS & LOGISTICS PERFORMANCE
-- ===============================================================================

-- 26. Overall return rate percentage across all orders
SELECT CAST(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS Pct_Returned
FROM data_detective_sales_training;

-- 27. Return rate percentage breakdown by branch
SELECT Branch,
       CAST(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS Pct_Returned
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Pct_Returned DESC;

-- 28. Product with the highest number of returned units
SELECT TOP 1 Product,
       SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) AS Count_Returned
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Count_Returned DESC;

-- 29. Average delivery time (in days) across all shipments
SELECT AVG(Delivery_Days) AS Avg_Delivery_Days
FROM data_detective_sales_training;

-- 30. Branch with the longest average delivery time
SELECT TOP 1 Branch,
       AVG(Delivery_Days) AS Avg_Delivery_Days
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Avg_Delivery_Days DESC;

-- 31. Combined logistics & quality metrics for the slowest delivery branch
SELECT TOP 1 Branch,
       CAST(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS Pct_Returned,
       SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END) AS Total_Returned,
       AVG(Delivery_Days) AS Avg_Delivery_Days
FROM data_detective_sales_training
GROUP BY Branch
ORDER BY Avg_Delivery_Days DESC;


-- ===============================================================================
-- 🎯 PART 6: STRATEGIC BUSINESS QUESTIONS & DETAILED DEEP DIVES
-- ===============================================================================

-- Quick sanity check: View all records
SELECT * FROM data_detective_sales_training;

-- 32. Branch performance deep dive (Revenue, Quantity, Delivery, Returns, Retention)
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

-- 33. Product performance deep dive (Revenue, Profit, Quantity, Return Rate, Pricing)
SELECT Product,
       ROUND(SUM(Net_Revenue),0) AS Total_Revenue,
       ROUND(SUM(Profit),0) AS Total_Profit,
       SUM(Quantity) AS Total_Qty_Sold,
       ROUND(CAST(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END)AS FLOAT) / COUNT(*) * 100,2) AS Returned_Pct,
       MAX(Unit_Price) AS Highest_Price
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Total_Profit ASC;

-- 34. Discount impact analysis on product profitability
SELECT Product,
       ROUND(MAX(Discount_Pct),2) AS Highest_Discount_Pct,
       ROUND(SUM(Profit),0) AS Total_Profit,
       ROUND(SUM(Net_Revenue),0) AS Total_Revenue
FROM data_detective_sales_training
GROUP BY Product
ORDER BY Highest_Discount_Pct DESC;

-- 35. Sales Channel comparative evaluation (Profit, Revenue, Volume, Return Rate)
SELECT Sales_Channel,
       ROUND(SUM(Profit),0) AS Total_Profit,
       ROUND(SUM(Net_Revenue),0) AS Total_Revenue,
       SUM(Quantity) AS Total_Qty_Sold,
       ROUND(CAST(SUM(CASE WHEN Returned = 1 THEN 1 ELSE 0 END)AS FLOAT) / COUNT(*) * 100,2) AS Returned_Pct
FROM data_detective_sales_training
GROUP BY Sales_Channel;
