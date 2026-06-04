-- =====================================================
-- PART 4 — CUSTOMER & RETENTION ANALYTICS
-- =====================================================

-- This section focuses on analyzing
-- customer retention,
-- repeat purchase behavior,
-- churn indicators,
-- customer segmentation,
-- and long-term customer value.

-- The objective is to understand
-- customer loyalty patterns,
-- retention efficiency,
-- and business sustainability
-- through customer behavior analytics.

-- This analysis helps businesses optimize:
-- • Customer retention strategy
-- • Repeat purchase growth
-- • Churn reduction
-- • Customer lifetime value
-- • Long-term revenue sustainability
-- =====================================================

-- =====================================================
-- CONCEPT 1 — CUSTOMER RETENTION ANALYSIS
-- =====================================================

-- QUERY 1 — CUSTOMER RETENTION OVERVIEW
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to understand
-- how effectively customers
-- continue purchasing over time
-- and identify retention strength.

-- OBJECTIVE:
-- Analyze repeat customers,
-- active customers,
-- churn customers,
-- and overall retention percentage.

-- FINANCIAL METRIC:
-- Retention Rate =
-- Active Customers / Total Customers * 100

-- SQL CONCEPTS USED:
-- • CTEs
-- • COUNT()
-- • CASE WHEN
-- • DATEDIFF()
-- • ROUND()
-- • NULLIF()
WITH temp AS(
  SELECT
    customer_id,
    COUNT(order_id) AS total_orders
  FROM orders
  GROUP BY customer_id
)
SELECT
  COUNT(customer_id) AS total_customers,
  
  SUM(CASE
       WHEN total_orders>1 THEN 1 ELSE 0
       END) AS repeat_customers,
       
  SUM(CASE
       WHEN total_orders=1 THEN 1 ELSE 0
       END) AS one_time_customers,
       
  ROUND(
        (SUM(CASE
			  WHEN total_orders>1 THEN 1 ELSE 0
              END)/NULLIF(COUNT(customer_id),0))*100,2
              ) AS retention_rate
FROM temp;
-- BUSINESS INTERPRETATION:
-- The report evaluates overall
-- customer retention performance
-- by comparing repeat customers
-- with one-time customers.

-- Higher repeat customer counts
-- indicate stronger customer loyalty,
-- better customer satisfaction,
-- and long-term business sustainability.

-- The output shows that repeat customers
-- significantly outnumber one-time customers,
-- resulting in a retention rate
-- above 83%, which reflects
-- strong customer engagement
-- and healthy business performance.

-- This analysis helps businesses improve
-- customer retention strategy,
-- customer experience,
-- loyalty programs,
-- and long-term revenue stability.

-- =====================================================
-- QUERY 2 — CUSTOMER RETENTION BY REGION
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- which regions have stronger
-- customer retention performance
-- and repeat purchase behavior.

-- OBJECTIVE:
-- Analyze repeat customers,
-- one-time customers,
-- and retention rate
-- across different regions.

-- FINANCIAL METRIC:
-- Regional Retention Rate =
-- Repeat Customers / Total Customers * 100

WITH temp AS(
 SELECT
   c.region,
   c.customer_id,
   COUNT(o.order_id) AS total_orders
   FROM customers c
 INNER JOIN orders o
 ON c.customer_id=o.customer_id
 GROUP BY c.region,c.customer_id
)
SELECT
  region,
  
  SUM(CASE
        WHEN total_orders>1 THEN 1 ELSE 0 END) AS repeat_customers,

  SUM(CASE
	    WHEN total_orders=1 THEN 1 ELSE 0 END) AS one_time_customers,
        
  ROUND(
        (SUM(CASE
			  WHEN total_orders>1 THEN 1 ELSE 0
              END)
              /
		NULLIF(SUM(CASE
	    WHEN total_orders>=0 THEN 1 ELSE 0 END),0))*100,2
              ) AS retention_rate
        
FROM temp
GROUP BY region;
-- BUSINESS INTERPRETATION:
-- The report compares customer retention
-- performance across different regions.

