# Revenue & Financial Performance Analytics
### End-to-End Financial Intelligence Project | MySQL

---

## Project Overview

This project presents a complete financial analytics solution built using MySQL on a real-world e-commerce dataset containing **50,000+ transactions** across 3 years.

The project goes beyond basic revenue reporting to deliver executive-level financial intelligence — covering cost structure analysis, profitability drivers, marketing ROI, customer acquisition cost, refund leakage, net revenue waterfall, and regional financial performance.

This project was specifically designed to simulate the type of financial analytics work performed by data analysts in fintech and e-commerce organizations.

---

## Business Objective

> *"Understand the true financial health of the business by analyzing revenue, costs, profitability, and marketing efficiency — going beyond gross revenue to identify where money is being made and where it is being lost."*

---

## Dataset

| File | Records | Description |
|------|---------|-------------|
| `orders.csv` | 50,000 rows | Revenue, cost of goods, discount, shipping, delivery cost, payment fees, refunds, net revenue, gross margin, order status |
| `customers.csv` | 50,000 rows | Customer profiles, acquisition channel, region, signup date, status |
| `marketing_spend.csv` | 960 rows | Monthly marketing spend, conversions, new customers by channel and region |

**Period Covered:** 2021 – 2024

**Product Categories:** Beauty, Fashion, Electronics, Home, Grocery

**Regions:** North, South, East, West, Tier2

**Acquisition Channels:** Organic, Paid Ads, Referral, Influencer

---

## Key Financial Metrics

| Metric | Value |
|--------|-------|
| Gross Revenue | ₹10.29 Crore |
| Net Revenue | ₹7.91 Crore |
| Total Profit | ₹2.07 Crore |
| Profit Margin | 20.12% |
| Refund Rate | 7.42% |
| Discount Rate | 15.68% |
| Total Marketing Spend | ₹1.23 Crore |
| Customer Acquisition Cost (CAC) | ₹60.45 |
| Marketing ROI | 8.36x |
| Total Refunds | ₹76.36 Lakh |
| Total Discounts Given | ₹1.61 Crore |
| Total Shipping Cost | ₹53.02 Lakh |
| Payment Processing Fees | ₹25.74 Lakh |
| Best Category by Margin | Fashion (29.01%) |
| Highest Refund Risk Category | Home |

---

## Project Structure

```
revenue-financial-performance-analytics/
|
|-- README.md
|
|-- data/
|   |-- customers.csv
|   |-- orders.csv
|   |-- marketing_spend.csv
|
|-- sql/
|   |-- part1_revenue_performance.sql
|   |-- part2_cost_profitability.sql
|   |-- part3_marketing_financial_roi.sql
|   |-- part4_customer_retention_analytics.sql
|   |-- part5_financial_intelligence_dashboard.sql
|
|-- results/
    |-- (query output screenshots)
```

---

## Part 1 — Revenue Performance Analytics (10 Queries)

**Business Focus:** How is revenue performing over time?

| Query | Analysis |
|-------|----------|
| Q1 | Executive revenue snapshot — total revenue, orders, AOV |
| Q2 | Revenue by order status — Completed vs Cancelled vs Returned |
| Q3 | Monthly revenue performance trend |
| Q4 | Month-over-month revenue growth using LAG() |
| Q5 | Cumulative running revenue using SUM() OVER() |
| Q6 | Year-over-year revenue comparison using LAG(revenue, 12) |
| Q7 | Best and worst performing months per year using DENSE_RANK() PARTITION BY year |
| Q8 | Revenue by product category with contribution % |
| Q9 | Category-wise MoM revenue trend using PARTITION BY |
| Q10 | Top 3 revenue months per category using DENSE_RANK() |

**Key SQL:** `LAG()`, `SUM() OVER()`, `DENSE_RANK() PARTITION BY`, `DATE_FORMAT()`, `CTEs`

---

## Part 2 — Cost & Profitability Analytics (10 Queries)

**Business Focus:** Where is money being spent? Which categories are truly profitable?

