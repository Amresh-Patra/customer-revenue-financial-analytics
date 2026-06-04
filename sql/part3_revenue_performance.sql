-- =====================================================
-- PART 3 — MARKETING FINANCIAL ROI ANALYTICS
-- =====================================================

-- This section focuses on analyzing
-- customer acquisition cost (CAC),
-- marketing return on investment (ROI),
-- conversion efficiency,
-- and campaign profitability.

-- The objective is to evaluate how
-- effectively marketing spending
-- generates customers, revenue,
-- and long-term business profitability.

-- This analysis helps businesses optimize:
-- • Marketing efficiency
-- • Customer acquisition strategy
-- • ROI performance
-- • Campaign profitability
-- • Financial growth decisions
-- =====================================================

-- =====================================================
-- CONCEPT 1 — CUSTOMER ACQUISITION COST (CAC)
-- =====================================================

-- QUERY 1 — CAC BY CHANNEL
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to understand
-- how much marketing spend
-- is required to acquire
-- one customer across channels.

-- OBJECTIVE:
-- Analyze Customer Acquisition Cost (CAC)
-- by marketing channel.

-- FINANCIAL METRIC:
-- CAC =
-- Total Marketing Spend / New Customers

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • ROUND()
-- • NULLIF()

SELECT
  channel,
  SUM(spend_amount) AS total_spending,
  SUM(new_customers) AS total_new_customers,
  ROUND(
        (SUM(spend_amount)/NULLIF(SUM(new_customers),0)),2
        ) AS customer_aquision_cost
FROM marketing_spend
GROUP BY channel;
-- BUSINESS INTERPRETATION:
-- The report compares customer
-- acquisition costs across different
-- marketing channels to evaluate
-- marketing efficiency and sustainability.

-- Organic channels show significantly
-- lower acquisition costs,
-- indicating more cost-efficient
-- customer acquisition performance.

-- Channels with higher CAC may require
-- stronger conversion performance
-- or higher customer lifetime value
-- to remain financially sustainable.

-- This analysis helps businesses optimize
-- marketing allocation,
-- acquisition strategy,
-- and long-term growth planning.

-- =====================================================
-- QUERY 2 — CAC BY REGION
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- which regions acquire customers
-- more efficiently and cost-effectively.

-- OBJECTIVE:
-- Analyze Customer Acquisition Cost (CAC)
-- across different regions.

-- FINANCIAL METRIC:
-- Regional CAC =
-- Regional Marketing Spend / Regional Customers

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • ROUND()
-- • NULLIF()
-- • ORDER BY
SELECT
  region,
  ROUND(SUM(spend_amount),2) AS total_spending,
  SUM(new_customers) AS total_new_customers,
  ROUND(
        (SUM(spend_amount)/NULLIF(SUM(new_customers),0)),2
        ) AS customer_acquisition_cost
FROM marketing_spend
GROUP BY region
ORDER BY customer_acquisition_cost ASC;
-- BUSINESS INTERPRETATION:
-- The report compares customer
-- acquisition costs across regions
-- to evaluate regional marketing efficiency.

-- Most regions maintain relatively
-- stable acquisition costs,
-- indicating balanced marketing performance
-- across different markets.

-- Regions such as North and South
-- acquire higher numbers of customers,
-- although they also require
-- greater marketing expenditure.

-- This analysis helps businesses optimize
-- regional marketing allocation,
-- customer acquisition strategy,
-- and expansion planning.

-- =====================================================
-- QUERY 3 — MONTH OVER MONTH CAC TREND
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to monitor
-- whether customer acquisition
-- is becoming more expensive
-- or more efficient over time.

-- OBJECTIVE:
-- Analyze month-over-month
-- Customer Acquisition Cost (CAC)
-- trend using LAG().

-- FINANCIAL METRIC:
-- CAC Trend Analysis

-- SQL CONCEPTS USED:
-- • CTEs
-- • LAG()
-- • Window Functions
-- • DATE_FORMAT()
-- • ROUND()
-- • NULLIF()

WITH temp AS(
 SELECT
   month,
   ROUND(SUM(spend_amount),2) AS total_spending,
   SUM(new_customers) AS total_new_customers,
  
   ROUND(
        (SUM(spend_amount)/NULLIF(SUM(new_customers),0)),2
        ) AS customer_acquisition_cost
        
FROM marketing_spend
GROUP BY month
),
grouped AS(
 SELECT *,
    LAG(customer_acquisition_cost) OVER(ORDER BY month) AS prev_cost
 FROM temp
)
SELECT *,
    ROUND(
          ((customer_acquisition_cost-prev_cost)/
          NULLIF(prev_cost,0))*100,2) AS change_in_cost