-- Tier 2 shows the highest retention rate,
-- although the retention rates across
-- most regions remain relatively similar.

-- Regions such as North, South, and West
-- have larger numbers of repeat customers,
-- indicating stronger customer engagement
-- and purchase frequency.

-- This analysis helps businesses understand
-- regional customer behavior,
-- improve customer retention strategies,
-- and optimize marketing allocation
-- across regions.

-- =====================================================
-- QUERY 3 — MONTHLY CUSTOMER RETENTION TREND
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to monitor
-- whether customer retention
-- is improving or declining over time.

-- OBJECTIVE:
-- Analyze monthly repeat customer trend
-- and retention performance
-- across different months.

-- FINANCIAL METRIC:
-- Monthly Retention Rate =
-- Repeat Customers / Total Customers * 100
WITH temp AS(
 SELECT
   DATE_FORMAT(order_date,'%Y-%m') AS month_,
   customer_id,
   COUNT(order_id) AS total_orders
 FROM orders
 GROUP BY DATE_FORMAT(order_date,'%Y-%m'),customer_id
),
grouped AS(
 SELECT
   month_,
   COUNT(DISTINCT customer_id) AS total_customers,
   
   SUM(CASE
         WHEN total_orders>1 THEN 1 ELSE 0 END) AS repeat_customers,
         
   SUM(CASE
         WHEN total_orders=1 THEN 1 ELSE 0 END) AS one_time_customers,
         
   ROUND(
         (SUM(CASE
         WHEN total_orders>1 THEN 1 ELSE 0 END)/
         NULLIF(COUNT(DISTINCT customer_id),0))*100,2
         )AS retention_rate
 FROM temp
 GROUP BY month_
),
lagged AS(
 SELECT *,
   LAG(retention_rate) OVER(ORDER BY month_) AS prev_retention_rate
 FROM grouped 
)
SELECT 
  month_,
  repeat_customers,
  one_time_customers,
  retention_rate,
  
  ROUND(
  ((retention_rate-prev_retention_rate)/prev_retention_rate)*100,2
    )AS retention_growth_rate
   
FROM lagged
ORDER BY month_ ;
-- BUSINESS INTERPRETATION:
-- The report analyzes monthly
-- customer retention trends
-- and retention growth performance
-- over time.

-- The output shows relatively stronger
-- retention growth during 2021,
-- while later periods show slower
-- or negative retention growth trends.

-- Declining retention growth may indicate
-- weaker customer engagement,
-- stronger market competition,
-- changing customer preferences,
-- or broader economic challenges.

-- This analysis helps businesses monitor
-- customer loyalty trends,
-- improve retention strategies,
-- and identify long-term business risks.

-- =====================================================
-- QUERY 4 — TOP LOYAL CUSTOMERS
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- highly loyal customers
-- who contribute consistently
-- through repeat purchases.

-- OBJECTIVE:
-- Analyze customers
-- with the highest order frequency
-- and revenue contribution.

-- FINANCIAL METRIC:
-- Customer Loyalty Performance

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • COUNT()
-- • SUM()
-- • DENSE_RANK()
-- • ORDER BY

WITH temp AS(
 SELECT
  customer_id,
  COUNT(order_id) AS total_orders,
  SUM(revenue) AS total_revenue,
  ROUND(
        (SUM(revenue)/NULLIF(COUNT(order_id),0)),2
        ) AS avg_order_value
 FROM orders
 GROUP BY customer_id
)
SELECT *,
  DENSE_RANK() OVER(ORDER BY total_orders DESC) AS performance_rnk
FROM temp;
-- BUSINESS INTERPRETATION:
-- The report identifies highly loyal
-- customers based on repeat purchase
-- frequency and customer engagement.

-- Several customers share
-- the highest performance rank,
-- indicating strong repeat buying behavior
-- and active engagement with the business.

-- This analysis helps businesses design
-- loyalty programs,
-- reward systems,
-- personalized offers,
-- and customer retention strategies
-- for high-value customers.

