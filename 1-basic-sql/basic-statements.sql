/* Basic SQL statements */

/* 1) SELECT statement */

SELECT *
from table_name;

/* 2) LIMIT clause - used to limit query return rows */

SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;

/* 3) The ORDER BY statement always comes in a query after the SELECT and FROM statements, but before the LIMIT statement. If you are using the LIMIT statement, it will always appear last. As you learn additional commands, the order of these statements will matter more.

Pro Tip
Remember DESC can be added after the column in your ORDER BY statement to sort in descending order, as the default is to sort in ascending order. */

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

/* use DESC to get largest value instead of smallest */

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

/* you can use ORDER BY with multiple columns */

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;
