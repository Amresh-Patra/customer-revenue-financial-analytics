-- =====================================================
-- PART 1 — REVENUE PERFORMANCE ANALYTICS
-- =====================================================

-- CONCEPT 1 — OVERALL REVENUE KPIs
-- =====================================================

-- QUERY 1 — EXECUTIVE REVENUE SNAPSHOT
-- =====================================================

-- BUSINESS PROBLEM:
-- Business stakeholders need a centralized
-- revenue dashboard to monitor overall
-- financial performance and customer activity.

-- OBJECTIVE:
-- Analyze total revenue, total orders,
-- average order value, and total customers.

-- FINANCIAL METRIC:
-- Average Order Value (AOV)
-- = Total Revenue / Total Orders

-- SQL CONCEPTS USED:
-- • Aggregations
-- • SUM()
-- • COUNT()
-- • ROUND()
-- • NULLIF()
SELECT
   SUM(revenue) AS total_revenue,
   COUNT(order_id) AS total_orders,
   COUNT(DISTINCT customer_id) AS total_customers,
   ROUND(
		 (SUM(revenue)/NULLIF(COUNT(order_id),0)),2
         ) AS avg_order_value
FROM orders;
-- BUSINESS INTERPRETATION:
-- The report shows that the company has generated
-- strong overall revenue with a high volume of orders
-- and customers, indicating healthy business performance
-- and strong customer activity.

-- The average order value is also strong, but the business
-- still has potential to increase customer spending through
-- targeted marketing campaigns, product bundling,
-- premium services, and improved after-sales experience.

-- =====================================================
-- QUERY 2 — REVENUE BY ORDER STATUS
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to monitor how different
-- order statuses impact overall revenue
-- and financial performance.

-- OBJECTIVE:
-- Analyze revenue generated across
-- Completed, Cancelled, and Returned orders.

-- FINANCIAL METRIC:
-- Revenue Contribution by Order Status

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • COUNT()
-- • ROUND()
-- • ORDER BY

SELECT
  order_status,
  SUM(revenue) AS total_revenue,
  SUM(net_revenue) AS total_net_revenue,
  COUNT(order_id) AS total_orders,
  COUNT(DISTINCT customer_id)AS total_customers,
  SUM(gross_margin) AS total_profit
FROM orders
GROUP BY order_status;

-- BUSINESS INTERPRETATION:
-- The report shows that Completed orders
-- contribute the highest share of revenue,
-- net revenue, customers, and profitability,
-- indicating strong overall business performance
-- and successful order fulfillment.

-- Returned orders generated significant
-- revenue leakage and weak profitability,
-- which may indicate customer dissatisfaction,
-- product mismatch, or service-related issues.

-- Cancelled orders may reflect customer hesitation,
-- pricing concerns, or weak purchase confidence.

-- Businesses can reduce revenue loss by improving
-- product quality, customer communication,
-- after-sales support, and targeted retention campaigns.

-- =====================================================
-- CONCEPT 2 — MONTHLY REVENUE TRENDS
-- =====================================================

-- QUERY 3 — MONTHLY REVENUE PERFORMANCE
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to monitor monthly
-- revenue performance to identify
-- growth trends and seasonal patterns.

-- OBJECTIVE:
-- Analyze monthly revenue, total orders,
-- total customers, and average order value.

-- FINANCIAL METRIC:
-- Monthly Revenue Performance
-- Average Order Value (AOV)

-- SQL CONCEPTS USED:
-- • DATE_FORMAT()
-- • GROUP BY
-- • SUM()
-- • COUNT()
-- • ROUND()
-- • ORDER BY

SELECT
  DATE_FORMAT(order_date,'%Y-%m') AS month_,
  SUM(revenue) AS total_revenue,
  SUM(gross_margin) AS total_profit,
  COUNT(order_id) AS total_orders,
  COUNT(DISTINCT customer_id) AS total_customers
FROM orders
GROUP BY DATE_FORMAT(order_date,'%Y-%m')
ORDER BY SUM(revenue) DESC;

-- BUSINESS INTERPRETATION:
-- The report shows that several months in 2021
-- generated the highest revenue, customer activity,
-- and profitability, indicating strong business
-- performance during that period.

-- However, later periods show a gradual decline
-- in total orders and customer activity, which may
-- indicate weakening demand, increased competition,
-- changing market conditions, or operational challenges.

-- The analysis also highlights possible seasonal
-- revenue fluctuations across different months.

