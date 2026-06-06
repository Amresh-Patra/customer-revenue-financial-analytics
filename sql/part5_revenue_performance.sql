-- =====================================================
-- PART 5 — FINANCIAL INTELLIGENCE DASHBOARD
-- =====================================================

-- This section focuses on building
-- executive-level financial intelligence
-- reports by combining revenue,
-- profitability, refunds, discounts,
-- customer acquisition costs,
-- and marketing performance metrics.

-- The objective is to move beyond
-- basic revenue analysis and develop
-- a complete financial view of the business,
-- including revenue leakages,
-- profitability drivers,
-- financial efficiency,
-- and overall business health.

-- This analysis helps businesses optimize:
-- • Revenue protection
-- • Profitability improvement
-- • Refund control
-- • Cost management
-- • Marketing efficiency
-- • Executive decision-making

-- The queries in this section simulate
-- the type of financial dashboards
-- used by CFOs, Finance Managers,
-- Business Analysts,
-- and Executive Leadership Teams
-- to monitor overall business performance.

-- =====================================================
-- QUERY 1 — REFUND RATE BY CATEGORY
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- which product categories experience
-- the highest revenue loss due to refunds.

-- OBJECTIVE:
-- Analyze refund rates across
-- product categories and identify
-- categories with significant
-- revenue leakage.

-- FINANCIAL METRIC:
-- Refund Rate =
-- Refund Amount / Revenue * 100

WITH temp AS(
 SELECT
   product_category,
   SUM(revenue) AS total_revenue,
   SUM(refund_amount) AS total_refunds
 FROM orders
 GROUP BY product_category
)
SELECT *,
  ROUND(
        (total_refunds/NULLIF(total_revenue,0))*100,2
        ) AS refund_share_in_revenue
FROM temp 
ORDER BY (total_refunds/NULLIF(total_revenue,0))*100 DESC;

-- BUSINESS INTERPRETATION:
-- The report analyzes refund rates
-- across different product categories
-- and measures the share of refunds
-- relative to category revenue.

-- Higher refund rates indicate greater
-- revenue leakage and may signal
-- product quality issues,
-- customer dissatisfaction,
-- or mismatches between customer
-- expectations and delivered products.

-- This analysis helps businesses identify
-- categories with excessive refunds
-- and take corrective actions through
-- product improvements,
-- customer feedback analysis,
-- and quality control initiatives.

-- Reducing refund rates can improve
-- revenue retention and overall
-- financial performance.

-- =====================================================
-- QUERY 2 — MONTHLY REFUND TREND
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to monitor
-- whether refund rates are improving
-- or worsening over time.

-- OBJECTIVE:
-- Analyze monthly refund trends
-- and track changes in refund rates
-- across different months.

-- FINANCIAL METRIC:
-- Refund Rate =
-- Refund Amount / Revenue * 100

-- TREND METRIC:
-- Refund Growth Rate =
-- (Current Refund Rate - Previous Refund Rate)
-- / Previous Refund Rate * 100

-- SQL CONCEPTS USED:
-- • DATE_FORMAT()
-- • SUM()
-- • ROUND()
-- • LAG()
-- • CTEs
-- • Window Functions

WITH temp AS(
  SELECT
    DATE_FORMAT(order_date,'%Y-%m') AS month_,
    SUM(revenue) AS total_revenue,
    SUM(refund_amount) AS total_refunds,
    
    ROUND(
        (SUM(refund_amount)/NULLIF(SUM(revenue),0))*100,2
        ) AS refund_rate
        
  FROM orders
  GROUP BY DATE_FORMAT(order_date,'%Y-%m')
),
refund_data AS(
 SELECT *,
   LAG(refund_rate) OVER(ORDER BY month_) AS prev_refund_rate
 FROM temp
)
SELECT *,
      ROUND(
            ((refund_rate - prev_refund_rate)
            /NULLIF(prev_refund_rate,0))*100,2
            ) AS change_in_refund_rate
FROM refund_data 
ORDER BY month_;
-- BUSINESS INTERPRETATION:
-- The report tracks monthly refund rates
-- and measures changes in refund performance
-- over time.

-- A declining refund rate indicates
-- improving revenue retention and better
-- customer satisfaction.

-- This analysis helps businesses monitor
-- refund trends and take corrective actions
-- to reduce revenue leakage.

-- =====================================================
-- QUERY 3 — NET REVENUE WATERFALL
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses often focus on gross revenue
-- while ignoring discounts, refunds,
-- shipping costs, and payment processing fees,
-- resulting in an incomplete financial picture.

-- OBJECTIVE:
-- Analyze the complete revenue waterfall
-- from gross revenue to true net revenue
-- after accounting for all major costs
-- and revenue leakages.

