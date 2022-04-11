/* AGGREGATES - Dividing an integer result of a count over another count - aka finding the proportion of the total data */

SELECT
CAST((SELECT COUNT(*) FROM accounts WHERE name LIKE 'A%') AS FLOAT)/COUNT(*)
FROM accounts;

/* AGGREGATES - Dividing integer result of count over another count to find proportion, then grouping results by week, see this post https://stackoverflow.com/questions/9222664/getting-a-count-of-two-different-sets-of-rows-in-a-table-and-then-dividing-them */

SELECT DATE_TRUNC('week', occurred_at) week,
CAST((SELECT COUNT(*) FROM orders WHERE total > 50) AS FLOAT)/COUNT(*) orders_over_50
FROM orders
GROUP BY week
ORDER BY week;

/* DATES - converting datetime to date using to_date function */

SELECT to_date(event_timestamp) AS contact_date
FROM table;

/* DATA TYPES - show datatypes of table, creates new table showing the data types of each column in the table */

SHOW CREATE TABLE lookup.calendar;

/* advanced SQL query joining subqueries to reduce row counts and improve runtime speed */

SELECT COALESCE(orders.date, web_events.date) AS date,
orders.active_sales_reps,
orders.orders,
web_events.web_visits
FROM (SELECT DATE_TRUNC('day', o.occurred_at) AS date,
  COUNT(a.sales_rep_id) AS active_sales_reps,
  COUNT(o.id) AS orders
  FROM accounts a
  JOIN orders o
  ON o.account_id = a.id
  GROUP BY date) orders

FULL JOIN

(SELECT DATE_TRUNC('day', o.occurred_at) AS date,
COUNT(w.id) AS web_visits
FROM web_events w
GROUP BY date) web_events

ON orders.date = web_events.date
ORDER BY date DESC;
