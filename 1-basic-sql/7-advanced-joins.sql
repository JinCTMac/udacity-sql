/* LESSON 7 - Advanced Joins and Improving Query Runtime */

/* Inner Joins join data from tables where the condition is matched in both tables */

SELECT column_name(s)
FROM Table_A
INNER JOIN Table_B ON Table_A.column_name = Table_B.column_name;

/* LEFT and RIGHT joins work when the condition is matched and all rows from the left or right table respectively regardless of matching or not */

SELECT column_name(s)
FROM Table_A
LEFT JOIN Table_B ON Table_A.column_name = Table_B.column_name;

SELECT column_name(s)
FROM Table_A
RIGHT JOIN Table_B ON Table_A.column_name = Table_B.column_name;

/* FULL outer joins match data from both tables regardless of matching */

SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;

/* Sometimes, you only want to return unmatched rows from both columns to see what the data is like - to do so, use the below query */

SELECT *
FROM table_1
JOIN table_2
ON table_1.table_2_id = table_2.id
WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL;

/* Say you're an analyst at Parch & Posey and you want to see:

- each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)

- but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)

Here a full outer join is very useful (also see https://stackoverflow.com/questions/2094793/when-is-a-good-situation-to-use-a-full-outer-join)*/

SELECT a.*, s.*
FROM accounts a
FULL OUTER JOIN sales_reps s
ON a.sales_rep_id = s.id;

/* We can go one step further and use WHERE and IS NULL to check if either of the matching conditions has NULL data in them - in this case, there are none so each sales_rep has an account and each account has a sales_rep */

SELECT a.*, s.*
FROM accounts a
FULL OUTER JOIN sales_reps s
ON a.sales_rep_id = s.id
WHERE a.sales_rep_id IS NULL OR s.id IS NULL;

/* 2) JOINS with comparison operators */

/* We can use comparison operators like <, >, <= and >= in our joins as additional clauses to add more selection criteria for the join, such as only getting orders before a certain date, or in the case of the example, getting whether there are web events that took place prior to an accounts first order */

SELECT o.id,
       o.occurred_at,
       e.*
