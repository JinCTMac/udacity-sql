/* 1) LIKE

The LIKE operator is extremely useful for working with text. You will use LIKE within a WHERE clause. The LIKE operator is frequently used with %. The % tells us that we might want any number of characters leading up to a particular set of characters or following a certain set of characters, as we saw with the google syntax above. Remember you will need to use single quotes for the text you pass to the LIKE operator, because of this lower and uppercase letters are not the same within the string. Searching for 'T' is not the same as searching for 't'. In other SQL environments (outside the classroom), you can use either single or double quotes.
*/

SELECT *
FROM orders
WHERE url = 'www.google.com';

/* would return 0 as the results don't match that specific url, so we use LIKE and % wildcards to get around that */

SELECT *
FROM orders
WHERE url LIKE '%google%';

/* select all companies that have names beginning with C */

SELECT *
FROM accounts
WHERE name LIKE 'C%';

SELECT *
FROM accounts
WHERE name LIKE '%s';

/* 2) IN clause */
/* The IN operator is useful for working with both numeric and text columns. This operator allows you to use an =, but for more than one item of that particular column. We can check one, two or many column values for which we want to pull data, but all within the same query. In the upcoming concepts, you will see the OR operator that would also allow us to perform these tasks, but the IN operator is a cleaner way to write these queries.*/

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');

/* 3) NOT clause */
/* The NOT operator is an extremely useful operator for working with the previous two operators we introduced: IN and LIKE. By specifying NOT LIKE or NOT IN, we can grab all of the rows that do not meet a particular criteria. */

/* so for example, using NOT LIKE with %google% wildcards us see all sites that don't have google in them */

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

/* select companies where name doesn't begin with C */

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%';

SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';

/* 4) AND clause */
/* The AND operator is used within a WHERE statement to consider more than one logical clause at a time. Each time you link a new statement with an AND, you will need to specify the column you are interested in looking at. You may link as many statements as you would like to consider at the same time. This operator works with all of the operations we have seen so far including arithmetic operators (+, *, -, /). LIKE, IN, and NOT logic can also be linked together using the AND operator. */

SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

/* selects if name doesn't begin with C and doesn't end with s */

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT LIKE '%s';

/* 5) BETWEEN clause */
/* Sometimes we can make a cleaner statement using BETWEEN than we can using AND. Particularly this is true when we are using the same column for different parts of our AND statement. In the previous video, we probably should have used BETWEEN, as it is especially useful for dates. */

SELECT *
FROM orders
WHERE date BETWEEN '2022-03-12' AND '2022-03-14';
