USE  blinkt_db

select * from BlinkIT_Data

 
select COUNT(*) from BlinkIT_Data

-- DATA CLEANING ---

UPDATE BlinkIT_Data
SET Item_Fat_Content =
CASE
WHEN Item_Fat_Content IN ('LF' ,'low fat') THEN 'Low Fat'
WHEN Item_Fat_Content IN ('reg') THEN  'Regular'
ELSE Item_Fat_Content
END

--
SELECT DISTINCT (Item_Fat_Content) FROM BlinkIT_Data

-----   A. KPI'S 

-----   1. TOTAL SALES:

SELECT 
    CONCAT(CAST(SUM(Total_Sales) / 1000000 AS decimal(10,2)), ' M') AS Total_Sales_Millions
FROM BlinkIT_Data;


-----   2. AVERAGE SALES

SELECT CAST(AVG(Total_Sales) AS int ) AS Avg_Sales 
FROM BlinkIT_Data;

---3. NO OF ITEMS

	SELECT COUNT(*) AS No_of_Orders 
	FROM blinkit_data;

----4. AVG RATING

SELECT CAST (AVG(Rating) AS DECIMAL(10,1) ) AS Avg_Rating
FROM blinkit_data;

-----B .Granular Requirements


----1. Total Sales by Fat Content

SELECT Item_Fat_Content, 
		CAST(SUM(Total_Sales) AS decimal(10,2)) AS Total_Sales, 
		CAST (AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Rating,
		COUNT(*) AS No_of_Orders,
		CAST (AVG(Rating) AS DECIMAL(10,1) ) AS Avg_Rating
FROM blinkit_data

GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC;

--- 2 . Total Sales by Item Type

SELECT Item_Type, 
		CAST(SUM(Total_Sales) AS decimal(10,2)) AS Total_Sales, 
		CAST (AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Rating,
		COUNT(*) AS No_of_Orders,
		CAST (AVG(Rating) AS DECIMAL(10,1) ) AS Avg_Rating
FROM blinkit_data

GROUP BY Item_Type
ORDER BY Total_Sales DESC;


---3. Fat Content by Outlet for Total Sales

SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


---4 . Total Sales by Outlet Establishment Year 

SELECT Outlet_Establishment_Year, 
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
	CAST (AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
	COUNT(*) AS No_of_Orders,
	CAST (AVG(Rating) AS DECIMAL(10,1) ) AS Avg_Rating
FROM blinkit_data

GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year

---5. Percentage of Sales by Outlet Size

SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

---6. Sales by Outlet Location

SELECT Outlet_Location_Type, 
	CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
	CAST (AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
	COUNT(*) AS No_of_Orders,
	CAST (AVG(Rating) AS DECIMAL(10,1) ) AS Avg_Rating

FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

--- 7 . . All Metrics by Outlet Type:

SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC



 


select * from BlinkIT_Data