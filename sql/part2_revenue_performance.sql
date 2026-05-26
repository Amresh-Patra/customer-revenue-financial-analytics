-- =====================================================
-- PART 2 — COST & PROFITABILITY ANALYTICS
-- =====================================================

-- This section focuses on analyzing
-- operational costs, profitability,
-- discount impact, shipping efficiency,
-- and revenue leakage across the business.

-- The objective is to understand how
-- different cost components affect
-- overall profit margins and financial
-- performance of the company.

-- This analysis helps businesses optimize:
-- • Cost efficiency
-- • Profitability
-- • Discount strategies
-- • Operational expenses
-- • Financial decision-making
-- =====================================================

-- =====================================================
-- CONCEPT 1 — COST STRUCTURE ANALYSIS
-- =====================================================

-- QUERY 1 — TOTAL COST BREAKDOWN
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to understand
-- how operational costs impact
-- overall revenue and profitability.

-- OBJECTIVE:
-- Analyze total operational costs
-- including product cost, shipping,
-- delivery, and payment processing fees
-- against total revenue.

-- FINANCIAL METRIC:
-- Total Cost Structure
-- Cost-to-Revenue Analysis

-- SQL CONCEPTS USED:
-- • SUM()
-- • ROUND()
-- • Aggregations

SELECT
  SUM(discount) AS total_discount,
  SUM(cost_of_goods) AS cost_of_production,
  SUM(shipping_cost) AS total_shipping_cost,
  SUM(delivery_region_cost) AS total_delivery_cost,
  SUM(refund_amount) AS total_refund,
  SUM(payment_processing_fee) AS total_payment_processing_fee,
  SUM(revenue) AS total_revenue
FROM orders;

-- BUSINESS INTERPRETATION:
-- The report provides a complete overview
-- of major operational and financial costs
-- against total business revenue.

-- The analysis helps businesses understand
-- how discounts, shipping expenses,
-- delivery costs, refunds,
-- and production costs impact
-- overall profitability and financial efficiency.

-- Businesses can use this data
-- to identify cost-heavy operations,
-- reduce revenue leakage,
-- and improve long-term profit margins.

-- =====================================================
-- QUERY 2 — COST PER ORDER ANALYSIS
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to measure
-- average operational cost per order
-- to evaluate cost efficiency
-- and profitability management.

-- OBJECTIVE:
-- Analyze average production cost,
-- shipping cost, delivery cost,
-- payment fee, and discount per order.

-- FINANCIAL METRIC:
-- Cost Per Order Analysis

-- SQL CONCEPTS USED:
-- • SUM()
-- • COUNT()
-- • ROUND()
-- • NULLIF()

SELECT

ROUND(
AVG(
 IFNULL(cost_of_goods,0)
 + IFNULL(shipping_cost,0)
 + IFNULL(delivery_region_cost,0)
 + IFNULL(payment_processing_fee,0)
 + IFNULL(discount,0)
),2
) AS avg_operational_cost
FROM orders;

-- BUSINESS INTERPRETATION:
-- The report shows the average
-- operational cost incurred per order,
-- including production, shipping,
-- delivery, payment processing,
-- and discount-related expenses.

-- The analysis helps businesses understand
-- operational cost efficiency
-- and overall expense burden per order.

-- However, the analysis becomes more meaningful
-- when compared with average revenue
-- and average profit metrics
-- to evaluate true profitability performance.

-- =====================================================
-- CONCEPT 2 — PROFITABILITY ANALYSIS
-- =====================================================

-- QUERY 3 — GROSS MARGIN BY PRODUCT CATEGORY
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- which product categories generate
-- the highest profitability.

-- OBJECTIVE:
-- Analyze gross margin, revenue,
-- and profitability ranking
-- across product categories.

-- FINANCIAL METRIC:
-- Gross Margin Analysis
-- Profitability Ranking

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • DENSE_RANK()
-- • Window Functions
-- • ROUND()

