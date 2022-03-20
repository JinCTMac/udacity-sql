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

/* 6) GROUP BY statement */

/* GROUP BY is used to split aggregates like a SUM function calculation and group them into segments, such as by account_id or something else, which allows us to effectively see the aggregate data associated with the segments of the data we want */

/* in the example, they aggregate paper quantity sold across the whole dataset, which returns one row, but if we want to see the sum of paper quantities sold by each account, we need to use the GROUP BY function to segment this aggregate into each of the accounts and the quanities sold associated with them */

SELECT account_id, SUM(standard_qty) total_standard_qty, SUM(gloss_qty) total_gloss_qty, SUM(poster_qty) total_poster_qty
FROM orders
GROUP BY account_id
ORDER BY account_id;

/* example qs to test which aggregation function or statements are most useful for each situation */

/* q1) find which account placed earliest order */

SELECT a.name account_name, o.occurred_at order_date
FROM orders o
JOIN accounts a
ON o.account_id = a.id
ORDER BY o.occurred_at
LIMIT 1;

/* q2) finding total sales for each account */

SELECT a.name company_name, SUM(o.total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name;

/* q3) finding latest web event and channel associated with it */

SELECT a.name account, w.occurred_at date, w.channel channel
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC;

/* q4) finding out how many times each channel type was used */

SELECT w.channel channel, COUNT(w.channel) usage_amt
FROM web_events w
GROUP BY w.channel;

/* q5) finding primary poc of earliest web event */

SELECT a.primary_poc poc, w.occurred_at date
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC;

/* q6) finding smallest amount spent for each account */

SELECT a.name account, MIN(o.total_amt_usd) smallest_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name;

/* q7) finding number of sales reps per region */

SELECT r.name region, COUNT(s.region_id) sales_reps_amt
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name;

/* below is better since two tables are joined and can just count all the rows instead and sort by region */

SELECT r.name region, COUNT(*) sales_reps_amt
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name;

/* GROUP BY II - you can make your grouping/segmenting more granular by using two or more columns in the GROUP BY */

/* q1) find out average qty of each paper type each account ordered */

SELECT a.name account, AVG(o.standard_qty) avg_standard, AVG(o.gloss_qty) avg_gloss, AVG(o.poster_qty) avg_poster
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name;

/* q2) average amount spent on each paper type for each account */

SELECT a.name account, AVG(o.standard_amt_usd) avg_standard_amt, AVG(o.gloss_amt_usd) avg_gloss_amt, AVG(o.poster_amt_usd) avg_poster_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name;

/* q3) count the number of times each channel was used for each sales rep, using GROUP BY with two parameters */

SELECT s.name sales_rep, w.channel channel, COUNT(*) channel_amt
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name, w.channel
ORDER BY s.name, w.channel;

/* q4) count number of times each channel was used for each region */

SELECT r.name region, w.channel channel, COUNT(w.channel) channel_amt
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
GROUP BY r.name, w.channel
ORDER BY r.name, w.channel;

/* 7) DISTINCT statement */

/* DISTINCT is used to return only distinct (different) values */

/* check if accounts are associated with more than one region */

SELECT DISTINCT a.name account, r.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id;

/* check if any sales reps have worked on more than one account */

SELECT DISTINCT s.name sales_rep, a.name account
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
ORDER BY s.name;

/* tells us that there are only 50 sales reps, and may more accounts so each sales rep has worked on at least 2 accounts or more */

SELECT DISTINCT id, name
FROM sales_reps;

/* 8) HAVING clause */

/* HAVING is used to replace the WHERE clause when we are testing for a logical condition on aggregated data */

/* finding out which sales reps manage more than 5 accounts */

SELECT s.name sales_rep, COUNT(a.id) account_amt
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.name
HAVING COUNT(a.id) > 5
ORDER BY account_amt DESC;

/* finding out which accounts have more than 20 orders */

SELECT a.name account, COUNT(o.id) order_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
HAVING COUNT(o.id) > 20
ORDER BY order_amt DESC;

/* finding out which accounts have spent over $30,000 in orders */

SELECT a.name account, SUM(o.total_amt_usd) order_amt
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY order_amt DESC;

/* which accounts used facebook as the channel more than 6 times */

SELECT a.name account, w.channel, COUNT(w.channel) channel_amt
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE w.channel LIKE 'facebook'
GROUP BY a.name, w.channel
HAVING COUNT(w.channel) > 6
ORDER BY channel_amt DESC;

/* most frequent channels */

SELECT a.name account, w.channel, COUNT(w.channel) channel_amt
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
GROUP BY a.name, w.channel
HAVING COUNT(w.channel) > 6
ORDER BY channel_amt DESC;
