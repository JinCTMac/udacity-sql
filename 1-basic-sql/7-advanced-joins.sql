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

Here a full outer join is very useful */