SELECT
  product_category,
  SUM(revenue) AS total_revenue,
  SUM(net_revenue) AS total_net_revenue,
  SUM(gross_margin) AS total_margin,
  DENSE_RANK() OVER(ORDER BY SUM(gross_margin) DESC)AS performance_rnk
FROM orders
GROUP BY product_category;

-- BUSINESS INTERPRETATION:
-- The report shows that Fashion
-- and Beauty categories generate
-- the highest profitability,
-- making them major contributors
-- to overall business margin performance.

-- Categories with lower gross margins
-- may reflect higher competition,
-- lower pricing power,
-- or operational cost pressures.

-- This analysis helps businesses identify
-- highly profitable categories
-- and optimize marketing investment,
-- pricing strategy,
-- and R&D allocation decisions.

-- =====================================================
-- QUERY 4 — REVENUE VS PROFIT COMPARISON
-- =====================================================

-- BUSINESS PROBLEM:
-- High revenue does not always
-- mean high profitability.
-- Businesses need to compare
-- revenue and profit together
-- to identify financially efficient categories.

-- OBJECTIVE:
-- Compare total revenue
-- against gross profit
-- across product categories.

-- FINANCIAL METRIC:
-- Revenue vs Profitability Analysis

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • ROUND()
-- • ORDER BY
--  DENSE RANK
--  INNER JOIN

WITH temp AS(
  SELECT
    product_category,
    SUM(revenue) AS total_revenue,
    DENSE_RANK() OVER(ORDER BY SUM(revenue) DESC) AS rnk_as_per_revenue
  FROM orders
  GROUP BY product_category
),
grouped AS(
 SELECT
   product_category,
   SUM(gross_margin) AS total_profit,
   DENSE_RANK() OVER(ORDER BY SUM(gross_margin) DESC) AS rnk_as_per_profit
 FROM orders
 GROUP BY product_category
)
SELECT t.*,g.*
FROM temp t
INNER JOIN grouped g
ON t.product_category = g.product_category;

-- BUSINESS INTERPRETATION:
-- The report compares product categories
-- based on both total revenue
-- and total profitability rankings.

-- The analysis helps businesses identify
-- whether high-revenue categories
-- are also generating strong profit margins
-- and financial efficiency.

-- In this dataset, several categories
-- maintain similar rankings across
-- both revenue and profitability,
-- indicating relatively balanced
-- financial performance.

-- This analysis supports strategic decisions
-- related to pricing,
-- operational efficiency,
-- marketing investment,
-- and category-level resource allocation.

-- =====================================================
-- QUERY 5 — PROFIT MARGIN PERCENTAGE
-- BY PRODUCT CATEGORY
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- which product categories generate
-- the highest profit margin efficiency.

-- OBJECTIVE:
-- Analyze profit margin percentage
-- across product categories using:
-- gross_margin / revenue * 100

-- FINANCIAL METRIC:
-- Profit Margin %
-- = Gross Profit / Revenue * 100

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • ROUND()
-- • NULLIF()
-- • DENSE_RANK()

SELECT
  product_category,
  SUM(revenue) AS total_revenue,
  SUM(gross_margin) AS total_profit,
  ROUND(
        (SUM(gross_margin)/NULLIF(SUM(revenue),0))*100,2
        ) AS profit_percentage,
  DENSE_RANK() OVER(ORDER BY SUM(gross_margin) DESC) AS performance_rnk
FROM orders
GROUP BY product_category;

-- BUSINESS INTERPRETATION:
-- The report shows that Fashion
-- and Beauty categories generate
-- the highest profit margin efficiency,
-- indicating strong profitability
-- and effective pricing performance.

-- Categories with lower profit margins
-- may reflect higher operational costs,
-- stronger market competition,
-- or lower pricing flexibility.

-- This analysis helps businesses optimize
-- pricing strategies,
-- category-level investment,
-- and profitability-focused
-- resource allocation decisions.

-- =====================================================
-- CONCEPT 3 — DISCOUNT IMPACT ANALYSIS
-- =====================================================

