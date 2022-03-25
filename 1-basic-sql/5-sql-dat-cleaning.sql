/* CLEANING DATA IN SQL */

/* data is normally not in the format you want, so you oftentimes need to clean and reorganise the data to make it into a suitable format for query/analysis - this involves changing data types, removing NULL data, removing anomalies, etc */

/* 1) LEFT AND RIGHT */

/* LEFT is used to pull characters from the left side of a string and present them as a separate string */

/* RIGHT does the same but from the right side of the string - note they make whole new columns by doing this */

SELECT phone_number, LEFT(phone_number, 3) AS area_code
FROM address_book;

/* 1a) we can also use LENGTH, which represents the length of the string, to do our calculations for the string we want to retrieve, like below where we use it to get only the rightmost 8 characters of the string */

SELECT phone_number, RIGHT(phone_number, LENGTH(phone_number) - 4) AS phone_number_only
FROM address_book;

/* q1) find out number of each type of website extension in accounts */

/* q1a) just checking the function */
SELECT name, website, RIGHT(website, 3)
FROM accounts;

/* q1b) counting number of extensions */

SELECT RIGHT(website, 3), COUNT(RIGHT(website, 3))
FROM accounts
GROUP BY RIGHT(website, 3);

/* q2) finding most common starting letters for names */

SELECT LEFT(name, 1) letter, COUNT(LEFT(name, 1)) amt
FROM accounts
GROUP BY LEFT(name, 1)
ORDER BY amt DESC;

/* q3) finding out which companies start with letters and which with numbers */

SELECT name,
CASE WHEN LEFT(name, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN 'number'
ELSE 'letter'
END AS first_char
FROM accounts;

/* q31) total number of companies starting with letter is 350, and there are 351 records so 350/351 */

WITH t1 AS (SELECT name,
CASE WHEN LEFT(name, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN 'number'
ELSE 'letter'
END AS first_char
FROM accounts)

SELECT COUNT(*)
FROM t1
WHERE first_char = 'letter';

/* q4) which proportion of companies start with a vowel and what % is anything else */

/* q4a) find out which companies start with vowel and label */

SELECT name,
CASE WHEN LEFT(name, 1) IN ('A', 'E', 'I', 'O', 'U') THEN 'vowel'
ELSE 'not_vowel'
END AS start_char
FROM accounts;

/* q4b) then count number of companies with vowels in starting char and divide by total - total is 79 so 79/351 for vowels % */

WITH t1 AS (SELECT name,
CASE WHEN LEFT(name, 1) IN ('A', 'E', 'I', 'O', 'U') THEN 'vowel'
ELSE 'not_vowel'
END AS start_char
FROM accounts)

SELECT COUNT(*)
FROM t1
WHERE start_char = 'vowel';
