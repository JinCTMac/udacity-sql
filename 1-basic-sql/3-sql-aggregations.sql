/* Aggregations in SQL are very similar to Excel, and work on column basis not row basis */

/* NULL is important for this as if there are NULL data values within a column, this could mess up aggregation attempts */

/* 1) NULL */

/* to find out if you have NULL values in a column, you need to use IS NULL instead of = NULL, as NULL is a data property, not a value */

SELECT *
FROM orders
WHERE primary_poc IS NULL;

/* to do the opposite and find out which rows don't have NULL data, use IS NOT NULL */

SELECT *
from orders
WHERE primary_poc IS NOT NULL;

/* 2) COUNT function */

/* used to count all rows where there is non-null data - it is very rare to find a row where all the data is NULL, so this will typically return all of the rows within a table */

SELECT COUNT(*)
FROM orders;

/* we can alias the count to make it easier to understand */

SELECT COUNT(*) AS order_rows_count
FROM orders;

/* you can also count a specific column, and check if the number of rows there is the same as for the whole table, if not there is NULL data in that column */

SELECT COUNT(accounts.id)
FROM accounts;

/* 3) SUM function */

/* we can use the SUM function to count numerical data, and unlike COUNT, the presence of NULL values isn't as much of an issue as it will treat any NULL it finds in a column as 0 - it could be useful to compare several rows to each other and see how they stack up */

SELECT SUM(poster_qty) AS total_poster_qty
FROM orders;

SELECT SUM(standard_qty) AS total_standard_qty
FROM orders;

/* to check total amount spent */

SELECT SUM(total_amt_usd) AS total_order_amt_usd
FROM orders;

SELECT SUM(standard_amt_usd) total_standard_amt, SUM(gloss_amt_usd) total_gloss_amt
FROM orders;

/* find average price/cost per unit of paper sold */

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

/* 4) MIN and MAX functions */

SELECT MIN(poster_qty), MAX(poster_qty)
FROM orders;

/* 5) AVG function */

SELECT AVG(poster_qty)
FROM orders;

/* note, AVG ignores NULLS completely, so if we want to treat the NULLs as being equal to 0, we need to take the sum of what we want and then divide by the COUNT of the rows to get an average that way */

SELECT (SUM(poster_qty)/COUNT(*)) as other_avg
FROM orders;

/* to find the earliest date of an order you can use MIN function on a date column */

SELECT MIN(occurred_at)
FROM orders;

/* otherwise, you'd need to do an ORDER BY statement to sort for earliest date */

SELECT occurred_at
FROM orders
ORDER BY occurred_at;

/* finding the most recent date using MAX function */

SELECT MAX(occurred_at)
FROM web_events;

/* same logic for finding it without an aggregation function, you need to run order by */

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC;

/* finding averages for spending and qty ordered */

SELECT AVG(standard_qty) avg_standard_qty, AVG(gloss_qty) avg_gloss_qty, AVG(poster_qty) avg_poster_qty, AVG(standard_amt_usd) avg_standard_usd, AVG(gloss_amt_usd) avg_gloss_usd, AVG(poster_amt_usd) avg_poster_usd
FROM orders;

/* to find medium spending, you can use a subquery */

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;
