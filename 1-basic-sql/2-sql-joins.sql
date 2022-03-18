/* Databases */

/* It's important to think about how data will be organised within a database, which data should be split into two separate tables, logical groupings of the data, making sure that eventually querying the data will be quick and efficient */

/* 1) Joins */

SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/* Joins let us combine the data from multiple tables together, so that we can view the different data within a single table. */

/* As we've learned, the SELECT clause indicates which column(s) of data you'd like to see in the output (For Example, orders.* gives us all the columns in orders table in the output). The FROM clause indicates the first table from which we're pulling data, and the JOIN indicates the second table. The ON clause specifies the column on which you'd like to merge the two tables together. Try running this query yourself below. */

/* we choose which columns we want to view, so we can choose to only see columns from one table, or columns from both tables */

SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/* this query pulls data from both tables into a single table */

SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/* this query only selects all columns from orders table */

SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

/* selecting a combination of columns from both tables in a single query */

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.primary_poc, accounts.website
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

/* 2) Primary keys (PK) and Foreign keys (FK) */

/* Primary Keys exist in every table, and are unique values, normally an ID, that is made unique via auto-increment. Foreign keys are columns in tables that refer to the primary keys of another table. They usually are defined with the name of the table they reference with _id, like region_id. */

/* if you wanted to join 3 tables or more, you can */

SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id

/* you can make joining tables much easier with aliases, and you actually don't need to use the AS clause to do this */

FROM tablename t1
JOIN tablename2 t2

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

/* query selecting web names associated with account name Walmart */

SELECT we.occurred_at, acc.primary_poc, we.channel, acc.name
FROM web_events we
JOIN accounts acc
ON we.account_id = acc.id
WHERE acc.name = 'Walmart';

/* selecting region, accoutn name and sales rep */

SELECT r.name region, a.name account, s.name rep
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

/* complex query with multiple joins and calculations */

SELECT r.name region, a.name account, (o.total_amt_usd/(o.total + 0.01)) unit_price
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id;

/* inner joins only pulls rows from tables where there is a match in both tables, so if you want to see a row which has no values in the second table, you need to use a left join */

/* 2) LEFT and RIGHT joins */

/* left and right joins allow us to pull up rows that might only exist in one table or the other, where they will be joined but the respective value from the other table where the row isn't present will return NULL */

/* A full outer join will join all rows from either table, returning NULL where there isn't a matching value in either table */

SELECT r.name region, s.name rep, a.name account
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE r.name = 'Midwest';

SELECT r.name region, s.name rep, a.name account
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE r.name = 'Midwest'
AND s.name LIKE 'S%';

/* query to select people with last name beginning with capital K, smart trick to put space in front of K to know it must be a last name */

SELECT r.name region, s.name rep, a.name account
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE r.name = 'Midwest'
AND s.name LIKE '% K%';

/* query to select order region, account name and unit price from orders where quantity is greater than 100 */

SELECT r.name region, (o.total_amt_usd/(o.total+0.01)) unit_price, a.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE o.standard_qty > 100;

/* same but with poster_qty > 50 and ordering by unit+price */

SELECT r.name region, a.name account_name, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
WHERE o.standard_qty > 100
AND o.poster_qty > 50
ORDER BY unit_price;

/* select all for account ID 1001 */

SELECT w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE w.account_id = 1001;

/* using select distinct to only access unique values */

SELECT DISTINCT w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE w.account_id = 1001;

/* finding all orders that happened in 2015 */

SELECT o.occurred_at order_date, a.name account, o.total total_qty, o.total_amt_usd total_price
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2015-01-01' AND '2015-12-31'
ORDER BY o.occurred_at;
