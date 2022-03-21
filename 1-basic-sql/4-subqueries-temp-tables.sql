/* 1) Subqueries */

/* subqueries, or inner queries, are fully-working SQL queries that are wrapped inside of brackets, allowing us to treat the results of the inner query as their own table and make queries on that table, thus essentially allowing us the query the results of a query */

/* finding number of events that occurred for each day for each channel type */

SELECT DATE_TRUNC('day', w.occurred_at) AS day, w.channel, COUNT(w.*) number_of_events
FROM web_events w
GROUP BY day, channel
ORDER BY number_of_events DESC;

/* writing a query that returns just all the results from that subquery */

SELECT *
FROM
  (SELECT DATE_TRUNC('day', w.occurred_at) AS day, w.channel, COUNT(w.*) number_of_events
  FROM web_events w
  GROUP BY day, channel
  ORDER BY number_of_events DESC)
sub;

/* now querying the outer query to get the average events per day for each channel - WE CAN QUERY THE INNER QUERY TABLE EASILY, note in this case we are using the FROM statement to represent the table we're gathering the information from, which is the table created by the subquery */

SELECT sub.channel channel, AVG(sub.number_of_events) avg_no_of_events
FROM
  (SELECT DATE_TRUNC('day', w.occurred_at) AS day, w.channel, COUNT(w.*) number_of_events
  FROM web_events w
  GROUP BY day, channel
  ORDER BY number_of_events DESC)
sub
GROUP BY sub.channel;

/* 2) Subqueries II */

/* you can use a subquery wherever you want to have a table name, or a column name, or even an individual value - but most conditionals only work if the subquery result i.e. the resulting table from the subquery contains ONLY ONE RESULT - the exception is if you use IN for the conditional logic */

SELECT *
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
  (SELECT DATE_TRUNC('month', MIN(occurred_at)) min_month
  FROM orders)
ORDER BY occurred_at;

/* subqueries can be used in WHERE, IN, HAVING or CASE statements, whereas before we were only using it in the FROM statement - DO NOT USE AN ALIAS FOR A SUBQUERY USED IN A CONDITIONAL, as it's treated as an individual
value */

/* q1) avg qty of paper types bought in first month */

SELECT AVG(standard_qty) standard, AVG(gloss_qty) gloss, AVG(poster_qty) poster, SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
FROM orders);

/* average paper qty amounts for each day in first month */

SELECT DATE_TRUNC('day', occurred_at) AS day, AVG(standard_qty) standard, AVG(gloss_qty) gloss, AVG(poster_qty) poster, SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
  (SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
  FROM orders)
GROUP BY day
ORDER BY day;

SELECT region, sales_rep, MAX(sales_total)
FROM sales_performance
  (SELECT s.name sales_rep, r.name region, SUM(o.total_amt_usd) sales_total
  FROM orders o
  JOIN accounts a
  ON o.account_id = a.id
  JOIN sales_reps s
  ON a.sales_rep_id = s.id
  JOIN region r
  ON s.region_id = r.id
  GROUP BY s.name, r.name
  ORDER BY SUM(o.total_amt_usd) DESC) sales_performance
GROUP BY sales_rep, region;

/* advanced questions on subqueries */

/* finding region with highest sales and its total orders */

SELECT region, MAX(total_sales) sales, total_orders
FROM
  (SELECT r.name region, SUM(o.total_amt_usd) total_sales, COUNT(o.*) total_orders
  FROM orders o
  JOIN accounts a
  ON o.account_id = a.id
  JOIN sales_reps s
  ON a.sales_rep_id = s.id
  JOIN region r
  ON s.region_id = r.id
  GROUP BY r.name) region_performance
GROUP BY region, total_orders
ORDER BY sales DESC
LIMIT 1;

/* finding out how many acconuts have had more total purchases than the account with the highest number of standard paper purchases */

SELECT a.name account, SUM(o.total) total_orders
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.total) >
  (SELECT MAX(o.standard_qty) standard_amt
  FROM orders o
  JOIN accounts a
  ON o.account_id = a.id
  GROUP BY a.name
  ORDER BY MAX(o.standard_qty) DESC
  LIMIT 1)
ORDER BY total_orders DESC;

/* 3) WITH clause */

/* you can use the WITH clause to write subqueries as their own table, which you can then query instead of having to run the subquery each time - this makes performance much easier */

/* below is the same question as before where we were finding the average events for each channel per day */

WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day,
                        channel, COUNT(*) as events
          FROM web_events
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;

/* you can also create more than 1 table, and subsequent tables don't need the WITH keyword */

WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)


SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;

/* rewriting a question from earlier about standard paper qty using with */

WITH standard_max AS (SELECT MAX(o.standard_qty) standard_amt
  FROM orders o
  JOIN accounts a
  ON o.account_id = a.id
  GROUP BY a.name
  ORDER BY MAX(o.standard_qty) DESC
  LIMIT 1)

SELECT a.name account, SUM(o.total) total_orders
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.total) > standard_max
ORDER BY total_orders DESC;

/* lifetime spending for top 10 spending accounts */

WITH t1 AS (
  SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  GROUP BY a.id, a.name
  ORDER BY 3 DESC
  LIMIT 10)

SELECT AVG(tot_spent)
FROM t1;