-- Businesses can improve long-term growth by
-- strengthening marketing strategies, improving
-- product offerings, investing in customer retention,
-- and optimizing operational efficiency.

-- =====================================================
-- QUERY 4 — MONTH OVER MONTH REVENUE GROWTH
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to monitor revenue growth
-- consistency across months to identify
-- expansion or slowdown trends.

-- OBJECTIVE:
-- Measure month-over-month revenue growth
-- percentage using LAG().

-- FINANCIAL METRIC:
-- MoM Growth %
-- = (Current Revenue - Previous Revenue)
--   / Previous Revenue * 100

-- SQL CONCEPTS USED:
-- • CTEs
-- • LAG()
-- • Window Functions
-- • DATE_FORMAT()
-- • ROUND()
-- • NULLIF()

WITH temp AS(
  SELECT
    DATE_FORMAT(order_date,'%Y-%m') AS month_,
    COUNT(order_id) AS total_orders,
    SUM(revenue) AS total_revenue
  FROM orders
  GROUP BY DATE_FORMAT(order_date,'%Y-%m') 
),
monthly_trend AS(
  SELECT *,
    LAG(total_revenue) OVER(ORDER BY month_) AS prev_revenue
  FROM temp
)
SELECT *,
  ROUND(
        ((total_revenue-prev_revenue)/NULLIF(prev_revenue,0))*100,2
        ) AS change_in_revenue
FROM monthly_trend;

-- BUSINESS INTERPRETATION:
-- The report shows strong positive revenue growth
-- during several months of 2021, indicating healthy
-- business expansion and increasing customer activity
-- during that period.

-- However, later months show slower growth and
-- declining revenue momentum, which may indicate
-- weakening demand, increased competition,
-- seasonal fluctuations, or operational challenges.

-- The analysis also highlights fluctuations in
-- month-over-month growth percentages, reflecting
-- periods of both strong and unstable revenue performance.

-- Businesses can improve long-term revenue stability
-- through customer retention strategies, targeted
-- marketing campaigns, product innovation,
-- and operational optimization.

-- =====================================================
-- QUERY 5 — CUMULATIVE RUNNING REVENUE
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to monitor cumulative
-- revenue growth over time to evaluate
-- long-term business expansion trends.

-- OBJECTIVE:
-- Calculate cumulative running revenue
-- across months using window functions.

-- FINANCIAL METRIC:
-- Running Revenue
-- = cumulative sum of monthly revenue

-- SQL CONCEPTS USED:
-- • CTEs
-- • SUM() OVER()
-- • Window Functions
-- • DATE_FORMAT()
-- • ORDER BY

WITH temp AS(
 SELECT
   DATE_FORMAT(order_date,'%Y-%m') AS month_,
   COUNT(order_id) AS total_orders,
   SUM(revenue) AS total_revenue
 FROM orders
 GROUP BY DATE_FORMAT(order_date,'%Y-%m')
)
SELECT *,
   SUM(total_revenue) OVER(ORDER BY month_) AS cumulative_revenue
FROM temp;
-- BUSINESS INTERPRETATION:
-- The report shows that cumulative revenue
-- continues to increase across progressive months,
-- indicating long-term business expansion
-- and consistent revenue generation.

-- Several months in 2021 contributed strongly
-- to overall cumulative revenue growth,
-- reflecting periods of high customer activity
-- and strong order volume.

-- However, declining order activity in later
-- periods may indicate slower revenue growth
-- momentum and possible demand fluctuations.

-- Businesses can use this analysis to identify
-- high-performing sales periods and launch
-- seasonal campaigns, exclusive offers,
-- and promotional events to maximize
-- long-term revenue growth.

-- =====================================================
-- CONCEPT 3 — YEARLY REVENUE ANALYSIS
-- =====================================================

-- QUERY 6 — YEAR OVER YEAR REVENUE COMPARISON
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to compare yearly
-- revenue performance to identify
-- long-term growth and seasonal trends.

-- OBJECTIVE:
-- Analyze year-over-year revenue growth
-- using LAG() across yearly revenue periods.

-- FINANCIAL METRIC:
-- YoY Growth %
-- = (Current Revenue - Previous Revenue)
--   / Previous Revenue * 100

-- SQL CONCEPTS USED:
-- • CTEs
-- • LAG()
-- • Window Functions
-- • YEAR()
-- • GROUP BY
-- • ROUND()
-- • NULLIF()

