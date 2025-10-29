/*
QUESTIONS BASE ON WINDOWS FUNCTIONS :- Hard-Level-1 Question.

Moving average revenue
Calculate a 7-day moving average of total revenue for each pizza category, ordered by ORDER_DATE.

Identify outlier pizzas
Find pizzas whose revenue is greater than 1.5 times the interquartile range (IQR) above the 75th percentile within their category.
*/

-- Q1. List the pizza that generated the second highest total revenue in each category. Make sure to handle ties correctly.
SELECT 
* FROM
(SELECT *,
DENSE_RANK() OVER(PARTITION BY X.PIZZA_CATEGORY ORDER BY X.TOTAL_REV DESC) AS RN
FROM
(SELECT PIZZA_NAME, PIZZA_CATEGORY, SUM(TOTAL_PRICE) AS TOTAL_REV
FROM PIZZA_ORDERS
GROUP BY PIZZA_CATEGORY, PIZZA_NAME) AS X) AS Y
WHERE Y.RN = 2;

-- Q2. For each pizza category, calculate the cumulative revenue day by day (ORDER_DATE) and show the cumulative total alongside each order.
SELECT *
FROM
(SELECT *,
SUM(X.TOTAL_REV) OVER(PARTITION BY X.PIZZA_CATEGORY ORDER BY X.ORDER_DATE ASC) AS CUMULATIVE_TOTAL
FROM
(SELECT PIZZA_CATEGORY,ORDER_DATE, SUM(TOTAL_PRICE) AS TOTAL_REV
FROM PIZZA_ORDERS
GROUP BY 1, ORDER_DATE) AS X) AS Y
ORDER BY Y.ORDER_DATE, Y.PIZZA_CATEGORY;

-- Q3. Find the top 3 pizzas in each category by total revenue. If there are ties at the Nth position, include all tied pizzas.
SELECT *
FROM
(SELECT *,
DENSE_RANK() OVER(PARTITION BY X.PIZZA_CATEGORY ORDER BY X.TOTAL_REV DESC) AS RN
FROM 
(SELECT PIZZA_CATEGORY,PIZZA_NAME,SUM(TOTAL_PRICE) AS TOTAL_REV
FROM PIZZA_ORDERS
GROUP BY 1,2) AS X) AS Y
WHERE Y.RN <= 3;

-- Q.4 For each CUSTOMER_ID, rank pizzas they ordered by revenue and calculate the difference in revenue between consecutive pizzas they ordered (based on date).
/* SELECT ORDER_ID, PIZZA_NAME,ORDER_DATE,
SUM(TOTAL_PRICE) AS REV
FROM PIZZA_ORDERS
GROUP BY ORDER_ID, PIZZA_NAME,ORDER_DATE */