use collegedb;
/* =====================================================
   Project: E-commerce Order Analysis
   Author : Devu
   Dataset: Olist E-commerce Dataset
   ===================================================== */

-- ===============================
-- SECTION A: BUSINESS OVERVIEW
-- ===============================

-- Q1. Total revenue
SELECT 
    SUM(price) AS total_revenue
FROM order_items;

-- Q2. Total orders
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;

-- Q3. Average order value
SELECT 
    SUM(oi.price) / COUNT(DISTINCT o.order_id) AS avg_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;

-- Q4. Unique customers
SELECT 
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

-- ===============================
-- SECTION B: CUSTOMER ANALYSIS
-- ===============================

-- Q5. Revenue per customer
SELECT 
    o.customer_id,
    SUM(oi.price) AS total_revenue
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY o.customer_id;

-- Q6. Top 10 customers by revenue
SELECT 
    c.customer_unique_id,
    SUM(oi.price) AS total_revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON oi.order_id = o.order_id
GROUP BY c.customer_unique_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Q7. Orders per customer
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
ORDER BY total_orders DESC;

-- Q8. Repeat customers
SELECT 
    c.customer_unique_id,
    COUNT(o.order_id) AS number_of_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY number_of_orders DESC;

-- Q9. Average revenue per customer
SELECT 
    AVG(customer_revenue) AS avg_revenue_per_customer
FROM (
    SELECT 
        c.customer_unique_id,
        SUM(oi.price) AS customer_revenue
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
) t;

-- ===============================
-- SECTION C: PRODUCT ANALYSIS
-- ===============================




-- Q10. Top categories by revenue
SELECT 
    t.product_category_name_english AS category,
    SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_translations t
    ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;

-- Q11. Categories by items sold
SELECT 
    t.product_category_name_english AS category,
    COUNT(*) AS items_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_translations t
    ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY items_sold DESC;

-- Q12. Top products by revenue
SELECT 
    oi.product_id,
    SUM(oi.price) AS total_revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Q13. Top products by quantity sold
SELECT 
    product_id,
    COUNT(*) AS quantity_sold
FROM order_items
GROUP BY product_id
ORDER BY quantity_sold DESC
LIMIT 10;

-- Q14. Order distribution by quantity
SELECT 
    COUNT(*) AS number_of_items,
    price
FROM order_items
GROUP BY price
ORDER BY price;

-- ===============================
-- SECTION D: PRICE ANALYSIS
-- ===============================

-- Q15. Average item price by category
SELECT 
    t.product_category_name_english AS category,
    AVG(oi.price) AS avg_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN product_translations t
    ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY avg_price DESC;

-- Q16. Revenue contribution by price range
SELECT
    CASE
        WHEN price < 100 THEN 'Low'
        WHEN price BETWEEN 100 AND 500 THEN 'Medium'
        ELSE 'High'
    END AS price_range,
    COUNT(*) AS items_sold,
    SUM(price) AS total_revenue
FROM order_items
GROUP BY price_range
ORDER BY total_revenue DESC;

 
