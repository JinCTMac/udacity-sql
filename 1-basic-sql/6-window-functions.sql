/* Window Functions */

/* Window functions allow you to compare one row to another without any joins, allowing you to do things like create a running total and comparing rows against another to see if one row is larger than the other, or doing an aggregation and partioning results across select data like a GROUP BY, see https://www.postgresql.org/docs/9.1/tutorial-window.html, another resource https://blog.sqlauthority.com/2015/11/04/sql-server-what-is-the-over-clause-notes-from-the-field-101/, another resource with an image showing how window functions differ from aggregate functions https://www.sqltutorial.org/sql-window-functions/ */

/* another great resource for understanding how window functions work https://towardsdatascience.com/a-guide-to-advanced-sql-window-functions-f63f2642cbf9*/

/* ex1) the window function below could be described as calcuating the sum of the standard_qty up to a certain point, ordering by date occurred_at, which uses the OVER keyword to indicate it is a window function */

SELECT standard_qty,
SUM(standard_qty) OVER (ORDER BY occurred_at) AS running_total
FROM orders;

/* ex2) we can also make a window function calculate the running total up to the end of each month, using the PARTITION BY keywords to indicate that the results will be split for each month, where the running total resets back to 0 once a new month begins */

SELECT standard_qty,
DATE_TRUNC('month', occurred_at) AS date,
SUM(standard_qty) OVER ( PARTITION BY DATE_TRUNC('month', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders;

/* task 1) create own running total via window function, ordered by date */

SELECT id, standard_amt_usd,
SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders;

/* task 2) now create a running total partioned by year, great stack overflow post for another example of partioning https://stackoverflow.com/questions/561836/oracle-partition-by-keyword */

SELECT standard_amt_usd,
DATE_TRUNC('year', occurred_at) AS date,
SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders;

SELECT standard_amt_usd,
       DATE_TRUNC('year', occurred_at) as year,
       SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders

/* Window Functions 2 */

/* ROW_NUMBER() is a function that numbers the rows in increment over the window you specify, by the ORDER BY you give */

SELECT id, account_id,
ROW_NUMBER() OVER (ORDER BY id) AS row_num
FROM accounts;

/* RANK() does something very similar in that it orders the rows in increment over the window given, but if they are partioned by anything and the partioning value is the same for 2 columns, they are given the same row value or rank, and then skips numbers depending on the number of rows that share the same rank - DENSE_RANK() is the same but doesn't skip numbers */

SELECT id, account_id,
DATE_TRUNC('month', occurred_at) AS month,
RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS row_num
FROM orders;

/* task 1) rank total paper by each account, ordered by the total number of paper sold */

SELECT id, account_id, total,
RANK() OVER (PARTITION BY account_id ORDER BY total) AS total_rank
FROM orders;

/* Window Functions 3 - Using aggregates with window functions */

/* SUM just does a running total, with splits depending on if the data is partitioned by anything, such as date */

/* COUNT shows a running count, with similar potential to be partitioned */

/* AVG does a running average, aka the running SUM by the running COUNT */

/* MIN shows the lowest value up to that point in the window, so it will likely drop until the next window partition occurs, at which point it will reset to the lowest value in the next window partition */

/* MAX works the same way as MIN */

/* Window Functions With or Without ORDER BY */

/* The ORDER BY clause is one of two clauses integral to window functions. The ORDER and PARTITION define what is referred to as the “window”—the ordered subset of data over which calculations are made. Removing ORDER BY just leaves an unordered partition; in our query's case, each column's value is simply an aggregation (e.g., sum, count, average, minimum, or maximum) of all the standard_qty values in its respective account_id. Explanation here https://stackoverflow.com/questions/41364665/analytic-count-over-partition-with-and-without-order-by-clause */

/* The easiest way to think about this - leaving the ORDER BY out is equivalent to "ordering" in a way that all rows in the partition are "equal" to each other. Indeed, you can get the same effect by explicitly adding the ORDER BY clause like this: ORDER BY 0 (or "order by" any constant expression), or even, more emphatically, ORDER BY NULL. */

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders

/* Window Functions 4 - using an alias */

/* instead of writing the window function multiple times in the same query for multiple columns, you can just write a single window function and reference that in the columns */

SELECT id, account_id, standard_qty,
DATE_TRUNC('month', occurred_at) AS month,
DENSE_RANK() OVER main_window AS dense_rank,
SUM(standard_qty) OVER main_window AS sum_standard_qty
COUNT(standard_qty) OVER main_window AS count_standard_qty
FROM orders
WINDOW main_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at));

