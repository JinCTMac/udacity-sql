/* Dividing an integer result of a count over another count - aka finding the proportion of the total data */

SELECT
CAST((SELECT COUNT(*) FROM accounts WHERE name LIKE 'A%') AS FLOAT)/COUNT(*)
FROM accounts;
