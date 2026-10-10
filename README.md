# Amazon Sales Analysis | Python & MySQL

## Project Overview

This project focuses on cleaning, exploring, and analyzing Amazon India order data using Python and MySQL. The objective is to prepare the dataset for analysis, identify sales and order patterns, and communicate business insights through SQL queries and visualizations.

## Project Workflow

1. **Data Cleaning with Python** — Inspected the dataset, standardized column names, handled missing values, cleaned city and state names, consolidated order statuses, and prepared the data for further analysis.
2. **Exploratory Data Analysis (EDA)** — Explored order values, fulfilment patterns, B2B vs B2C behavior, product categories, colours, and geographical sales using Python visualizations.
3. **SQL Analysis with MySQL** — Analyzed sales trends, product performance, geographic sales, and order cancellation and return patterns.
4. **Reporting** — Organized the analysis and findings in a project report.

## Tools & Technologies

- **Python:** Pandas, NumPy
- **Data Visualization:** Matplotlib, Seaborn
- **Database:** MySQL
- **SQL Concepts:** Aggregations, CTEs, Window Functions, JOINs/Grouping where applicable
- **Reporting:** PowerPoint / PDF

## Project Files

| File | Description |
|---|---|
| `amazon_data_cleaning.ipynb` | Python notebook for data inspection and cleaning |
| `amazon_sales_eda.ipynb` | Python notebook for exploratory analysis and visualizations |
| `amazon_sales_analysis_original_ppt_queries.sql` | SQL queries used for the analysis |
| `Amazon_Sales_Analysis_Report.pdf` | Project report and analysis screenshots |
| `README.md` | Project documentation |

## Data Cleaning with Python

The cleaning notebook includes work such as:

- Inspecting dataset dimensions, column types, summary statistics, and missing values.
- Standardizing column names and renaming selected fields.
- Converting the order date to a datetime format and deriving the day of the week.
- Cleaning city and state text values and standardizing selected city names.
- Consolidating order status labels for analysis.
- Handling missing amounts and courier status values.
- Mapping B2B Boolean values to Yes/No.
- Filling some missing colour values using style-based mappings.
- Removing selected columns considered redundant or unsuitable for the intended analysis.
- Exporting the prepared dataset to CSV.

## Exploratory Data Analysis

The Python analysis notebook explores:

- Amazon vs Merchant fulfilment and sales amount.
- Distribution of order amounts.
- B2B vs B2C order value, average items, and order counts.
- Product category and colour combinations.
- Cities with high counts of cancellations and returns.
- Top states and cities by sales amount.

## SQL Analysis

The MySQL analysis covers:

- Monthly sales trends and month-over-month growth.
- B2B vs B2C order behavior.
- Top-performing category and size combinations.
- Top 10 SKUs by sales amount.
- Top cities within states by sales.
- City-level cancellation and return rates.
- Amazon vs Merchant fulfilment performance.
- Category-level cancellation rates.
- Top-selling category within each colour.

## Skills Demonstrated

- Data cleaning and preprocessing
- Exploratory Data Analysis (EDA)
- Missing-value handling
- Data aggregation and grouping
- SQL query writing
- CTEs and window functions
- Data visualization
- Business insight communication

## Data Notes & Limitations

- Results depend on the data available in the source dataset and the transformations applied.
- March covers only one day in the analyzed period, so monthly comparisons should be interpreted carefully.
- Some sales queries may include cancelled orders; check the filter used by each query before comparing results.
- Return records may not be consistently recorded across fulfilment methods.
- Missing-value handling and status consolidation may affect the results.

## How to Use This Repository

1. Download the notebooks and SQL file.
2. Open the `.ipynb` files in Google Colab or Jupyter Notebook.
3. Update the dataset file path to match your local or Colab location.
4. Run the data cleaning notebook before running the EDA notebook.
5. Load the prepared dataset into MySQL if you want to reproduce the SQL analysis.

## Author

Aspiring Data Analyst | Python | SQL | MySQL | Excel | Power BI
