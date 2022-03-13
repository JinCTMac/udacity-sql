/* Basic SQL statements */

/* SELECT statement */

SELECT *
from table_name;

/* LIMIT clause - used to limit query return rows */

SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;