-- FINANCIAL METRIC:
-- Net Revenue =
-- Gross Revenue
-- - Discounts
-- - Refunds
-- - Shipping Costs
-- - Payment Processing Fees

-- SQL CONCEPTS USED:
-- • SUM()
-- • ROUND()
-- • Arithmetic Operations
-- • CTEs (Optional)
-- • Financial KPI Analysis

WITH temp AS(
 SELECT
   SUM(revenue) AS gross_revenue,
   SUM(discount) AS discount_cost,
   SUM(refund_amount) AS total_refunds,
   SUM(shipping_cost) AS total_shipping_cost,
   SUM(delivery_region_cost) AS total_delivery_cost,
   SUM(payment_processing_fee) AS payment_fees
 FROM orders
),
grouped AS(
 SELECT *,
      (
       discount_cost + 
       total_refunds + 
       total_shipping_cost + 
       total_delivery_cost +
       payment_fees
       ) AS total_cost
 FROM temp
)
SELECT *,
   (gross_revenue - total_cost) AS true_net_revenue,
   
   ROUND(
         (total_cost/gross_revenue)*100,2) AS cost_share_in_revenue
FROM grouped;
-- BUSINESS INTERPRETATION:
-- The report provides a complete
-- revenue waterfall by comparing
-- gross revenue against major
-- revenue leakages and operating costs.

-- The output shows how discounts,
-- refunds, shipping costs,
-- delivery costs, and payment fees
-- reduce the revenue retained
-- by the business.

-- This analysis helps management
-- understand cost drivers and
-- improve overall financial efficiency.

-- =====================================================
-- QUERY 4 — NET REVENUE BY CATEGORY
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses often evaluate categories
-- using gross revenue alone, which may
-- hide the true profitability of
-- different product categories.

-- OBJECTIVE:
-- Analyze net revenue by category
-- after accounting for discounts,
-- refunds, shipping costs,
-- and payment processing fees.

-- FINANCIAL METRIC:
-- Net Revenue =
-- Revenue
-- - Discounts
-- - Refunds
-- - Shipping Costs
-- - Payment Processing Fees

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • Arithmetic Operations
-- • DENSE_RANK()
-- • CTEs
-- • ORDER BY
WITH temp AS(
 SELECT
   product_category,
   SUM(revenue) AS gross_revenue,
   SUM(discount) AS discount_cost,
   SUM(refund_amount) AS total_refunds,
   SUM(shipping_cost) AS total_shipping_cost,
   SUM(delivery_region_cost) AS total_delivery_cost,
   SUM(payment_processing_fee) AS payment_fees
 FROM orders
 GROUP BY product_category
),
grouped AS(
 SELECT *,
      (
       discount_cost + 
       total_refunds + 
       total_shipping_cost + 
       total_delivery_cost +
       payment_fees
       ) AS total_cost
 FROM temp
),
category_data AS(
SELECT 
    product_category,
    gross_revenue,
    total_cost,
    
   (gross_revenue - total_cost) AS true_net_revenue,
   
   ROUND(
         (total_cost/gross_revenue)*100,2) AS cost_share_in_revenue
FROM grouped
)
SELECT *,
  DENSE_RANK() OVER(ORDER BY cost_share_in_revenue) AS cost_share_rank
FROM category_data;
-- BUSINESS INTERPRETATION:
-- The report compares product categories
-- based on gross revenue, total cost,
-- and true net revenue.

-- While some categories generate
-- higher revenue, their cost share
-- may also be higher, reducing
-- overall profitability.

-- This analysis helps businesses identify
-- the categories that retain the most
-- revenue after accounting for costs
-- and revenue leakages.

-- =====================================================
-- QUERY 5 — EXECUTIVE FINANCIAL KPI DASHBOARD
-- =====================================================

-- BUSINESS PROBLEM:
-- Executives often need a single report
-- that summarizes overall business
-- financial performance instead of
-- reviewing multiple separate reports.

-- OBJECTIVE:
-- Build a financial KPI dashboard
-- containing the most important
-- business performance metrics
-- in a single output.

-- FINANCIAL METRICS:
-- Gross Revenue
-- Net Revenue
-- Total Profit
-- Profit Margin %
-- Refund Rate %
-- Discount Rate %
-- Overall CAC
-- Overall Marketing ROI

-- SQL CONCEPTS USED:
-- • Multiple CTEs
-- • SUM()
-- • ROUND()
-- • Arithmetic Operations
-- • CROSS JOIN
-- • Executive Dashboard Design