-- QUERY 6 — DISCOUNT VS REVENUE ANALYSIS
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to understand
-- how discounts impact overall revenue
-- and profitability performance.

-- OBJECTIVE:
-- Compare total discount provided
-- against total revenue generated
-- across product categories.

-- FINANCIAL METRIC:
-- Discount-to-Revenue Ratio

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • ROUND()
-- • NULLIF()
-- • ORDER BY

WITH temp AS(
 SELECT
   product_category,
   SUM(revenue) AS total_revenue,
   SUM(gross_margin) AS total_profit,
   SUM(discount) AS discount_cost
 FROM orders
 GROUP BY product_category
)
SELECT *,
    ROUND(
          (discount_cost/NULLIF(total_revenue,0))*100,2
          )AS contribution_of_cost,
          
	ROUND(
          (total_profit/NULLIF(total_revenue,0))*100,2
          )AS contribution_of_profit
FROM temp
ORDER BY total_profit DESC;
-- BUSINESS INTERPRETATION:
-- The report compares discount cost
-- against total revenue and profitability
-- across product categories.

-- Several categories maintain strong
-- profitability despite offering discounts,
-- indicating effective pricing
-- and discount management strategies.

-- Categories with higher discount percentages
-- but weaker profit margins may require
-- optimized pricing policies
-- and better promotional efficiency.

-- This analysis helps businesses evaluate
-- discount effectiveness,
-- profitability impact,
-- and category-level pricing decisions.

-- =====================================================
-- QUERY 7 — DISCOUNT IMPACT BY CATEGORY
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to identify
-- which product categories receive
-- the highest discount exposure
-- and how discounts impact profitability.

-- OBJECTIVE:
-- Analyze average discount percentage
-- across product categories.

-- FINANCIAL METRIC:
-- Average Discount %
-- = Total Discount / Total Revenue * 100

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • ROUND()
-- • NULLIF()
-- • ORDER BY

SELECT
  product_category,
  SUM(revenue) AS total_revenue,
  SUM(gross_margin) AS total_profit,
  SUM(discount) AS discount_cost,
  ROUND(
        (SUM(discount)/NULLIF(SUM(revenue),0))*100,2
        )AS discount_share_pct
FROM orders
GROUP BY product_category
ORDER BY SUM(gross_margin) DESC;
-- BUSINESS INTERPRETATION:
-- The report shows that Fashion
-- and Beauty categories maintain
-- high revenue and profitability
-- despite offering larger discounts.

-- This indicates that strategic discounts
-- may be helping these categories
-- drive stronger customer demand
-- and higher sales performance.

-- The analysis helps businesses evaluate
-- whether discount strategies
-- are effectively supporting
-- revenue growth and profitability
-- across different product categories.

-- =====================================================
-- QUERY 8 — HIGH DISCOUNT VS LOW DISCOUNT
-- ORDER PERFORMANCE ANALYSIS
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to understand
-- whether high discounts actually
-- improve revenue and profitability.

-- OBJECTIVE:
-- Compare revenue and profitability
-- between high-discount
-- and low-discount orders
-- using CASE WHEN segmentation.

-- FINANCIAL METRIC:
-- Discount Effectiveness Analysis

-- SQL CONCEPTS USED:
-- • CASE WHEN
-- • GROUP BY
-- • SUM()
-- • COUNT()
-- • ROUND()

WITH temp AS(
 SELECT
   CASE
     WHEN discount > 100 THEN 'High Discount'
     ELSE 'Low Discount'
   END AS discount_status,
   revenue,
   gross_margin,
   order_id
 FROM orders
)
SELECT
  discount_status,
  COUNT(order_id) AS total_orders,
  SUM(revenue) AS total_revenue,
  SUM(gross_margin) AS total_profit,
  
  ROUND(
      (SUM(gross_margin)
/NULLIF(SUM(revenue),0))*100,2
  ) AS profit_margin_pct
  
FROM temp
GROUP BY discount_status;
-- BUSINESS INTERPRETATION:
-- The analysis compares
-- high-discount and low-discount orders
-- to evaluate discount effectiveness
-- on revenue and profitability.

