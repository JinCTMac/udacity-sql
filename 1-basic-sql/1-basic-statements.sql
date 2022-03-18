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

/* results are different depending on which column you order by first */

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;

/* 4) Using the WHERE statement, we can display subsets of tables based on conditions that must be met. You can also think of the WHERE command as filtering the data.

This video above shows how this can be used, and in the upcoming concepts, you will learn some common operators that are useful with the WHERE' statement.

Common symbols used in WHERE statements include:

> (greater than)

< (less than)

>= (greater than or equal to)

<= (less than or equal to)

= (equal to)

!= (not equal to) */

SELECT *
FROM orders
WHERE gloss_amt_usd >= 100
LIMIT 5;

SELECT *
FROM orders
WHERE total_amt_usd < 500
LIMIT 10;

/* The WHERE statement can also be used with non-numeric data. We can use the = and != operators here. You need to be sure to use single quotes (just be careful if you have quotes in the original text) with the text data, not double quotes.

Commonly when we are using WHERE with non-numeric data fields, we use the LIKE, NOT, or IN operators. We will see those before the end of this lesson! */

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

SELECT name, website, primary_poc
FROM accounts
WHERE name != 'Exxon Mobil';

/* 5) Creating a new column that is a combination of existing columns is known as a derived column (or "calculated" or "computed" column). Usually you want to give a name, or "alias," to your new column using the AS keyword. */

SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;

/* Remember PEMDAS from math class to help remember the order of operations? If not, check out this link as a reminder. The same order of operations applies when using arithmetic operators in SQL.

The following two statements have very different end results:

Standard_qty / standard_qty + gloss_qty + poster_qty
standard_qty / (standard_qty + gloss_qty + poster_qty) */

SELECT id, account_id, (standard_amt_usd/standard_qty) AS unit_price
FROM orders
LIMIT 10;

SELECT id, account_id, (poster_amt_usd/total_amt_usd)*100 AS poster_percentage
FROM orders
LIMIT 10;
