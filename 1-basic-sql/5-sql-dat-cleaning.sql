/* CLEANING DATA IN SQL */

/* data is normally not in the format you want, so you oftentimes need to clean and reorganise the data to make it into a suitable format for query/analysis - this involves changing data types, removing NULL data, removing anomalies, etc */

/* 1) LEFT AND RIGHT */

/* LEFT is used to pull characters from the left side of a string and present them as a separate string */

/* RIGHT does the same but from the right side of the string - note they make whole new columns by doing this */

/* SUBSTR extracts a substring from a string, given 3 parameters; the string, the position to start with and the number of characters to extract, going left to right i.e. SUBSTR('customers', 1, 3) returns cus */

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

/* 2) POSITION, STRPOS, LOWER, UPPER and SUBSTRING */

/* sometimes, you want to know which position in a string a certain character is for you to use LEFT/RIGHT more easily - POSITION and STRPOS will do this for you, by returning a value showing the position of the character that you specify */

/* LOWER and UPPER will convert a whole string into lower or uppercase to allow you to not worry about case in the string you are examining */

/* for example, below we use POSITION to isolate the comma in the city address, then since we just want the information before the comma, we subtract 1 from that in the lEFT function to return just the city */

SELECT LEFT(city_state, POSITION(',' IN city_state) - 1) AS city
FROM data;

/* q1) finding first and last names - for first name it is position - 1 in 2nd param, for last name you have to do length - position as position gives you the position in the string from the left, and for the right you have take it away from the length to get the right result */

SELECT name, primary_poc,
LEFT(primary_poc, POSITION(' ' IN primary_poc) - 1) AS first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
FROM accounts;

/* q2) same but for sales reps names */

SELECT name,
LEFT(name, POSITION(' ' IN name) - 1) AS first_name,
RIGHT(name, LENGTH(name) - POSITION(' ' IN name)) AS last_name
FROM sales_reps;

/* 3) CONCAT and || for merging strings */

/* you can use the CONCAT function to merge columns, with separating values like spaces and commas being coded into the function as a paramter, or use pipes || to separate values you want to concatenate */

SELECT first_name,
last_name,
CONCAT(first_name, ' ', last_name) AS full_name,
first_name || ' ' || last_name AS full_name_alt
FROM address_book;

/* q1) create an email address column with format first_name.last_name@company_name.com */

/* q1a) first split the primary_poc into first and last names */

SELECT name, primary_poc,
LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
FROM accounts;

/* q1b) then concat as appropriate, lowercase company name */

WITH t1 AS (SELECT name, primary_poc,
LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
FROM accounts)

SELECT t1.name, t1.primary_poc,
CONCAT(t1.first_name, '.', t1.last_name, '@', LOWER(name), '.com') AS email
FROM t1;

/* q2) do the same as above, but remove spaces from the company names */

/* done using the REPLACE function, which takes a column param, a set of characters to replace, and what to replace it with so REPLACE(variable, ' ', '') for example, below works as SQL evaluates inner brackets first so replacing the spaces before executing outer function */

WITH t1 AS (SELECT name, primary_poc,
LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
FROM accounts)

SELECT t1.name, t1.primary_poc,
CONCAT(t1.first_name, '.', t1.last_name, '@', LOWER(REPLACE(name, ' ', '')), '.com') AS email
FROM t1;

/* q3) create a password through concat */

WITH t1 AS (SELECT name, primary_poc,
LEFT(primary_poc, POSITION(' ' IN primary_poc)-1) AS first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
FROM accounts)

SELECT t1.name, t1.primary_poc,
CONCAT(LOWER(LEFT(t1.first_name, 1)), RIGHT(t1.last_name, 1), LEFT(t1.last_name, 1), RIGHT(t1.last_name, 1), LENGTH(t1.first_name), LENGTH(t1.last_name), t1.name) AS password
FROM t1;

/* 4) CAST function */

/* CAST allows us to convert one data type to another, typically a string to a date or a number - if we want to convert a number to a string, we can use SUBSTRING, LEFT, RIGHT, etc */

SELECT year, month, day,
CAST(CONCAT(year, '-', month, '-', day)) AS new_date
FROM datebook;

/* task to convert a non-conventional date format into a SQL-readable date format of yyyy-mm-dd */

SELECT *
FROM sf_crime_data
LIMIT 10;

/* to do this, we need the SUBSTR function alongside CONCAT and CAST */

SELECT date,
SUBSTR(date, 1, 10) AS new_date
FROM sf_crime_data
LIMIT 10;

/* now to convert that substring into the right format - my solution below, exemplar solution after that */

WITH t1 AS (SELECT date,
SUBSTR(date, 1, 10) AS new_date
FROM sf_crime_data)

SELECT t1.new_date,
CONCAT(RIGHT(t1.new_date, 4), '-', LEFT(t1.new_date, 2), '-', SUBSTR(t1.new_date, 4, 2))::date AS final_date
FROM t1
LIMIT 10;

SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;

/* 5) COALESCE function */

/* Can be used for two things; 1) returning the first NON-NULL value in a list, 2) converting all NULL values into a value you want, aka getting rid of all NULL values, useful for a COUNT aggregation */

SELECT COALESCE(primary_poc, 'NO-POC') AS modified_primary_poc
FROM data;

/* task - add values to a row where there are NULL values in the data */

/* part 1) - check which cols are NULL */

SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

/* part 2) - fill null values in accounts table with the account_id from the orders table */

SELECT COALESCE(a.id, o.account_id) filled_id, name, website, lat, long, primary_poc
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

/* part 3) - filling the null values in orders table with account ID */

SELECT COALESCE(a.id, o.account_id) filled_id, COALESCE(o.account_id, a.id) new_order_id, name, website, lat, long, primary_poc
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

/* part 4) - filling in qty and usd amounts */

SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

/* part 5) - running a count to check if values are the same and that NULL values are gone */

SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;

/* part 6) - annoying coalesce */

SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;