-- =====================================================
-- QUERY 5 — CUSTOMER LIFETIME VALUE (CLV)
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- which customers generate
-- the highest long-term value
-- and revenue contribution.

-- OBJECTIVE:
-- Analyze customer lifetime value
-- based on total spending
-- and purchase frequency.

-- FINANCIAL METRIC:
-- Customer Lifetime Value (CLV) =
-- Total Revenue Generated Per Customer

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • COUNT()
-- • ROUND()
-- • DENSE_RANK()
-- • ORDER BY

WITH temp AS(
 SELECT
  customer_id,
  SUM(revenue) AS total_revenue,
  COUNT(order_id) AS purchase_frequency,
  SUM(gross_margin) AS total_profit,
  
  ROUND(
        (SUM(revenue)/NULLIF(COUNT(order_id),0)),2
        ) AS avg_order_value
 FROM orders
 GROUP BY customer_id
)
SELECT *,
  DENSE_RANK() OVER(ORDER BY total_profit DESC) AS performance_rnk
FROM temp;
-- BUSINESS INTERPRETATION:
-- The report analyzes customer lifetime
-- value using total revenue,
-- purchase frequency,
-- total profit,
-- and average order value.

-- The output shows that many high-profit
-- customers also have higher purchase
-- frequency, indicating that repeated
-- purchases play an important role
-- in overall profitability.

-- Several customers also exhibit
-- higher average order values,
-- contributing further to revenue
-- and profit generation.

-- This analysis helps businesses identify
-- high-value customers and design
-- targeted loyalty programs,
-- personalized offers,
-- and customer retention strategies.

-- =====================================================
-- QUERY 6 — CUSTOMER SEGMENTATION
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to classify customers
-- into different segments based on
-- their purchasing behavior and value.

-- OBJECTIVE:
-- Segment customers into categories
-- such as High Value,
-- Medium Value,
-- and Low Value customers
-- using revenue and purchase frequency.

-- FINANCIAL METRIC:
-- Customer Segment Classification

-- SQL CONCEPTS USED:
-- • CASE WHEN
-- • GROUP BY
-- • SUM()
-- • COUNT()
-- • CTEs
-- • ORDER BY

WITH temp AS(
 SELECT
   customer_id,
   SUM(revenue) AS total_revenue,
   SUM(gross_margin) AS total_profit,
   COUNT(order_id) AS total_frequency,
   
   ROUND(
         (SUM(revenue)/NULLIF(COUNT(order_id),0)),2
         ) AS avg_order_value
 FROM orders
 GROUP BY customer_id
)
SELECT *,
    CASE
	  WHEN total_profit> 50000 AND total_frequency> 30
       THEN 'MAX Profit Customers'
       
      WHEN total_profit> 30000 AND total_frequency> 20
       THEN 'High Profit Customers'
       
      WHEN total_profit> 20000 THEN 'High Potential Customer'
      
      ELSE 'Regular Customer'
	END AS customer_segment
    
FROM temp
ORDER BY total_profit DESC;

-- BUSINESS INTERPRETATION:
-- The report segments customers
-- based on their profitability
-- and purchasing behavior.

-- Although Regular Customers
-- represent the largest customer group,
-- the highest revenue, profit,
-- and average order values are generally
-- concentrated among High Profit
-- and Max Profit Customers.

-- The analysis helps businesses identify
-- valuable customer segments and design
-- targeted promotions,
-- loyalty programs,
-- membership benefits,
-- and personalized marketing campaigns.

-- It also helps convert
-- High Potential Customers
-- into higher-value customer segments
-- over time.

-- =====================================================
-- QUERY 7 — CUSTOMER PURCHASE FREQUENCY SEGMENTATION
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to understand
-- how frequently customers make purchases
-- in order to identify loyal,
-- occasional, and infrequent buyers.

-- OBJECTIVE:
-- Segment customers based on
-- their purchase frequency
-- and identify highly engaged customers.