WITH temp AS(
 SELECT
   SUM(revenue) AS gross_revenue,
   SUM(gross_margin) AS total_profit,
   SUM(discount) AS discount_cost,
   SUM(refund_amount) AS total_refunds,
   SUM(shipping_cost) AS total_shipping_cost,
   SUM(delivery_region_cost) AS total_delivery_cost,
   SUM(payment_processing_fee) AS payment_fees
 FROM orders
),
grouped AS(
 SELECT *,
      (
       discount_cost + 
       total_refunds + 
       total_shipping_cost + 
       total_delivery_cost +
       payment_fees
       ) AS total_cost
 FROM temp
),
share_data AS(
  SELECT
    gross_revenue,
    total_profit,
    total_cost,
    
    (gross_revenue - total_cost) AS true_net_revenue,
    
    ROUND(
          (total_profit/NULLIF(gross_revenue,0))*100,2
          )AS profit_margin,
          
    ROUND(
          (discount_cost/NULLIF(gross_revenue,0))*100,2
          )AS discount_rate,
	
    ROUND(
          (total_refunds/NULLIF(gross_revenue,0))*100,2
          )AS refund_rate

FROM grouped
)
SELECT s.*,
   ROUND(
         ((SUM(m.spend_amount) OVER() /NULLIF(SUM(m.new_customers) OVER(),0))),2
		 )AS customer_acquisition_cost,
   
   ROUND(
         (s.gross_revenue/NULLIF(SUM(m.spend_amount) OVER(),0)),2
		 )AS revenue_per_marketing_unit,
   
   ROUND(
         (s.total_profit/NULLIF(SUM(m.spend_amount) OVER(),0)),2
		 )AS profit_per_marketing_unit 
         
FROM share_data s
CROSS JOIN marketing_spend m
LIMIT 1;
-- BUSINESS INTERPRETATION:
-- The dashboard provides a complete
-- overview of the company's financial
-- performance using revenue,
-- profitability, cost, refund,
-- discount, and marketing metrics.

-- The output helps management evaluate
-- overall business efficiency and
-- understand how operational costs
-- and marketing expenditure impact
-- revenue and profitability.

-- This serves as an executive summary
-- for monitoring overall business health.

-- =====================================================
-- QUERY 6 — REGIONAL FINANCIAL PERFORMANCE
-- =====================================================

-- BUSINESS PROBLEM:
-- Different regions may generate
-- different levels of revenue,
-- profitability, and customer acquisition
-- efficiency, making it difficult to
-- identify the best-performing markets.

-- OBJECTIVE:
-- Compare financial performance
-- across regions using revenue,
-- profit, cost, and customer
-- acquisition metrics.

-- FINANCIAL METRICS:
-- Revenue
-- Net Revenue
-- Total Profit
-- Profit Margin %
-- Customer Acquisition Cost (CAC)

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • ROUND()
-- • JOINs
-- • CTEs
-- • ORDER BY

WITH financial_data AS(
SELECT
   c.region,

   SUM(o.revenue) AS total_revenue,

   SUM(o.net_revenue) AS total_net_revenue,

   SUM(o.gross_margin) AS total_profit,

   ROUND(
      (SUM(o.gross_margin)/
      NULLIF(SUM(o.revenue),0))*100
      ,2
   ) AS profit_margin

FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.region
),
marketing_data AS(
SELECT
   region,
   SUM(spend_amount) AS marketing_expenditure,

   ROUND(
      SUM(spend_amount)/
      NULLIF(SUM(new_customers),0)
      ,2
   ) AS customer_acquisition_cost

FROM marketing_spend
GROUP BY region
)
SELECT
   f.region,

   f.total_revenue,

   f.total_net_revenue,

   f.total_profit,

   f.profit_margin,

   m.marketing_expenditure,

   m.customer_acquisition_cost

FROM financial_data f
INNER JOIN marketing_data m
ON f.region = m.region
ORDER BY total_profit DESC;
       
-- BUSINESS INTERPRETATION:
-- The report compares financial
-- performance across different regions
-- using revenue, profit, margin,
-- marketing expenditure, and CAC.

-- While some regions generate higher
-- total profit, profit margin provides
-- additional insight into the efficiency
-- of revenue generation.

-- The analysis helps businesses evaluate
-- regional profitability and optimize
-- marketing budget allocation.

-- =====================================================
-- QUERY 7 — QUARTERLY FINANCIAL PERFORMANCE
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to understand
-- seasonal patterns in revenue,
-- profitability, and costs
-- across different quarters.

-- OBJECTIVE:
-- Compare financial performance
-- across Q1, Q2, Q3, and Q4
-- to identify seasonal trends
-- and high-performing periods.

