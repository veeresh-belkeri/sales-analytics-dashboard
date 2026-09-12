-- ============================================================
-- Sales/Retail Analytics — SQL Analysis Queries
-- Database: superstore.db (SQLite) | Table: orders
-- ============================================================

-- 1. Overall KPIs
SELECT
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS profit_margin_pct,
    COUNT(DISTINCT Order_ID) AS total_orders,
    ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2) AS avg_order_value
FROM orders;

-- 2. Sales & Profit by Region
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS profit_margin_pct
FROM orders
GROUP BY Region
ORDER BY total_sales DESC;

-- 3. Top 10 Sub-Categories by Sales
SELECT
    Sub_Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    SUM(Quantity) AS units_sold
FROM orders
GROUP BY Sub_Category
ORDER BY total_sales DESC
LIMIT 10;

-- 4. Loss-making Sub-Categories (negative profit — a real business problem to flag)
SELECT
    Sub_Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Discount) * 100, 1) AS avg_discount_pct
FROM orders
GROUP BY Sub_Category
HAVING total_profit < 0
ORDER BY total_profit ASC;

-- 5. Monthly Sales Trend (for time-series chart in dashboard)
SELECT
    Order_Month,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM orders
GROUP BY Order_Month
ORDER BY Order_Month;

-- 6. Top 10 Customers by Total Sales
SELECT
    Customer_Name,
    Segment,
    COUNT(DISTINCT Order_ID) AS num_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM orders
GROUP BY Customer_Name, Segment
ORDER BY total_sales DESC
LIMIT 10;

-- 7. Discount vs Profit relationship (does discounting hurt margins?)
SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.2 THEN '1-20%'
        WHEN Discount <= 0.4 THEN '21-40%'
        ELSE '40%+'
    END AS discount_band,
    COUNT(*) AS num_orders,
    ROUND(AVG(Profit_Margin_Pct), 2) AS avg_profit_margin_pct
FROM orders
GROUP BY discount_band
ORDER BY discount_band;

-- 8. Shipping performance by Ship Mode
SELECT
    Ship_Mode,
    COUNT(*) AS num_orders,
    ROUND(AVG(Shipping_Days), 1) AS avg_shipping_days
FROM orders
GROUP BY Ship_Mode
ORDER BY avg_shipping_days;

-- 9. Year-over-Year Sales Growth
SELECT
    Order_Year,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(
        (SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY Order_Year))
        * 100.0 / LAG(SUM(Sales)) OVER (ORDER BY Order_Year), 2
    ) AS yoy_growth_pct
FROM orders
GROUP BY Order_Year
ORDER BY Order_Year;
