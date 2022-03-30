/* AGGREGATES - Dividing an integer result of a count over another count - aka finding the proportion of the total data */

SELECT
CAST((SELECT COUNT(*) FROM accounts WHERE name LIKE 'A%') AS FLOAT)/COUNT(*)
FROM accounts;

/* AGGREGATES - Dividing integer result of count over another count to find proportion, then grouping results by week */

SELECT DATE_TRUNC('week', occurred_at) week,
CAST((SELECT COUNT(*) FROM orders WHERE total > 50) AS FLOAT)/COUNT(*) orders_over_50
FROM orders
GROUP BY week
ORDER BY week;