FROM grouped;
-- BUSINESS INTERPRETATION:
-- The report analyzes month-over-month
-- customer acquisition cost trends
-- to evaluate changes
-- in marketing efficiency over time.

-- Several periods show declining CAC,
-- indicating improved customer acquisition
-- efficiency and better utilization
-- of marketing expenditure.

-- Lower acquisition costs may reflect
-- stronger campaign performance,
-- improved targeting strategies,
-- or more efficient conversion channels.

-- This analysis helps businesses monitor
-- long-term marketing sustainability
-- and optimize acquisition strategies.

-- =====================================================
-- CONCEPT 2 — MARKETING ROI ANALYSIS
-- =====================================================

-- QUERY 4 — MARKETING ROI BY CHANNEL
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to evaluate
-- whether marketing channels
-- are generating sufficient revenue
-- compared to marketing expenditure.

-- OBJECTIVE:
-- Analyze Return on Investment (ROI)
-- across different marketing channels.

-- FINANCIAL METRIC:
-- ROI =
-- Revenue Generated / Marketing Spend * 100

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • ROUND()
-- • NULLIF()
-- • ORDER BY
WITH temp AS(
  SELECT
     c.acquisition_channel AS channel_,
     SUM(o.revenue) AS total_revenue
  FROM customers c
  INNER JOIN orders o
  ON c.customer_id = o.customer_id
  GROUP BY c.acquisition_channel
),
grouped AS(
  SELECT 
    channel,
    ROUND(SUM(spend_amount),2) AS marketing_expenditure
FROM marketing_spend 
GROUP BY channel
)
SELECT 
   t.channel_,
   t.total_revenue,
   g.marketing_expenditure,
   ROUND(
         (t.total_revenue/NULLIF(g.marketing_expenditure,0)),2
         ) AS revenue_per_cost
FROM temp t
INNER JOIN grouped g
ON t.channel_ = g.channel
ORDER BY revenue_per_cost DESC;
-- BUSINESS INTERPRETATION:
-- The report compares marketing channels
-- based on total revenue generated
-- relative to marketing expenditure.

-- Organic channels generate the highest
-- revenue efficiency while maintaining
-- relatively low marketing costs,
-- indicating strong long-term
-- acquisition sustainability.

-- Several paid channels require
-- significantly higher marketing investment
-- to generate comparable revenue performance.

-- This analysis helps businesses optimize
-- channel allocation,
-- marketing efficiency,
-- and long-term customer acquisition strategy.

-- =====================================================
-- QUERY 5 — BEST ROI CHANNEL RANKING
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- which marketing channels
-- generate the highest financial efficiency
-- and long-term marketing value.

-- OBJECTIVE:
-- Rank marketing channels
-- based on revenue generated
-- per marketing spend.

-- FINANCIAL METRIC:
-- Marketing Efficiency Ranking

-- SQL CONCEPTS USED:
-- • CTEs
-- • DENSE_RANK()
-- • GROUP BY
-- • INNER JOIN
-- • ROUND()
-- • NULLIF()
WITH temp AS(
  SELECT
     c.acquisition_channel AS channel_,
     SUM(o.revenue) AS total_revenue
  FROM customers c
  INNER JOIN orders o
  ON c.customer_id = o.customer_id
  GROUP BY c.acquisition_channel
),
grouped AS(
  SELECT 
    channel,
    ROUND(SUM(spend_amount),2) AS marketing_expenditure
FROM marketing_spend 
GROUP BY channel
),
 ranked AS(
SELECT 
   t.channel_,
   t.total_revenue,
   g.marketing_expenditure,
   ROUND(
         (t.total_revenue/NULLIF(g.marketing_expenditure,0)),2
         ) AS revenue_per_unit_spent
FROM temp t
INNER JOIN grouped g
ON t.channel_ = g.channel
)
SELECT *,
  DENSE_RANK() OVER(ORDER BY  revenue_per_unit_spent DESC) AS efficiency_rnk
FROM ranked;
-- BUSINESS INTERPRETATION:
-- The report ranks marketing channels
-- based on revenue generated
-- per unit of marketing expenditure.

-- Organic channels demonstrate
-- the highest financial efficiency,
-- generating strong revenue
-- while maintaining relatively low marketing costs.

-- Some paid channels generate
-- high total revenue,
-- but require substantially larger
-- marketing expenditure,
-- resulting in lower efficiency ratios.