-- FINANCIAL METRIC:
-- Purchase Frequency =
-- Total Orders Per Customer

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • COUNT()
-- • CASE WHEN
-- • CTEs
-- • ORDER BY

WITH temp AS(
 SELECT
   customer_id,
   SUM(revenue) AS total_revenue,
   SUM(gross_margin) AS total_profit,
   COUNT(order_id) AS purchase_frequency,
   
   ROUND(
         (SUM(revenue)/NULLIF(COUNT(order_id),0)),2
         ) AS avg_order_value
 FROM orders
 GROUP BY customer_id
)
SELECT *,
  CASE
      WHEN purchase_frequency> 50 THEN 'Loyal Buyer'
      WHEN purchase_frequency> 30 THEN 'Frequent Buyer'
	  WHEN purchase_frequency> 20 THEN 'Regular Buyer'
      ELSE 'Low Engagement'
  END AS engagement_category
FROM temp
ORDER BY purchase_frequency DESC;
-- BUSINESS INTERPRETATION:
-- The report segments customers
-- based on their purchase frequency
-- and overall engagement with the business.

-- Customers are classified into
-- Loyal Buyers, Frequent Buyers,
-- Regular Buyers, and Low Engagement
-- groups based on their purchasing behavior.

-- Higher purchase frequency generally
-- indicates stronger customer loyalty
-- and a greater likelihood of future purchases.

-- This analysis helps businesses identify
-- highly engaged customers and design
-- loyalty programs, personalized offers,
-- and retention strategies to improve
-- long-term customer value and business growth.

-- =====================================================
-- QUERY 8 — CUSTOMER RECENCY ANALYSIS
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- recently active customers
-- and customers who have not
-- purchased for a long time.

-- OBJECTIVE:
-- Analyze customer recency
-- by measuring the number of days
-- since each customer's last purchase.

-- FINANCIAL METRIC:
-- Customer Recency =
-- Latest Order Date - Last Purchase Date

-- SQL CONCEPTS USED:
-- • MAX()
-- • DATEDIFF()
-- • GROUP BY
-- • CTEs
-- • CASE WHEN
-- • ORDER BY

WITH temp AS(
 SELECT 
   customer_id,
   MAX(order_date) AS last_order_date,
   SUM(revenue) AS total_revenue,
   COUNT(order_id) AS purchase_frequency,
   
   ROUND(
        (SUM(revenue)/NULLIF(COUNT(order_id),0)),2
        ) AS avg_order_value,
        
   DATEDIFF('2024-12-30',MAX(order_date)) AS activity
   
 FROM orders
 GROUP BY customer_id
)
SELECT 
 customer_id,
 total_revenue,
 purchase_frequency,
 avg_order_value,
 activity,
   
   CASE
       WHEN activity> 365 THEN 'Lost Customer'
       WHEN activity> 280  THEN 'Inactive Customer'
       WHEN activity> 100 THEN 'Risk Customer'
       WHEN activity> 60  THEN 'Active Customer'
       ELSE 'High Activity customer'
   END AS customer_activity_status
   
FROM temp
ORDER BY activity ASC;

-- BUSINESS INTERPRETATION:
-- The report analyzes customer recency
-- by measuring the number of days
-- since each customer's last purchase.

-- Customers are classified into
-- different activity segments,
-- ranging from highly active customers
-- to inactive and lost customers.

-- Customer recency patterns may vary
-- across industries and product categories,
-- as some products are purchased
-- more frequently than others.

-- This analysis helps businesses identify
-- customer engagement levels,
-- improve retention strategies,
-- and target inactive customers
-- through personalized campaigns
-- and re-engagement programs.

-- =====================================================
-- QUERY 9 — CHURN RISK ANALYSIS
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- customers who are at risk
-- of leaving and may stop
-- purchasing in the future.

-- OBJECTIVE:
-- Analyze churn risk based on
-- customer recency and
-- purchasing behavior.

-- FINANCIAL METRIC:
-- Churn Risk =
-- Customer inactivity level
-- based on days since last purchase