-- FINANCIAL METRICS:
-- Revenue
-- Net Revenue
-- Profit
-- Profit Margin %

-- SQL CONCEPTS USED:
-- • CASE WHEN
-- • MONTH()
-- • GROUP BY
-- • SUM()
-- • ROUND()
-- • ORDER BY

SELECT
   CASE 
       WHEN MONTH(order_date) BETWEEN 1 AND 3 THEN 'Q1'
       WHEN MONTH(order_date) BETWEEN 4 AND 6 THEN 'Q2'
       WHEN MONTH(order_date) BETWEEN 7 AND 9 THEN 'Q3'
       ELSE 'Q4'
   END AS quarter_,
   
   SUM(revenue) AS total_revenue,
   SUM(net_revenue) AS total_net_revenue,
   SUM(gross_margin) AS total_profit,
   
   ROUND(
         (SUM(gross_margin)/NULLIF(SUM(revenue),0))*100,2
		) AS profit_margin
FROM orders
GROUP BY quarter_
ORDER BY quarter_ ASC ;
-- BUSINESS INTERPRETATION:
-- The report compares financial
-- performance across different quarters
-- using revenue, net revenue,
-- profit, and profit margin.

-- The output helps identify seasonal
-- trends in profitability and highlights
-- periods of stronger or weaker
-- financial performance.

-- This analysis supports financial
-- planning, budgeting, and
-- seasonal business strategy.

-- =====================================================
-- QUERY 8 — EXECUTIVE INTELLIGENCE REPORT
-- =====================================================

-- BUSINESS PROBLEM:
-- Executives need a single report
-- highlighting the most important
-- business strengths, weaknesses,
-- and performance indicators.

-- OBJECTIVE:
-- Build a final executive intelligence
-- report containing the best and worst
-- performing business segments along
-- with an overall business health score.

-- FINANCIAL INSIGHTS REQUIRED:
-- 1. Best Channel by Marketing ROI
-- 2. Best Category by Profit Margin
-- 3. Worst Category by Refund Rate
-- 4. Best Region by Net Revenue
-- 5. Overall Business Health Score

-- SQL CONCEPTS USED:
-- • Multiple CTEs
-- • CROSS JOIN
-- • ORDER BY
-- • LIMIT 1
-- • ROUND()
-- • CASE WHEN
-- • Executive Dashboard Design

WITH temp AS(
 SELECT
   c.acquisition_channel AS best_roi_channel,

   ROUND(
      (
      SUM(o.revenue)
      /
      NULLIF(SUM(m.spend_amount),0)
      ),2
   ) AS marketing_roi

 FROM customers c

 INNER JOIN orders o
 ON c.customer_id = o.customer_id

 INNER JOIN marketing_spend m
 ON c.acquisition_channel = m.channel

 GROUP BY c.acquisition_channel

 ORDER BY marketing_roi DESC

 LIMIT 1
),
temp2 AS (
 SELECT
   product_category AS best_category,
   
   ROUND(
          (SUM(gross_margin)/NULLIF(SUM(revenue),0))*100,2
          )AS profit_margin
 FROM orders
 GROUP BY product_category
 ORDER BY (SUM(gross_margin)/NULLIF(SUM(revenue),0))*100 DESC
 LIMIT 1
),
temp3 AS(
 SELECT
   product_category AS worst_category,
   
   ROUND(
          (SUM(refund_amount)/NULLIF(SUM(revenue),0))*100,2
          )AS refund_rate
 FROM orders
 GROUP BY product_category
 ORDER BY (SUM(refund_amount)/NULLIF(SUM(revenue),0))*100 DESC
 LIMIT 1
),
temp4 AS(
  SELECT
    c.region AS best_region_by_net_revenue,
    SUM(o.net_revenue) AS total_net_revenue
  FROM customers c
  INNER JOIN orders o
  ON c.customer_id = o.customer_id
  GROUP BY c.region
  ORDER BY SUM(o.net_revenue) DESC
  LIMIT 1
)
SELECT *
FROM temp
CROSS JOIN temp2
CROSS JOIN temp3
CROSS JOIN temp4;

-- BUSINESS INTERPRETATION:
-- The Executive Intelligence Report
-- provides a consolidated view of the
-- company's most important business
-- performance indicators.

-- The report identifies the marketing
-- channel with the highest ROI,
-- the most profitable product category,
-- the category with the highest refund risk,
-- and the region generating the highest
-- net revenue.

-- By combining these insights into a
-- single dashboard, management can quickly
-- identify key growth drivers and areas
-- requiring improvement.

-- This analysis supports strategic decision-making,
-- resource allocation, profitability improvement,
-- and long-term business planning by providing
-- an overall snapshot of business performance.