WITH temp AS(
 SELECT
  DATE_FORMAT(order_date,'%Y-%m') AS month_,
  COUNT(order_date) AS total_orders,
  COUNT(DISTINCT customer_id) AS total_customers,
  SUM(revenue) AS total_revenue
 FROM orders
 GROUP BY DATE_FORMAT(order_date,'%Y-%m') 
 ),
 YoY_trend AS(
  SELECT *,
    LAG(total_revenue,12) OVER(ORDER BY month_) AS prev_year_revenue
  FROM temp
 )
SELECT *,
   ROUND(
         ((total_revenue-prev_year_revenue)/NULLIF(prev_year_revenue,0))*100,2
         ) AS YoY_trend
FROM YoY_trend; 

-- BUSINESS INTERPRETATION:
-- The report shows that YoY revenue values
-- for 2021 remain NULL because no prior-year
-- comparison data exists for 2020.

-- From 2022 onward, several periods show
-- declining year-over-year revenue growth,
-- indicating slower business expansion
-- and weakening revenue momentum.

-- The negative YoY trends may reflect
-- seasonal fluctuations, increased market competition,
-- changing customer demand, or broader economic conditions.

-- Businesses can improve long-term yearly performance
-- by strengthening customer retention strategies,
-- improving product competitiveness,
-- and optimizing marketing and operational efficiency.

-- =====================================================
-- QUERY 7 — BEST & WORST PERFORMING MONTH
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- peak-performing and low-performing months
-- to optimize seasonal planning,
-- inventory management,
-- and marketing campaigns.

-- OBJECTIVE:
-- Identify the highest and lowest revenue
-- generating months within each year
-- using DENSE_RANK().

-- FINANCIAL METRIC:
-- Monthly Revenue Ranking

-- SQL CONCEPTS USED:
-- • CTEs
-- • DENSE_RANK()
-- • PARTITION BY
-- • Window Functions
-- • YEAR()
-- • MONTH()
-- • ORDER BY

WITH temp AS(
 SELECT
	YEAR(order_date) AS year_,
    MONTH(order_date) AS month_,
    SUM(revenue) AS total_revenue,
    SUM(gross_margin) AS total_profit,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(
    (SUM(revenue)/NULLIF(COUNT(order_id),0)),2
    ) AS avg_order_value
 FROM orders
 GROUP BY YEAR(order_date),MONTH(order_date)
)
SELECT *,
  DENSE_RANK() OVER(PARTITION BY year_ ORDER BY total_revenue DESC) AS best_month_rnk ,
  
  DENSE_RANK() OVER(PARTITION BY year_ ORDER BY total_revenue ASC) AS worst_month_rnk
FROM temp;

-- BUSINESS INTERPRETATION:
-- The report identifies both the highest
-- and lowest revenue-generating months
-- within each year, helping businesses
-- understand seasonal revenue patterns
-- and customer demand fluctuations.

-- Several months in 2021 generated
-- exceptionally strong revenue, customer activity,
-- and order volume, indicating peak business periods.

-- Low-performing months may reflect seasonal slowdowns,
-- weaker customer demand, economic conditions,
-- or changing market trends.

-- Businesses can use this analysis to optimize
-- seasonal marketing campaigns, promotional offers,
-- inventory planning, and strategic resource allocation
-- during both peak and weak business periods.

-- =====================================================
-- CONCEPT 4 — PRODUCT REVENUE ANALYSIS
-- =====================================================

-- QUERY 8 — REVENUE BY PRODUCT CATEGORY
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- which product categories contribute
-- the highest share of revenue
-- and profitability.

-- OBJECTIVE:
-- Analyze revenue contribution,
-- profitability, customer activity,
-- and order volume by product category.

-- FINANCIAL METRIC:
-- Revenue Contribution %
-- = category revenue / total revenue * 100

-- SQL CONCEPTS USED:
-- • CTEs
-- • SUM() OVER()
-- • Window Functions
-- • GROUP BY
-- • ROUND()
-- • DENSE_RANK()

WITH temp AS(
 SELECT
  product_category,
  SUM(revenue) AS total_revenue,
  SUM(gross_margin) AS total_profit,
  COUNT(order_id) AS total_orders,
  COUNT(DISTINCT customer_id) AS total_customers,
  ROUND(
        (SUM(revenue)/NULLIF(COUNT(order_id),0)),2
        ) AS avg_ord_value
 FROM orders
 GROUP BY product_category
)
SELECT *,
   ROUND(
         (total_revenue/NULLIF(SUM(total_revenue) OVER(),0))*100,2
         )AS contribution_in_revenue,
         
   DENSE_RANK() OVER(ORDER BY total_revenue DESC) AS performance_rnk