| Query | Analysis |
|-------|----------|
| Q1 | Total cost breakdown — all cost components vs revenue |
| Q2 | Average operational cost per order |
| Q3 | Gross margin by product category with profitability ranking |
| Q4 | Revenue vs profit comparison — high revenue ≠ high profit |
| Q5 | Profit margin % by category |
| Q6 | Discount vs revenue analysis — discount-to-revenue ratio |
| Q7 | Discount impact by category — avg discount % per category |
| Q8 | High discount vs low discount order performance |
| Q9 | Shipping cost vs revenue ratio by region |
| Q10 | Payment processing fee impact on net revenue |

**Key SQL:** `CASE WHEN`, `DENSE_RANK()`, `INNER JOIN`, `NULLIF()`, `ROUND()`, `CTEs`

---

## Part 3 — Marketing Financial ROI Analytics (10 Queries)

**Business Focus:** Is marketing spend generating sufficient return?

| Query | Analysis |
|-------|----------|
| Q1 | CAC by channel — cost to acquire one customer |
| Q2 | CAC by region — regional acquisition efficiency |
| Q3 | Month-over-month CAC trend using LAG() |
| Q4 | Marketing ROI by channel — revenue per marketing rupee |
| Q5 | Best ROI channel ranking using DENSE_RANK() |
| Q6 | Monthly marketing efficiency trend using LAG() |
| Q7 | Revenue generated per marketing dollar by channel |
| Q8 | Conversion value analysis — revenue per conversion |
| Q9 | Net revenue after marketing spend — true customer profitability |
| Q10 | Break-even analysis — orders needed to recover marketing spend |

**Key SQL:** `INNER JOIN`, `LAG()`, `DENSE_RANK()`, `CTEs`, `NULLIF()`, `Mathematical formulas`

---

## Part 4 — Customer & Retention Analytics (10 Queries)

**Business Focus:** Who are the customers and how loyal are they?

| Query | Analysis |
|-------|----------|
| Q1 | Customer retention overview — repeat vs one-time customers |
| Q2 | Customer retention by region |
| Q3 | Monthly retention trend using LAG() |
| Q4 | Top loyal customers by order frequency |
| Q5 | Customer lifetime value (CLV) analysis |
| Q6 | Customer segmentation — MAX Profit, High Profit, Regular |
| Q7 | Customer purchase frequency segmentation |
| Q8 | Customer recency analysis using DATEDIFF() |
| Q9 | Churn risk analysis — Lost, Critical, Medium, Low Risk |
| Q10 | Customer revenue concentration analysis |

**Key SQL:** `CASE WHEN`, `DATEDIFF()`, `DENSE_RANK()`, `SUM() OVER()`, `LAG()`, `CTEs`

---

## Part 5 — Financial Intelligence Dashboard (8 Queries)

**Business Focus:** Executive-level view of complete business financial health.

| Query | Analysis |
|-------|----------|
| Q1 | Refund rate by category — revenue leakage identification |
| Q2 | Monthly refund trend using LAG() |
| Q3 | Net revenue waterfall — gross to true net after all costs |
| Q4 | Net revenue by category — true profitability after all deductions |
| Q5 | Executive financial KPI dashboard — single query full snapshot |
| Q6 | Regional financial performance — revenue, profit, CAC by region |
| Q7 | Quarterly financial performance — Q1 vs Q2 vs Q3 vs Q4 |
| Q8 | Executive intelligence report — best channel, category, region combined |

**Key SQL:** `CROSS JOIN`, `Multiple CTEs`, `Arithmetic formulas`, `Window Functions`, `CASE WHEN`

---

## SQL Concepts Demonstrated

| Category | Concepts Used |
|----------|--------------|
| Joins | INNER JOIN, LEFT JOIN, CROSS JOIN |
| Aggregations | SUM, COUNT, AVG, MAX, MIN, ROUND |
| Window Functions | DENSE_RANK(), LAG(), SUM() OVER(), PARTITION BY |
| CTEs | Single CTE, Chained CTEs (up to 4 levels) |
| Conditional Logic | CASE WHEN, NULLIF, IFNULL |
| Date Functions | DATE_FORMAT, DATEDIFF, YEAR, MONTH |
| Financial KPIs | CAC, ROI, Gross Margin, Net Revenue, Refund Rate, Profit Margin |
| Dashboard Design | CROSS JOIN multi-CTE executive reports |

---

## Key Business Findings