-- SQL CONCEPTS USED:
-- • MAX()
-- • DATEDIFF()
-- • CASE WHEN
-- • GROUP BY
-- • CTEs
-- • ORDER BY

WITH temp AS(
 SELECT 
   customer_id,
   MAX(order_date) AS last_order_date,
   SUM(revenue) AS total_revenue,
   COUNT(order_id) AS purchase_frequency,
   
   ROUND(
        (SUM(revenue)/NULLIF(COUNT(order_id),0)),2
        ) AS avg_order_value,
        
   DATEDIFF('2024-12-30',MAX(order_date)) AS days_since_last_order
   
 FROM orders
 GROUP BY customer_id
)
SELECT 
 customer_id,
 total_revenue,
 purchase_frequency,
 avg_order_value,
 days_since_last_order,
   
   CASE
       WHEN days_since_last_order> 365 THEN 'lost Customer'
       WHEN days_since_last_order> 280 THEN 'Critical Risk'
       WHEN days_since_last_order> 100 THEN 'Medium Risk'
       WHEN days_since_last_order> 60  THEN 'Low Risk'
       ELSE 'No Risk'
   END AS churn_risk_status
   
FROM temp
ORDER BY days_since_last_order DESC;
-- BUSINESS INTERPRETATION:
-- The report analyzes customer churn risk
-- using the number of days since
-- each customer's last purchase.

-- Customers are classified into
-- different churn-risk segments,
-- ranging from No Risk customers
-- to Critical Risk and Lost Customers.

-- Higher inactivity periods generally
-- indicate a greater likelihood
-- of customer churn and lower chances
-- of future engagement.

-- This analysis helps businesses identify
-- at-risk customers and design
-- targeted promotions,
-- loyalty programs,
-- and re-engagement campaigns
-- to improve customer retention.

-- However, recency patterns may vary
-- across industries and product categories,
-- and the analysis should be interpreted
-- in the context of the business model.

-- =====================================================
-- QUERY 10 — CUSTOMER REVENUE CONCENTRATION ANALYSIS
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to understand
-- whether revenue is generated
-- from a broad customer base
-- or concentrated among
-- a small group of customers.

-- OBJECTIVE:
-- Identify top revenue-generating customers
-- and measure their contribution
-- to overall business revenue.

-- FINANCIAL METRIC:
-- Revenue Contribution % =
-- Customer Revenue / Total Revenue * 100

-- SQL CONCEPTS USED:
-- • SUM()
-- • GROUP BY
-- • Window Functions
-- • ROUND()
-- • DENSE_RANK()
-- • CTEs

WITH customer_revenue AS(
SELECT
    customer_id,
    SUM(revenue) AS customer_revenue,
    COUNT(order_id) AS total_orders,

    ROUND(
        SUM(revenue)/NULLIF(COUNT(order_id),0)
        ,2
    ) AS avg_order_value

FROM orders
GROUP BY customer_id
)
SELECT
    customer_id,
    customer_revenue,
    total_orders,
    avg_order_value,

    ROUND(
        (
        customer_revenue
        /NULLIF(SUM(customer_revenue) OVER(),0)
        )*100
        ,2
    ) AS revenue_contribution_pct,

 DENSE_RANK() OVER(ORDER BY customer_revenue DESC)
  AS performance_rank

FROM customer_revenue
ORDER BY customer_revenue DESC;

-- BUSINESS INTERPRETATION:
-- The report analyzes the revenue
-- contribution of individual customers
-- to the overall business revenue.

-- It helps identify customers who
-- generate the highest revenue and
-- measures their importance to the business.

-- The distribution of revenue contribution
-- across customers provides insight into
-- whether revenue is concentrated among
-- a small group of customers or spread
-- across a broad customer base.

-- A more evenly distributed revenue base
-- generally indicates lower dependency
-- on individual customers and greater
-- business stability.

-- This analysis helps businesses identify
-- key customers, evaluate revenue
-- concentration risk, and develop
-- customer retention strategies.
