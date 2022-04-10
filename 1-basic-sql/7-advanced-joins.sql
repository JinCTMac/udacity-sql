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