-- The report suggests that
-- higher discounts may help increase
-- customer purchases and revenue generation
-- in certain scenarios.

-- However, businesses must carefully balance
-- discount strategies with profitability
-- to avoid excessive margin reduction
-- and long-term financial pressure.

-- =====================================================
-- CONCEPT 4 — SHIPPING COST ANALYSIS
-- =====================================================

-- QUERY 9 — SHIPPING COST VS REVENUE
-- RATIO BY REGION
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to analyze
-- regional shipping efficiency
-- and understand how shipping costs
-- impact regional profitability.

-- OBJECTIVE:
-- Compare shipping cost
-- against total revenue
-- across different regions.

-- FINANCIAL METRIC:
-- Shipping Cost Ratio %
-- = Shipping Cost / Revenue * 100

-- SQL CONCEPTS USED:
-- • GROUP BY
-- • SUM()
-- • ROUND()
-- • NULLIF()
-- • ORDER BY

SELECT
  c.region,
  SUM(o.revenue) AS total_revenue,
  SUM(o.gross_margin) AS total_margin,
  SUM(o.shipping_cost) AS total_shipping_cost,
  
  ROUND(
        (SUM(o.shipping_cost)/NULLIF(SUM(o.revenue),0))*100,2
        ) AS shipping_cost_share
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.region
ORDER BY SUM(o.shipping_cost) DESC;
-- BUSINESS INTERPRETATION:
-- The report shows that Tier 2 regions
-- experience relatively higher shipping
-- cost ratios compared to several
-- higher-revenue regions.

-- This may reflect operational challenges
-- such as logistics complexity,
-- delivery distance,
-- fuel expenses,
-- or lower order density.

-- Despite higher shipping costs,
-- most regions maintain manageable
-- shipping cost ratios relative to revenue.

-- Businesses can improve regional
-- profitability by optimizing logistics,
-- improving supply chain efficiency,
-- and adjusting pricing or margin strategies
-- in high-cost regions.


-- =====================================================
-- QUERY 10 — PAYMENT PROCESSING FEE
-- IMPACT ON NET REVENUE
-- =====================================================

-- BUSINESS PROBLEM:
-- Businesses need to understand
-- how payment processing fees
-- impact overall revenue
-- and profitability performance.

-- OBJECTIVE:
-- Analyze payment processing fees
-- against total revenue
-- and net revenue.

-- FINANCIAL METRIC:
-- Payment Fee Ratio %
-- = Payment Processing Fee
--   / Revenue * 100

-- SQL CONCEPTS USED:
-- • SUM()
-- • ROUND()
-- • NULLIF()
-- • Aggregations

WITH temp AS(
 SELECT
     payment_processing_fee,
   CASE
     WHEN payment_processing_fee>100 THEN 'High Fees'
     ELSE 'Low Fees'
     END AS Payment_Fee_status,
     revenue,
     net_revenue,
     gross_margin
FROM orders
)
SELECT
  Payment_Fee_status,
  SUM(revenue) AS total_revenue,
  SUM(net_revenue) AS total_net_revenue,
  SUM(gross_margin)AS total_profit,
  SUM(payment_processing_fee) AS total_payment_fee,
  
  ROUND(
	    (SUM(payment_processing_fee)/NULLIF(SUM(revenue),0))*100,2
        )AS payment_fee_share
  
FROM temp
GROUP BY Payment_Fee_status;
-- BUSINESS INTERPRETATION:
-- The report compares high-fee
-- and low-fee payment transactions
-- to evaluate their impact
-- on revenue and profitability.

-- Although higher-fee transactions
-- generate lower total revenue,
-- the payment fee ratio remains
-- relatively consistent across both segments,
-- indicating stable transaction cost structure.

-- Payment processing costs are often influenced
-- by external factors such as gateway charges,
-- taxes, and transaction infrastructure costs.

-- Businesses can improve profitability
-- by optimizing payment systems,
-- reducing transaction costs,
-- and promoting efficient payment methods.