-- This analysis helps businesses optimize
-- marketing allocation,
-- channel prioritization,
-- and long-term growth strategy
-- based on financial performance efficiency.

-- =====================================================
-- QUERY 6 — MONTHLY MARKETING ROI TREND
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to monitor
-- whether marketing efficiency
-- is improving or declining over time.

-- OBJECTIVE:
-- Analyze month-over-month
-- marketing ROI trend
-- using LAG().

-- FINANCIAL METRIC:
-- Monthly Marketing Efficiency Trend

-- SQL CONCEPTS USED:
-- • CTEs
-- • LAG()
-- • Window Functions
-- • GROUP BY
-- • ROUND()
-- • NULLIF()
WITH temp AS(
  SELECT
    acquisition_month AS month_,
    SUM(o.revenue) AS total_revenue
  FROM customers c
  INNER JOIN orders o
  ON c.customer_id = o.customer_id
  GROUP BY acquisition_month
),
grouped AS(
  SELECT
    month,
    SUM(spend_amount) AS marketing_expenditure
  FROM marketing_spend
  GROUP BY month
),

marketing_data AS(
  SELECT
    t.month_,
    t.total_revenue,
    g.marketing_expenditure,

    ROUND(
      (t.total_revenue
      /NULLIF(g.marketing_expenditure,0)),2
    ) AS revenue_per_unit_spent

  FROM temp t
  INNER JOIN grouped g
  ON t.month_ = g.month
)
SELECT *,
LAG(revenue_per_unit_spent)
OVER(ORDER BY month_) AS prev_month_efficiency
FROM marketing_data;
-- BUSINESS INTERPRETATION:
-- The report analyzes month-over-month
-- marketing efficiency trends
-- by comparing revenue generated
-- relative to marketing expenditure.

-- Several periods show improving
-- marketing efficiency,
-- indicating better utilization
-- of marketing spending over time.

-- Changes in marketing efficiency
-- may reflect campaign performance,
-- audience targeting quality,
-- seasonal demand,
-- or customer acquisition effectiveness.

-- This analysis helps businesses monitor
-- long-term marketing performance,
-- optimize campaign spending,
-- and improve marketing ROI sustainability.

-- =====================================================
-- QUERY 7 — REVENUE GENERATED
-- PER MARKETING DOLLAR
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to measure
-- how efficiently marketing spending
-- converts into revenue generation.

-- OBJECTIVE:
-- Analyze how much revenue
-- is generated for every unit
-- of marketing expenditure
-- across channels.

-- FINANCIAL METRIC:
-- Revenue Per Marketing Dollar =
-- Revenue / Marketing Spend
WITH revenue_data AS(
SELECT
   c.acquisition_channel AS channel_,
   SUM(o.revenue) AS total_revenue
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.acquisition_channel
),
marketing_data AS(
SELECT
   channel,
   SUM(spend_amount) AS marketing_expenditure
FROM marketing_spend
GROUP BY channel
)
SELECT
   r.channel_,
   r.total_revenue,
   m.marketing_expenditure,

   ROUND(
        (r.total_revenue
        /NULLIF(m.marketing_expenditure,0))
        ,2
        ) AS revenue_per_marketing_dollar

FROM revenue_data r

INNER JOIN marketing_data m
ON r.channel_ = m.channel

ORDER BY revenue_per_marketing_dollar DESC;
-- BUSINESS INTERPRETATION:
-- The report compares marketing channels
-- based on revenue generated
-- per unit of marketing expenditure.

-- Organic channels demonstrate
-- the highest marketing efficiency,
-- generating significantly higher revenue
-- for every unit of marketing spend.

-- This analysis helps businesses identify
-- sustainable and cost-efficient
-- marketing channels for long-term growth
-- and optimize marketing budget allocation.

-- =====================================================
-- QUERY 8 — CONVERSION VALUE ANALYSIS
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to evaluate
-- the financial quality
-- of customer conversions
-- across marketing channels.

-- OBJECTIVE:
-- Analyze average revenue generated
-- per conversion by channel.

-- FINANCIAL METRIC:
-- Revenue Per Conversion =
-- Total Revenue / Total Conversions
WITH temp AS(
 SELECT
   c.acquisition_channel,
   SUM(o.revenue) AS total_revenue,

   ROUND(
        (SUM(o.revenue)
        /NULLIF(COUNT(o.order_id),0)),2
        ) AS avg_order_amount

 FROM customers c
 INNER JOIN orders o
 ON c.customer_id = o.customer_id
 GROUP BY acquisition_channel
),
grouped AS(
SELECT
   channel,
   SUM(conversions) AS total_conversions
FROM marketing_spend
GROUP BY channel
)
SELECT
   t.acquisition_channel,
   t.total_revenue,
   t.avg_order_amount,
   g.total_conversions,

   ROUND(
        (t.total_revenue
        /NULLIF(g.total_conversions,0)),2
        ) AS revenue_per_conversion
