/* Aggregations in SQL are very similar to Excel, and work on column basis not row basis */

/* NULL is important for this as if there are NULL data values within a column, this could mess up aggregation attempts */

/* 1) NULL */

/* to find out if you have NULL values in a column, you need to use IS NULL instead of = NULL, as NULL is a data property, not a value */

SELECT *
FROM orders
WHERE primary_poc IS NULL;

/* to do the opposite and find out which rows don't have NULL data, use IS NOT NULL */

SELECT *
from orders
WHERE primary_poc IS NOT NULL;
