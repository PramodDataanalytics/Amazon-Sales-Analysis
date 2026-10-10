
/* ============================================================
   QUESTION 1: What is the monthly sales amount trend and
               month-over-month growth?
   ============================================================ */

SELECT
    year,
    month_num,
    month_name,
    total_sum,
    LAG(total_sum) OVER (ORDER BY year, month_num) AS previous_month_sum,
    ROUND(
        (total_sum - LAG(total_sum) OVER (ORDER BY year, month_num))
        / NULLIF(LAG(total_sum) OVER (ORDER BY year, month_num), 0) * 100,
        2
    ) AS mom_growth_pct
FROM (
    SELECT
        YEAR(`Date`) AS year,
        MONTH(`Date`) AS month_num,
        MONTHNAME(`Date`) AS month_name,
        ROUND(SUM(Amount), 1) AS total_sum
    FROM amazon
    GROUP BY YEAR(`Date`), MONTH(`Date`), MONTHNAME(`Date`)
) AS monthly_sales
ORDER BY year, month_num;


/* ============================================================
   QUESTION 2: How do B2B and B2C orders compare in average
               order value and average basket size?
   ============================================================ */

WITH orders AS (
    SELECT
        order_id,
        b2b,
        SUM(amount) AS order_value,
        SUM(qty) AS items
    FROM amazon
    WHERE status NOT LIKE 'Cancelled%'
    GROUP BY order_id, b2b
)
SELECT
    b2b,
    COUNT(*) AS orders,
    ROUND(AVG(order_value)) AS avg_value,
    ROUND(AVG(items), 2) AS avg_items
FROM orders
GROUP BY b2b
ORDER BY b2b;


/* ============================================================
   QUESTION 3: What is the best-performing size within each
               product category by sales amount?
   ============================================================ */

SELECT
    category,
    size,
    total_amount,
    rnk
FROM (
    SELECT
        category,
        size,
        total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY total_amount DESC
        ) AS rnk
    FROM (
        SELECT
            category,
            size,
            SUM(amount) AS total_amount
        FROM amazon
        GROUP BY category, size
    ) AS category_size_sales
) AS ranked_category_size
WHERE rnk = 1
ORDER BY total_amount DESC;


/* ============================================================
   QUESTION 4: What are the top 10 SKUs by total sales amount?
   ============================================================ */

SELECT
    sku,
    SUM(amount) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM amazon
GROUP BY sku
ORDER BY total_amount DESC
LIMIT 10;


/* ============================================================
   QUESTION 5: Which city has the highest sales amount within
               each state, and what are the top city results?
   ============================================================ */

WITH temp AS (
    SELECT
        state,
        city,
        SUM(amount) AS total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY state
            ORDER BY SUM(amount) DESC
        ) AS rnk
    FROM amazon
    GROUP BY state, city
)
SELECT
    state,
    city,
    total_amount,
    rnk
FROM temp
WHERE rnk = 1
ORDER BY total_amount DESC
LIMIT 6;


/* ============================================================
   QUESTION 6: What are the city-wise cancellation and return
               rates?
   ============================================================ */

WITH rate AS (
    SELECT
        city,
        COUNT(*) AS total_orders,
        SUM(status LIKE 'Cancelled%') AS cancelled,
        SUM(status LIKE '%Return%') AS returned,
        SUM(status LIKE '%Delivered%') AS delivered
    FROM amazon
    GROUP BY city
)
SELECT
    city,
    total_orders,
    CONCAT(
        ROUND(cancelled / NULLIF(total_orders, 0) * 100, 2), '%'
    ) AS cancelled_rate,
    CONCAT(
        ROUND(returned / NULLIF(total_orders, 0) * 100, 2), '%'
    ) AS return_rate
FROM rate
ORDER BY total_orders DESC
LIMIT 6;


/* ============================================================
   QUESTION 7: How does fulfilment performance compare between
               Amazon and Merchant for cancellations, returns,
               and delivered orders?
   ============================================================ */

SELECT
    fulfilment,
    COUNT(*) AS total_orders,
    SUM(status LIKE 'Cancelled%') AS cancelled,
    SUM(status LIKE '%Return%') AS returned,
    SUM(status LIKE '%Delivered%') AS delivered,
    ROUND(
        SUM(status LIKE 'Cancelled%') / COUNT(*) * 100, 2
    ) AS cancel_pct,
    ROUND(
        SUM(status LIKE '%Return%') / COUNT(*) * 100, 2
    ) AS return_pct,
    ROUND(
        SUM(status LIKE '%Delivered%') / COUNT(*) * 100, 2
    ) AS delivered_pct
FROM amazon
GROUP BY fulfilment;


/* ============================================================
   QUESTION 8: Which product categories have the highest
               cancellation rates, considering categories with
               at least 100 rows?
   ============================================================ */

SELECT
    category,
    COUNT(*) AS total_orders,
    SUM(status LIKE 'Cancelled%') AS cancelled,
    ROUND(
        SUM(status LIKE 'Cancelled%') / COUNT(*) * 100, 2
    ) AS cancel_pct
FROM amazon
GROUP BY category
HAVING COUNT(*) >= 100
ORDER BY cancel_pct DESC;


/* ============================================================
   QUESTION 9: What is the top-selling category within each
               colour, based on sales amount?
   ============================================================ */
use amazon_sales_db;
WITH color_rank AS (
    SELECT
        color,
        category,
        SUM(amount) AS total_amount,
        RANK() OVER (
            PARTITION BY color
            ORDER BY SUM(amount) DESC
        ) AS top_selling
    FROM amazon
    WHERE status <> 'Cancelled'
    GROUP BY color, category
)
SELECT
    color,
    category,
    total_amount
FROM color_rank
WHERE top_selling = 1
ORDER BY total_amount DESC
LIMIT 10;