FROM temp t
INNER JOIN grouped g
ON t.acquisition_channel = g.channel
ORDER BY revenue_per_conversion DESC;
-- BUSINESS INTERPRETATION:
-- The report evaluates the financial value
-- generated per customer conversion
-- across different marketing channels.

-- Organic channels generate
-- the highest revenue per conversion,
-- indicating stronger conversion quality
-- and higher-value customer acquisition.

-- This analysis helps businesses optimize
-- marketing allocation,
-- conversion quality,
-- and long-term campaign sustainability.

-- =====================================================
-- QUERY 9 — NET REVENUE AFTER
-- MARKETING SPEND
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to evaluate
-- customer profitability
-- after accounting for
-- marketing acquisition costs.

-- OBJECTIVE:
-- Analyze profitability remaining
-- after deducting marketing expenditure
-- across channels.

-- FINANCIAL METRIC:
-- Profit After Marketing Spend =
-- Revenue - Marketing Spend
WITH temp AS(
SELECT
   c.acquisition_channel,
   SUM(o.net_revenue) AS total_revenue,

   ROUND(
        (SUM(o.net_revenue)
        /NULLIF(COUNT(DISTINCT o.customer_id),0)),2
        ) AS per_customer_revenue

FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY acquisition_channel
),

grouped AS(
SELECT
   channel,
   SUM(spend_amount) AS marketing_expenditure,
   ROUND(
        (SUM(spend_amount)
        /NULLIF(SUM(new_customers),0)),2
        ) AS per_customer_expenditure

FROM marketing_spend
GROUP BY channel
)
SELECT
   t.acquisition_channel,

   ROUND(
        (t.total_revenue
        - g.marketing_expenditure),2
        ) AS profit_after_marketing,

   ROUND(
        (t.per_customer_revenue
        - g.per_customer_expenditure),2
        ) AS per_customer_profit

FROM temp t
INNER JOIN grouped g
ON t.acquisition_channel = g.channel
ORDER BY profit_after_marketing DESC;
-- BUSINESS INTERPRETATION:
-- The report evaluates customer
-- profitability after accounting
-- for marketing acquisition costs
-- across different channels.

-- Organic channels demonstrate
-- the highest per-customer profitability,
-- indicating strong acquisition efficiency
-- and sustainable long-term customer value.

-- This analysis helps businesses optimize
-- customer acquisition strategy,
-- marketing allocation,
-- and long-term profitability planning.

-- =====================================================
-- QUERY 10 — BREAK-EVEN ANALYSIS
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to understand
-- how many customer orders
-- are required to recover
-- marketing expenditure.

-- OBJECTIVE:
-- Analyze the number of orders
-- required to recover
-- marketing acquisition costs
-- across channels.

-- FINANCIAL METRIC:
-- Break-even Orders =
-- Marketing Spend / Average Revenue Per Order
WITH revenue_data AS(
SELECT
   c.acquisition_channel,
   COUNT(o.order_id) AS total_orders,
   SUM(o.revenue) AS total_revenue,

   ROUND(
        (SUM(o.revenue)
        /NULLIF(COUNT(o.order_id),0)),2
        ) AS avg_order_value

FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.acquisition_channel
),
marketing_data AS(
SELECT
   channel,
   SUM(spend_amount) AS marketing_expenditure
FROM marketing_spend
GROUP BY channel
)
SELECT
   r.acquisition_channel,
   r.total_orders,
   r.avg_order_value,
   m.marketing_expenditure,

   ROUND(
        (m.marketing_expenditure
        /NULLIF(r.avg_order_value,0))
        ,2
        ) AS break_even_orders

FROM revenue_data r
INNER JOIN marketing_data m
ON r.acquisition_channel = m.channel
ORDER BY break_even_orders ASC;
-- BUSINESS INTERPRETATION:
-- The report estimates the number
-- of customer orders required
-- to recover marketing expenditure
-- across different acquisition channels.

-- Channels with lower break-even orders
-- recover marketing investment faster,
-- indicating stronger operational
-- and financial efficiency.

-- This analysis helps businesses optimize
-- marketing allocation,
-- acquisition strategy,
-- and long-term campaign sustainability.
