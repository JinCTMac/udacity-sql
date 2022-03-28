/* Window Functions */

/* Window functions allow you to compare one row to another without any joins, allowing you to do things like create a running total and comparing rows against another to see if one row is larger than the other, or doing an aggregation and partioning results across select data like a GROUP BY, see https://www.postgresql.org/docs/9.1/tutorial-window.html, another resource https://blog.sqlauthority.com/2015/11/04/sql-server-what-is-the-over-clause-notes-from-the-field-101/ */

/* ex1) the window function below could be described as calcuating the sum of the standard_qty up to a certain point, ordering by date occurred_at */

SELECT standard_qty,
SUM(standard_qty) OVER (ORDER BY occurred_at) AS running_total
FROM orders;

/* ex2) we can also make a window function calculate the running total up to the end of each month */

SELECT standard_qty,
DATE_TRUNC('month', occurred_at) AS date,
SUM(standard_qty) OVER ( PARTITION BY DATE_TRUNC('month', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders;