FROM temp;
-- BUSINESS INTERPRETATION:
-- The report shows that Fashion and Beauty
-- categories generate the highest revenue,
-- profitability, customer activity,
-- and contribution percentage,
-- indicating strong market demand
-- and successful category performance.

-- Together, these categories contribute
-- a significant share of total business revenue,
-- making them key drivers of overall growth
-- and profitability.

-- Categories with lower revenue contribution
-- may require optimized pricing strategies,
-- targeted promotions, or category-specific
-- marketing campaigns to improve performance.

-- Businesses can use this analysis to support
-- strategic fund allocation, inventory planning,
-- product expansion, and category-focused
-- marketing investment decisions.

-- =====================================================
-- QUERY 9 — CATEGORY REVENUE TREND ANALYSIS
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to monitor
-- month-over-month revenue trends
-- within each product category
-- to identify growing and declining categories.

-- OBJECTIVE:
-- Analyze monthly category revenue trends
-- and compare category growth performance over time.

-- FINANCIAL METRIC:
-- Category MoM Revenue Growth %

-- SQL CONCEPTS USED:
-- • CTEs
-- • PARTITION BY
-- • LAG()
-- • Window Functions
-- • DATE_FORMAT()
-- • ROUND()
-- • NULLIF()

WITH temp AS(
 SELECT
   DATE_FORMAT(order_date,'%Y-%m') AS month_,
   product_category,
   SUM(gross_margin) AS total_profit,
   SUM(revenue) AS total_revenue
 FROM orders
 GROUP BY DATE_FORMAT(order_date,'%Y-%m'),product_category
),
grouped AS(
SELECT *,
  LAG(total_revenue) OVER(PARTITION BY product_category ORDER BY month_) AS prev_revenue
FROM temp
ORDER BY month_,product_category
)
SELECT *,
  ROUND(
		((total_revenue-prev_revenue)/NULLIF(prev_revenue,0))*100,2
        )AS MoM_growth
FROM grouped;
-- BUSINESS INTERPRETATION:
-- The report shows that several product
-- categories experienced declining month-over-month
-- revenue growth over time, resulting in weaker
-- revenue and profitability performance.

-- The declining growth trend may indicate
-- changing customer demand, increased competition,
-- or lack of product innovation in certain categories.

-- Businesses can improve category performance
-- through targeted marketing campaigns,
-- product upgrades, and category-focused
-- promotional strategies.

-- =====================================================
-- QUERY 10 — TOP 3 REVENUE MONTHS
-- PER PRODUCT CATEGORY
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- the highest revenue-generating periods
-- for each product category
-- to optimize seasonal sales strategies
-- and marketing campaigns.

-- OBJECTIVE:
-- Identify the top 3 revenue-generating
-- months within each product category
-- using DENSE_RANK().

-- FINANCIAL METRIC:
-- Monthly Category Revenue Ranking

-- SQL CONCEPTS USED:
-- • CTEs
-- • DENSE_RANK()
-- • PARTITION BY
-- • Window Functions
-- • DATE_FORMAT()
-- • GROUP BY
-- • ORDER BY

WITH temp AS(
 SELECT
   DATE_FORMAT(order_date,'%Y-%m') AS month_,
   product_category,
   SUM(gross_margin) AS total_profit,
   SUM(revenue) AS total_revenue,
   COUNT(order_id) AS total_orders,
   COUNT(DISTINCT customer_id) AS total_customers
 FROM orders
 GROUP BY DATE_FORMAT(order_date,'%Y-%m'),product_category
),
grouped AS(
SELECT *,
    DENSE_RANK() OVER(PARTITION BY product_category ORDER BY total_revenue DESC
   ) AS revenue_rank
FROM temp
)
SELECT *
FROM grouped
WHERE revenue_rank<=3
ORDER BY product_category,revenue_rank;
-- BUSINESS INTERPRETATION:
-- The report identifies the top 3
-- revenue-generating months within
-- each product category, helping businesses
-- recognize peak sales periods
-- and seasonal demand patterns.

-- Several categories generated exceptionally
-- strong revenue and profitability during
-- specific months, indicating periods
-- of high customer demand and purchasing activity.

-- Businesses can use this analysis
-- to optimize seasonal campaigns,
-- promotional offers, inventory planning,
-- and category-focused marketing strategies.
