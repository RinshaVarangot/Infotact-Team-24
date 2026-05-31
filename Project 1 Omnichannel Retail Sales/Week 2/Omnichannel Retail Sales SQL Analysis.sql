CREATE DATABASE  IF NOT EXISTS Omnichannel_Retail_Sales;

use Omnichannel_Retail_Sales;

--Superstore SQL Analysis Queries;
--1. Total Sales, Profit and Orders;

SELECT COUNT(DISTINCT Order_ID) AS Total_Orders,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM Cleaned_SuperStore_Dataset;


--2. Sales by Category;

SELECT Category,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM Cleaned_SuperStore_Dataset
GROUP BY Category
ORDER BY Total_Sales DESC;

--3. Sales by Sub-Category;

SELECT Sub_Category,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM Cleaned_SuperStore_Dataset
GROUP BY Sub_Category
ORDER BY Total_Sales DESC;

--4. Top 10 Products by Sales;

SELECT Product_Name,
       ROUND(SUM(Sales),2) AS Sales
FROM Cleaned_SuperStore_Dataset
GROUP BY Product_Name
ORDER BY Sales DESC
LIMIT 10;

--5. Top 10 Products by Profit;

SELECT Product_Name,
       ROUND(SUM(Profit),2) AS Profit
FROM Cleaned_SuperStore_Dataset
GROUP BY Product_Name
ORDER BY Profit DESC
LIMIT 10;

--6. Loss Making Products;

SELECT Product_Name,
       ROUND(SUM(Profit),2) AS Total_Loss
FROM Cleaned_SuperStore_Dataset
GROUP BY Product_Name
HAVING SUM(Profit) < 0
ORDER BY Total_Loss;

--7. Regional Performance;

SELECT Region,
       ROUND(SUM(Sales),2) AS Sales,
       ROUND(SUM(Profit),2) AS Profit
FROM Cleaned_SuperStore_Dataset
GROUP BY Region
ORDER BY Sales DESC;

--9. State-wise Sales;

SELECT
    State,
    ROUND(SUM(Sales),2) AS Sales
FROM Cleaned_SuperStore_Dataset
GROUP BY State
ORDER BY Sales DESC;

--10. Top 10 Customers;

SELECT Customer_Name,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM Cleaned_SuperStore_Dataset
GROUP BY Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

--11. Customer Segment Analysis;

SELECT Segment,
       COUNT(DISTINCT Customer_ID) AS Customers,
       ROUND(SUM(Sales),2) AS Sales,
       ROUND(SUM(Profit),2) AS Profit
FROM Cleaned_SuperStore_Dataset
GROUP BY Segment;

--12. Average Order Value;

SELECT ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID),2) AS Avg_Order_Value
FROM Cleaned_SuperStore_Dataset;

--13. Shipping Mode Analysis;

SELECT Ship_Mode,
       ROUND(SUM(Sales),2) AS Sales,
       ROUND(SUM(Profit),2) AS Profit
FROM Cleaned_SuperStore_Dataset
GROUP BY Ship_Mode;

--15. Discount Impact on Profit;

SELECT
    Discount,
    ROUND(SUM(Sales),2) AS Sales,
    ROUND(SUM(Profit),2) AS Profit
FROM Cleaned_SuperStore_Dataset
GROUP BY Discount
ORDER BY Discount;

--16. Monthly Sales Trend;

SELECT
    YEAR(Order_Date) AS Year_,
    MONTH(Order_Date) AS Month_,
    ROUND(SUM(Sales),2) AS Sales
FROM Cleaned_SuperStore_Dataset
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Year_, Month_;

--17. Yearly Sales Growth;

SELECT
    YEAR(Order_Date) AS Year_,
    ROUND(SUM(Sales),2) AS Sales
FROM Cleaned_SuperStore_Dataset
GROUP BY YEAR(Order_Date)
ORDER BY Year_;

--18. Category Contribution %;

SELECT
    Category,
    ROUND(SUM(Sales),2) AS Sales,
    ROUND(
        100 * SUM(Sales) /
        (SELECT SUM(Sales) FROM Cleaned_SuperStore_Dataset),2
    ) AS Contribution_Percentage
FROM Cleaned_SuperStore_Dataset
GROUP BY Category
ORDER BY Sales DESC;

--19. Profit Margin Analysis;

SELECT
    Category,
    ROUND(SUM(Sales),2) AS Sales,
    ROUND(SUM(Profit),2) AS Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100,2) AS Profit_Margin
FROM Cleaned_SuperStore_Dataset
GROUP BY Category;

--20. RFM Preparation SQL;

SELECT
    Customer_ID,
    Customer_Name,
    MAX(Order_Date) AS Last_Order_Date,
    COUNT(DISTINCT Order_ID) AS Frequency,
    ROUND(SUM(Sales),2) AS Monetary
FROM Cleaned_SuperStore_Dataset
GROUP BY Customer_ID, Customer_Name;

--21. Window Function Analysis (Top Product in Each Category);

SELECT *
FROM
(
    SELECT
        Category,
        Product_Name,
        SUM(Sales) AS Sales,
        RANK() OVER
        (
            PARTITION BY Category
            ORDER BY SUM(Sales) DESC
        ) AS Rank_No
    FROM Cleaned_SuperStore_Dataset
    GROUP BY Category, Product_Name
) t
WHERE Rank_No = 1;

--22. Pareto Analysis (80/20 Rule);

WITH ProductSales AS
(
    SELECT
        Product_Name,
        SUM(Sales) AS Sales
    FROM Cleaned_SuperStore_Dataset
    GROUP BY Product_Name
),
Pareto AS
(
    SELECT
        Product_Name,
        Sales,
        SUM(Sales) OVER(ORDER BY Sales DESC) AS Running_Sales,
        SUM(Sales) OVER() AS Total_Sales
    FROM ProductSales
)
SELECT *,
       ROUND((Running_Sales/Total_Sales)*100,2) AS Cumulative_Percentage
FROM Pareto;

--23. Most Profitable City;

SELECT
    City,
    ROUND(SUM(Profit),2) AS Profit
FROM Cleaned_SuperStore_Dataset
GROUP BY City
ORDER BY Profit DESC
LIMIT 10;

--24. Least Profitable City;

SELECT
    City,
    ROUND(SUM(Profit),2) AS Profit
FROM Cleaned_SuperStore_Dataset
GROUP BY City
ORDER BY Profit
LIMIT 10;

--25 Total Sales for Each Product;

WITH ProductSales AS (
    SELECT Product_Name, SUM(Sales) AS Sales
    FROM Cleaned_SuperStore_Dataset
    GROUP BY Product_Name
)
SELECT *
FROM ProductSales;