FROM orders o
LEFT JOIN web_events e
ON o.account_id = e.acconut_id
AND e.occurred_at < o.occurred_at
WHERE DATE_TRUNC('month', o.occurred_at) = (SELECT DATE_TRUNC('month', MIN(o.occurred_at) FROM orders)
ORDER BY o.account_id, o.occurred_at;

/* Inequality operators (a.k.a. comparison operators) don't only need to be date times or numbers, they also work on strings! You'll see how this works by completing the following quiz, which will also reinforce the concept of joining with comparison operators. */

/* ex) in the example below, we are joining accounts and sales reps, and using comparison operators in the join to isolate accounts where the name of the primary_poc comes before the name of the sales rep alphabetically, which is indicated by the < operator, also see https://stackoverflow.com/questions/26080187/sql-string-comparison-greater-than-and-less-than-operators/26080240#26080240 */

SELECT a.name account, a.primary_poc, s.name sales_rep
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
AND a.primary_poc < s.name;

/* the exemplar query using a left join instead of an inner join */

SELECT accounts.name as account_name,
       accounts.primary_poc as poc_name,
       sales_reps.name as sales_rep_name
FROM accounts
LEFT JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
AND accounts.primary_poc < sales_reps.name;

/* 3) Self JOINs */

/* Self JOINs are used in very rare situations, but can be useful if you want to know when events happened one after another, such as in the example case where you want to know which accounts placed multiple orders within 30 days */

/* ex) in this example below, we want to find out which accounts had multiple orders placed within 30 days of an order (any order), to see which accounts are likely to place multiple orders. To do so, we need to perform a self JOIN, using aliases to separate the two instances of the same table, and joining using two comparison operator conditions. The first is to join only rows in o2 where the occurred_at is greater than the occurred_at in o1, so only selecting orders after the original order in o1, and then the second is to specify that orders in o2 occurred within a 28 day interval of the original order placed in o1. */

SELECT o1.id AS o1.id,
       o1.account_id AS o1.acconut_id,
       o1.occurred_at AS o1.occurred_at,
       o2.id AS o2.id,
       o2.account_id AS o2.account_id,
       o2.occurred_at AS o2.occurred_at,
FROM orders o1
LEFT JOIN orders o2
ON o1.account_id = o2.account_id
AND o2.occurred_at > o1.occurred_at
AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at;

/* ex) doing the same thing but for web events, web events that occurred one day or less than after the original event */

SELECT w1.id AS w_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w1.channel AS w1_channel,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at,
       w2.channel AS w2_channel
FROM web_events w1
LEFT JOIN web_events w2
ON w1.account_id = w2.account_id
AND w1.occurred_at > w2.occurred_at
AND w1.occurred_at <= w2.occurred_at + INTERVAL '1 day'
ORDER BY w1.account_id, w2.occurred_at;

/* 4) UNION operator */

/* The UNION operator is used to combine the results of two or more SELECT statements, removing any duplicate rows between the results of those queries. Each SELECT statement must have the same number of fields/columns with similar data types, and is typically used when you want to pull distinct values of select columns across multiple tables, such as the ingredients for different meals, or the results of different queries on the same table, or append an aggregation like a sum to the end of a list of data. UNION ALL does the same thing, except it doesn't remove duplciate rows. */

SELECT *
FROM orders1
UNION
SELECT *
FROM orders2;

/* You can pretreat the tables before a union, such as using a WHERE condition to select only specific data in the first table, and another WHERE clause and a different condition in the second table */

SELECT *
FROM web_events
WHERE channel = 'Facebook'
UNION
SELECT *
FROM web_events
WHERE channel = 'direct';

/* you can then perform queries on the union table instead of the individual tables by making the results of the union into a subquery, or using it with the WITH keyword */

SELECT channel, COUNT(*) AS sessions
FROM (SELECT *
  FROM web_events
  WHERE channel = 'Facebook'
  UNION
  SELECT *
  FROM web_events
  WHERE channel = 'direct')
GROUP BY channel
ORDER BY sessions;

/* UNION ALL on two instances of the same table returns twice the results of the table on its own */

SELECT *
FROM accounts a1
UNION ALL
SELECT *
FROM accounts a2;

/* pretreating tables example to extract Walmart and Disney */

SELECT *
FROM accounts a1
WHERE name = 'Walmart'
UNION
SELECT *
FROM accounts a2
WHERE name = 'Disney';

/* Performing operations on a combined dataset */

/* Perform the union in your first query (under the Appending Data via UNION header) in a common table expression and name it double_accounts. Then do a COUNT the number of times a name appears in the double_accounts table. If you do this correctly, your query results should have a count of 2 for each name, since you just stacked two copies of the same table on top of each other with UNION ALL, like below */

WITH double_accounts AS (
    SELECT *
      FROM accounts

    UNION ALL

    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
FROM double_accounts
GROUP BY 1
ORDER BY 2 DESC;

/* 5) Performance Tunin with SQL */

/* SQL allows you to work with massive datasets, but there are ways to improve the performance of your queries so that even with massive datasets, the runtime of the queries isn't too bad, just like improving time complexity in regular programming functions */

/* To make a query run faster, we want to reduce the number of operations being performed. This includes:

- reducing table size
- reducing joins
- reducing aggregations - in particular, COUNT DISTINCT takes much longer than COUNT because each row must be checked against all other rows to ensure distinct data

Sometimes, there are things you can't control affecting performance. For example, on a cloud database there may be many other users running queries at the same time as you, whereas sometimes different databases are optimised for performance differently, i.e. Redshift is optimised for query speed.

Making queries more efficient involves usually a combination of these things. */

/* ex1) Limiting the data being queried can dramatically reduce query runtime, as there's less data to look at and process, such as with time-series data where limiting to a small date window will help. For exploration, a limited result set is fine, then you can undo those for the final query. */

SELECT *
FROM orders
WHERE occurred_at BETWEEN '2022-03-01' AND '2022-03-31';

/* you can put limits in subqueries to speed up runtime, but note this often messes up the data you're working with, so only do it to test query logic, not actually run the final query */

SELECT account_id, SUM(poster_qty) AS poster_sum
FROM (SELECT * FROM orders LIMIT 100)
WHERE occurred_at BETWEEN '2022-03-01' AND '2022-03-31'
GROUP BY account_id;

/* ex2) reducing the sizes of tables before you join can reduce runtime. For example, pre-aggregating a table's results before joining reduces the number of rows in the table prior to joining and hence speeds up the query. In the example below, there are around 9000 rows in the web_events table, and 351 rows in the accounts table, but if we pre-aggregate the web_events table by account, then join, it is much faster than joining then aggregating. */

SELECT a.name, sub.web_events
FROM (SELECT account_id, COUNT(*) AS web_events_count
  FROM web_events) sub
JOIN accounts a
ON sub.account_id = a.id
ORDER BY sub.web_events DESC;

/* ex3) using EXPLAIN to get a sense of query operation */

/* You can use EXPLAIN before a query to show you the steps the query takes in its runtime, then see the cost or time associated with the query */

EXPLAIN
SELECT *
FROM orders
WHERE occurred_at BETWEEN '2022-04-09' AND '2022-04-11'
LIMIT 100;

/* ex4) Joining subqueries to boost performance */

/* Imagine that you needed to build multiple metrics for a dashboard that would help the day-to-day running of a business. You could do this through one big query, but there are many performance advantages to building many pre-aggregated subqueries and joining them to get the same result. We will be joining accounts, orders and web events and aggregate all this data together to form our dashboard metrics. */

/* The below starting query before aggregation returns nearly 79000 rows, which is a lot of data. */

SELECT o.occurred_at AS date,
       a.sales_rep_id,
       o.id AS order_id,
       we.id AS web_event_id
FROM   accounts a
JOIN   orders o
ON     o.account_id = a.id
JOIN   web_events we
ON     DATE_TRUNC('day', we.occurred_at) = DATE_TRUNC('day', o.occurred_at)
ORDER BY 1 DESC;

/* Instead of aggregating this huge dataset after this query, it's much easier to aggregate the individual tables separately, as you're counting across a much smaller number of rows per table. This forms the first sub query, which returns the days, the number of sales reps and the number of orders on that day, and only about a 1000 rows worth of data as opposed to 79000. */

SELECT DATE_TRUNC('day', o.occurred_at) AS date,
COUNT(a.sales_rep_id) AS active_sales_reps,
COUNT(o.id) AS orders
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY date;

/* Then, we can write a second subquery that will do the same but for the web events. This returns around another 1000 rows, which is much easier to join onto, and is separated out by day just like the previous subquery. */

SELECT DATE_TRUNC('day', o.occurred_at) AS date,
COUNT(w.id) AS web_visits
FROM web_events w
GROUP BY date;

/* The full final query involves us joining these two subquery tables, using a full join to ensure we account for all of the records. */

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
