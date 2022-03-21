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
