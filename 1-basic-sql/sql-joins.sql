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