/* task to do the same for a different query */

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER main_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER main_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER main_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER main_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER main_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER main_window AS max_total_amt_usd
FROM orders
WINDOW main_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))

/* Window Functions 5 - Comparing a row to a previous row */

/* you can use LAG and LEAD to create new columns containing the values above and below a row in the table, to compare the difference in value between rows previous and after a row */

/* LAG returns the value from the previous row to the current row in the table */

/* 1) inner query gives accounts and the SUM of the standard qty paper they've bought over time */

SELECT account_id, SUM(standard_qty) AS standard_sum
FROM orders
GROUP BY 1;

/* 2) outer query just queries the same info from that subquery table */

SELECT account_id, standard_sum
FROM   (
        SELECT   account_id, SUM(standard_qty) AS standard_sum
        FROM     orders
        GROUP BY 1
       ) sub

/* 3) we use the window function to order by the amount of standard_qty purchase, then we call the lag function to create a new column that pulls the value from the previous row, for the first row it will be NULL as there is no previous value to pull from */

SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag
FROM   (
        SELECT   account_id, SUM(standard_qty) AS standard_sum
        FROM     orders
        GROUP BY 1
       ) sub

/* 4) to compare values between rows, we need to create a lag_difference column that is the current row value - the lag row value */

SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
       standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference
FROM (
       SELECT account_id,
       SUM(standard_qty) AS standard_sum
       FROM orders
       GROUP BY 1
      ) sub

/* LEAD returns value from following row */

/* parts 1 and 2 are the same as LAG, part 3) involves creating the lead function as a window function ordered by standard_sum */

SELECT account_id,
       standard_sum,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead
FROM   (
        SELECT   account_id,
                 SUM(standard_qty) AS standard_sum
        FROM     demo.orders
        GROUP BY 1
       ) sub

/* 4) create the lead_difference column as the lead value - the current row standard_sum value */

SELECT account_id,
       standard_sum,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
       FROM orders
       GROUP BY 1
     ) sub

/* USE CASES FOR LEAD AND LAG */

/* You can use LAG and LEAD functions whenever you are trying to compare the values in adjacent rows or rows that are offset by a certain number.

Example 1: You have a sales dataset with the following data and need to compare how the market segments fare against each other on profits earned.

Example 2: You have an inventory dataset with the following data and need to compare the number of days elapsed between each subsequent order placed for Item A. */

/* task 1) using LEAD function to look at sales of next order and determine the difference in revenue between order and next order based on date, ordered by occurred_at */

SELECT occurred_at,
       total_amt,
       LEAD(total_amt) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt) OVER (ORDER BY occurred_at) - total_amt AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt
  FROM orders
 GROUP BY 1
 ) sub
 ORDER BY occurred_at;

/* Window Functions 6 - using percentiles to see where most data falls i.e. distribution */

/* We can use the NTILE function to determine which percentile the row falls into with a piece of data, so if we use standard_qty as the data, we can use NTILE to split the data into percentiles, quartiles, quintiles, etc baesd on the size of the data value, where the largest goes into the largest quartile/quintile/percentile, and the smallest goes in the 1st quartile/quintile/percentile */

SELECT id, occurred_at, standard_qty,
  NTILE(4) OVER (ORDER BY standard_qty) AS quartile,
  NTILE(5) OVER (ORDER BY standard_qty) AS quintile,
  NTILE(100) OVER (ORDER BY standard_qty) AS percentile
FROM orders
ORDER BY standard_qty DESC;

/* q1) use NTILE to divide accounts into their order, split by quantile baesd on the standard_qty */

SELECT account_id, occurred_at, SUM(standard_qty) total_qty,
NTILE(4) OVER (ORDER BY SUM(standard_qty)) AS quartile
FROM orders
GROUP BY account_id, occurred_at
ORDER BY total_qty DESC;
