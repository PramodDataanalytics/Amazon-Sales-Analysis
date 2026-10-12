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
_Add the findings from your own run here, for example: top state and city, best month, which fulfilment type cancels more, and which category or state has the highest cancellation rate._

## Visualizations
Charts are generated by `02_eda.ipynb` and saved in `images/`. After running the notebook, commit them so they appear here.

| | |
|---|---|
| 

![Monthly revenue](images/01_monthly_revenue_orders.png)

 | 

![Fulfilment outcomes](images/03_fulfilment_outcomes.png)

 |
| 

![B2B vs B2C](images/04_b2b_vs_b2c.png)

 | 

![Revenue by category](images/05_revenue_by_category.png)

 |
| 

![Top states](images/08_top_states.png)

 | 

![Cancellation heatmap](images/13_cancel_heatmap_category_size.png)

 |

## Limitations
- Cancellation reasons are not in the data, so the analysis shows **where** cancellations concentrate, not **why**.
- B2B orders are usually a very small share of the data, so B2B vs B2C comparisons should be read with care.
- `Shipped` orders without a delivery confirmation are not counted as delivered.
- The first and last weeks in the data are often partial, which can distort week-over-week growth.

## Author
**Pramod Vishwakrama