1. **Gross revenue is ₹10.29 Crore** but true net revenue after all costs is ₹7.91 Crore — a gap of ₹2.38 Crore driven by discounts, refunds, shipping, and payment fees
2. **Discount rate of 15.68%** is the single largest revenue leakage — ₹1.61 Crore in discounts given
3. **Fashion generates the highest profit margin at 29.01%** despite not always being the highest revenue category
4. **Home category has the highest refund rate** indicating product quality or expectation mismatch issues
5. **Organic channel delivers the highest marketing ROI** with lowest CAC, making it the most sustainable acquisition channel
6. **Marketing ROI of 8.36x** overall — every rupee spent on marketing generates ₹8.36 in revenue
7. **CAC of ₹60.45** varies significantly by channel — optimization opportunity exists
8. **Payment processing fees of ₹25.74 Lakh** represent a controllable cost with optimization potential

---

## Business Recommendations

1. **Reduce discount rate** from 15.68% by introducing targeted discounts instead of blanket promotions — potential revenue recovery of ₹50+ Lakh
2. **Investigate Home category refunds** — highest refund rate suggests product quality or listing accuracy issues needing correction
3. **Increase Organic channel investment** — highest ROI and lowest CAC makes it the most financially sustainable acquisition channel
4. **Optimize payment processing costs** — evaluate gateway options to reduce ₹25.74 Lakh annual fee burden
5. **Focus profitability strategy on Fashion and Beauty** — highest margin categories deserve priority in marketing and inventory investment
6. **Regional CAC analysis** suggests some regions acquire customers at significantly lower cost — reallocate budget toward efficient regions

---

## Net Revenue Waterfall Summary

```
Gross Revenue          ₹10.29 Crore   100%
Less: Discounts       - ₹1.61 Crore  -15.68%
Less: Refunds         - ₹0.76 Crore  - 7.42%
Less: Shipping        - ₹0.53 Crore  - 5.15%
Less: Payment Fees    - ₹0.26 Crore  - 2.50%
                      ─────────────────────
True Net Revenue       ₹7.13 Crore    69.25%
```

---

## Tools Used

- **MySQL** — Financial data analysis and querying
- **MySQL Workbench** — Query execution and documentation
- **MS Excel** — Dashboard visualization
- **GitHub** — Version control and portfolio

---

## How To Run This Project

1. Clone this repository
2. Import the three CSV files into your MySQL database
3. Run SQL files in order: Part 1 → Part 2 → Part 3 → Part 4 → Part 5
4. View results in MySQL Workbench output panel

```sql
CREATE DATABASE financial_analytics;
USE financial_analytics;
-- Import customers.csv, orders.csv, marketing_spend.csv
-- Then run SQL files in sequence from Part 1 to Part 5
```

---

## Project Highlights For Fintech Roles

This project directly demonstrates skills relevant to fintech and financial operations roles:

- **CAC calculation and optimization** — core metric in any growth-focused fintech
- **Payment processing fee analysis** — directly relevant to payment infrastructure companies
- **Net revenue waterfall** — standard financial reporting in fintech companies
- **Marketing ROI and efficiency** — critical for budget allocation decisions
- **Refund and leakage analysis** — revenue protection is a priority in financial operations
- **Executive financial dashboards** — C-suite reporting style using SQL

---

## Related Project

This project is the second in a two-project analytics portfolio:

- **Project 1:** [Customer Acquisition & Funnel Analytics](link-to-project-1) — Customer behavior, retention, cohort analysis, RFM segmentation
- **Project 2:** Revenue & Financial Performance Analytics ← *This project*

Together, these two projects cover the complete analyst skillset for e-commerce and fintech roles.

---

## About This Project

Built as part of a structured self-directed data analytics learning program covering MySQL, business analytics, and real-world financial data analysis.

The dataset contains 50,000+ real-scale records designed to simulate actual financial analytics challenges faced by data analysts in e-commerce and fintech organizations.

---

## Connect

**LinkedIn:** (https://www.linkedin.com/in/amresh-patra-952714262/)]
**Email:** [amresh_patra@proton.me]

---

*Built with MySQL | 50,000+ Transactions | 5-Part Financial Analytics Project | Fintech Ready*
