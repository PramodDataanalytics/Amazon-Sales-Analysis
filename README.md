# Amazon Sales Analysis | Python & MySQL



![Python](https://img.shields.io/badge/Python-3.10%2B-blue)




![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-orange)




![Pandas](https://img.shields.io/badge/Pandas-data%20cleaning-green)



## Project Overview
This project focuses on cleaning, exploring, and analyzing Amazon India order data using **Python** and **MySQL**. The objective is to prepare the dataset for analysis, identify sales and order patterns, and communicate business insights through SQL queries and visualizations.

**Business questions answered**
- How do sales change month to month and week to week?
- Which categories, sizes, colours and SKUs sell the most?
- Which states and cities generate the most revenue?
- Does Amazon fulfilment perform differently from Merchant fulfilment?
- Do B2B customers order differently from B2C customers?
- Where do cancellations and returns happen most?

## Project Workflow
1. **Data Cleaning with Python** (`notebooks/01_data_cleaning.ipynb`): inspected the dataset, standardized column names, handled missing values, cleaned city and state names, consolidated order statuses, and prepared the data for further analysis.
2. **Exploratory Data Analysis** (`notebooks/02_eda.ipynb`): explored order values, fulfilment patterns, B2B vs B2C behaviour, product categories, colours, and geographical sales using Python visualizations.
3. **SQL Analysis with MySQL** (`sql/amazon_sales_analysis.sql`): analyzed sales trends, product performance, geographic sales, and order cancellation and return patterns.
4. **Reporting**: organized the analysis and findings in a project report (`reports/`).

## Tools & Technologies
| Area | Tools |
|---|---|
| Python | Pandas, NumPy |
| Data visualization | Matplotlib, Seaborn |
| Database | MySQL 8 |
| SQL concepts | Aggregations, CTEs, Window Functions (`ROW_NUMBER`, `LAG`, running `SUM`), Views, Grouping and `HAVING` |
| Reporting | PowerPoint / PDF |

## Repository Structure
```
amazon-sales-analysis/
├── README.md
├── requirements.txt
├── .gitignore
├── data/
│   ├── raw/                  # put the original CSV here (not tracked by git)
│   └── processed/            # cleaned CSVs are written here (not tracked by git)
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   └── 02_eda.ipynb
├── sql/
│   └── amazon_sales_analysis.sql
├── images/                   # charts saved by the EDA notebook
└── reports/                  # final PowerPoint / PDF report
```

## Dataset
Amazon India order data (Amazon Sale Report), joined with the stock sheet on `SKU`.

| Column | Description |
|---|---|
| `order_id`, `date` | Order identifier and order date |
| `status` / `status_group` | Original order status / simplified group (see below) |
| `fulfilment` | `Amazon` or `Merchant` |
| `ship_service_level` | Standard or Expedited |
| `sku`, `category`, `size`, `color` | Product details |
| `qty`, `amount` | Units and order-line value in INR |
| `city`, `state` | Shipping location |
| `b2b` / `segment` | B2B flag / `B2B` or `B2C` label |
| `stock` | Stock level from the joined stock sheet |

> The raw CSV is not included in this repository. Save your copy as `data/raw/amazon_sales_raw.csv` (or change `RAW_FILE` in notebook 01).

## Key Definitions
- **Net sales / revenue**: order lines whose `status_group` is **not** `Cancelled` or `Returned`.
- **Cancellation rate** = cancelled order lines ÷ all order lines × 100. **Return rate** is calculated the same way.
- **Average order value** = total net revenue of an order (all its lines added up), averaged across orders.
- Groups with fewer than 100 orders are hidden from rate rankings so tiny groups do not distort results.

### Order status groups
| `status_group` | Raw statuses it covers |
|---|---|
| Delivered | Shipped - Delivered to Buyer |
| Cancelled | Cancelled |
| Returned | Returned to Seller, Returning to Seller, Rejected by Buyer |
| Shipped | Shipped, Out for Delivery, Picked Up (delivery not confirmed) |
| Pending | Pending, Pending - Waiting for Pick Up |
| Lost/Damaged | Lost in Transit, Damaged |

## Data Cleaning Summary
- Column names converted to `snake_case`; `ship-city` → `city`, `ship-state` → `state`.
- `date` converted from `MM-DD-YY` text to a real date.
- `b2b` converted to True/False and a `segment` column (B2B/B2C) added.
- Missing `amount` / `qty` filled with `0` (mostly cancelled orders) and flagged in `amount_missing`; other blanks filled with `Unknown` or `No Promotion`.
- City and state spellings standardized (for example `Bangalore` → `Bengaluru`, `Orissa` → `Odisha`, `RJ` → `Rajasthan`).
- Order statuses consolidated into the groups above.
- **No rows were removed.** Exact duplicates are flagged in `is_duplicate_row` instead of deleted.

## How to Run
**1. Set up Python**
```bash
git clone https://github.com/<your-username>/amazon-sales-analysis.git
cd amazon-sales-analysis
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

**2. Add the data**: place the CSV at `data/raw/amazon_sales_raw.csv`.

**3. Run the notebooks in order**
```bash
jupyter lab
```
- `01_data_cleaning.ipynb` writes `data/processed/amazon_sales_clean.csv` and `amazon_sales_mysql.csv`.
- `02_eda.ipynb` reads the clean file, draws the charts, and saves them to `images/`.

**4. Run the SQL analysis**
1. Open `sql/amazon_sales_analysis.sql` in MySQL Workbench (MySQL 8.0+ is needed for window functions).
2. In section 0, change the file path in `LOAD DATA LOCAL INFILE` to where `amazon_sales_mysql.csv` is on your computer.
3. Run section 0 once, then run any query from sections 1 to 6.

## SQL Script Contents
| Section | Queries |
|---|---|
| 0. Setup | Create database, table and `net_sales` view; load data; sanity checks |
| 1. Trends | Monthly revenue, month-over-month growth (`LAG`), running total, weekly growth, day-of-week sales |
| 2. Products | Top SKUs, category share, best size per category, top 3 SKUs per category, top colours |
| 3. Geography | Top states and cities, top 3 cities per state, average order value by state |
| 4. Fulfilment | Amazon vs Merchant outcome rates, order value, category-level comparison, shipping speed |
| 5. Cancellations & returns | Rates by state, city, category, size, category-size-fulfilment combinations, monthly trend |
| 6. B2B vs B2C | Order value, basket size, cancellation and return rate |

## Key Insights
📊 Key Business Insights

1. Monthly Sales Trend

- Result: Sales peaked in April 2022, followed by a 9.1% decline in May and a further 10.7% decline in June.
- Reason: The declining trend indicates a need to investigate changes in product demand, order volume, and category-level performance.
- Recommendation: Analyze monthly sales by SKU, category, and city to identify the drivers of the decline.

2. B2B vs. B2C Order Analysis

- Result: B2B orders recorded an average order value of ₹768, compared with ₹695 for B2C—approximately 10.5% higher. Average basket size was 1.12 items for B2B versus 1.08 for B2C.
- Reason: B2B orders may involve larger purchasing requirements or different buying patterns.
- Recommendation: Investigate opportunities to grow B2B sales while considering that B2B represented only 728 orders (approximately 0.7%).

3. Best-Performing Category and Size

- Result: The Set / M combination generated approximately ₹7.30 million in sales amount.
- Reason: This category-size combination contributed the highest sales amount among the combinations highlighted in the report.
- Recommendation: Evaluate its order volume, stock availability, and profitability before making inventory decisions.

4. Top-Performing SKU

- Result: SKU J0230-SKD-M generated approximately ₹527.7K in sales amount, ranking first in the displayed SKU analysis.
- Reason: Its cumulative sales amount exceeded that of the other SKUs in the reported ranking.
- Recommendation: Monitor its sales trend and availability, and compare its profitability with other high-performing products.

5. Geographic Sales Performance

- Result: Bengaluru recorded approximately ₹7.28 million, followed by Hyderabad at ₹5.59 million in the displayed city results.
- Reason: These cities demonstrated strong sales amounts relative to the other cities shown.
- Recommendation: Investigate product mix, order volume, and customer demand in these cities to identify opportunities for growth.

6. City-Wise Cancellation and Return Analysis

- Result: Hyderabad showed a 14.34% cancellation rate among the displayed city results. New Delhi had the highest displayed return rate at 1.57%.
- Reason: These rates may indicate differences in customer behaviour or operational processes, but they do not establish the underlying causes.
- Recommendation: Investigate cancellation and return reasons, order status, and product categories in the affected cities.

7. Fulfilment Performance

- Result: Merchant-fulfilled orders had a 17.47% cancellation rate, compared with 12.79% for Amazon-fulfilled orders—a difference of 4.68 percentage points.
- Reason: The observed gap suggests that Merchant fulfilment warrants further operational investigation.
- Recommendation: Compare dispatch delays, stock availability, and cancellation reasons across fulfilment methods. Return rates are not directly comparable because return status was not recorded for Amazon-fulfilled orders in this dataset.

8. Category and Size Cancellation Patterns

- Result: In the selected category-size results, Bottom / XXL had an 18.92% cancellation rate, followed by Blouse / XS at 17.86%.
- Reason: These combinations showed relatively high cancellation rates in the displayed sample.
- Recommendation: Examine sample sizes and cancellation reasons before deciding whether product descriptions, sizing information, or inventory processes need improvement.

9. Colour-Wise Product Performance

- Result: The leading category for each displayed colour included Pink – Set (₹3.99M), Blue – Set (₹3.62M), and Green – Western Dress (₹3.30M).
- Reason: These colour-category combinations generated the highest sales amounts for their respective colours in the reported results.
- Recommendation: Use colour-category performance to guide further demand analysis and merchandising decisions.

10. Data Quality and Revenue Interpretation

- Result: The dataset contained 128,938 order rows and 120,346 distinct orders. Approximately 8.8% of order rows were associated with cancelled-order amounts in the report's data checks.
- Reason: Transaction rows and distinct orders represent different counts. Including cancelled-order amounts can overstate revenue when the intended metric is completed or net sales.
- Recommendation: Validate duplicate handling and calculate gross sales, delivered sales, and net sales using clearly defined status filters before publishing final business KPIs.

🛠️ SQL Skills Demonstrated

- Aggregate Functions: "SUM()", "AVG()", "COUNT()"
- Common Table Expressions (CTEs)
- Window Functions: "LAG()", "RANK()", "ROW_NUMBER()"
- Business KPI and percentage calculations
- Monthly trend and growth analysis
- Product, geographic, and fulfilment an## Visualization
- 
## Visualizations

### Sales Overview
![Weekly and weekday sales](images/09_weekly_and_weekday_sales.png)
![Orders and sales per category](images/02_category_orders_sales.png)
![Orders per size](images/01_orders_per_size.png)

### Order Status and Fulfilment
![Order status share](images/03_order_status_share.png)
![Fulfilment comparison](images/07_fulfilment_comparison.png)
![Order distributions](images/04_order_distributions.png)

### Customers and Geography
![B2B vs B2C](images/08_b2b_vs_b2c.png)
![Top states](images/10_top_states.png)
![Top cities](images/11_top_cities.png)

### Cancellations and Returns
![Cancellation and return by state](images/13_cancel_return_by_state.png)
![Cancellation and return by city](images/14_cancel_return_by_city.png)
![Cancellation heatmap](images/15_cancel_heatmap_category_size.png)

### Products and Other Checks
![Top categories by quantity](images/05_top_categories_qty.png)
![Top category-colour combinations](images/12_top_category_colour.png)
![Amount distribution](images/16_amount_distribution.png)
![Correlation heatmap](images/06_correlation_heatmap.png)

- Cancellation reasons are not in the data, so the analysis shows **where** cancellations concentrate, not **why**.
- B2B orders are usually a very small share of the data, so B2B vs B2C comparisons should be read with care.
- `Shipped` orders without a delivery confirmation are not counted as delivered.
- The first and last weeks in the data are often partial, which can distort week-over-week growth.

## Author
**Pramod Vishwakrama
