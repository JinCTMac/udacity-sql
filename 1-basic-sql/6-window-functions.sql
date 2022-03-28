/* Window Functions */

/* Window functions allow you to compare one row to another without any joins, allowing you to do things like create a running total and comparing rows against another to see if one row is larger than the other, etc */

/* the window function below could be described as calcuating the sum of the standard_qty up to a certain point, ordering by date occurred_at */

SELECT standard_qty,
SUM(standard_qty) OVER (ORDER BY occurred_at) AS running_total
FROM orders;
