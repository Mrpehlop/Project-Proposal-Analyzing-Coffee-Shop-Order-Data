-- Objective 1: Explore the menu items table

-- Find the number of items on the menu:

SELECT COUNT(*) AS total_items
FROM menu_items;


-- Find the least and most expensive items on the menu:

SELECT item_name, price
FROM menu_items
ORDER BY price ASC
LIMIT 1; -- For the least expensive

SELECT item_name, price
FROM menu_items
ORDER BY price DESC
LIMIT 1; -- For the most expensive


-- Find the number of Italian dishes on the menu:

SELECT COUNT(*) AS italian_dishes
FROM menu_items
WHERE category = 'Italian';


-- Find the least and most expensive Italian dishes:

SELECT item_name, price
FROM menu_items
WHERE category = 'Italian'
ORDER BY price ASC
LIMIT 1; -- For the least expensive

SELECT item_name, price
FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC
LIMIT 1; -- For the most expensive


-- Find the number of dishes in each category:

SELECT category, COUNT(*) AS dish_count
FROM menu_items
GROUP BY category;

-- Find the average dish price in each category:

SELECT category, AVG(price) AS avg_price
FROM menu_items
GROUP BY category;


-- Objective 2: Explore the order details table

-- Find the date range of the table:

SELECT MIN(order_date) AS min_date, MAX(order_date) AS max_date
FROM order_details;


-- Find the number of orders made in the date range:

SELECT COUNT(DISTINCT order_id) AS order_count
FROM order_details;


-- Find the number of items ordered in the date range:

SELECT COUNT(*) AS item_count
FROM order_details;

-- Find the orders with the most number of items:
 
SELECT order_id, COUNT(*) AS item_count
FROM order_details
GROUP BY order_id
ORDER BY item_count DESC
LIMIT 1;

-- Find the number of orders with more than 12 items:

SELECT COUNT(*) AS order_count
FROM (
    SELECT order_id
    FROM order_details
    GROUP BY order_id
    HAVING COUNT(*) > 12
) AS orders_with_many_items;


-- Objective 3: Analyze customer behavior

-- Combine the menu items and order details tables into a single table:

SELECT o.order_id, o.item_id, m.item_name, m.price
FROM order_details o
INNER JOIN menu_items m ON o.item_id = m.item_id;


-- Find the least and most ordered items:

SELECT item_name, COUNT(*) AS order_count
FROM (
    SELECT o.item_id, m.item_name
    FROM order_details o
    INNER JOIN menu_items m ON o.item_id = m.item_id
) AS combined_data
GROUP BY item_name
ORDER BY order_count ASC
LIMIT 1; -- For the least ordered

SELECT item_name, COUNT(*) AS order_count
FROM (
    SELECT o.item_id, m.item_name
    FROM order_details o
    INNER JOIN menu_items m ON o.item_id = m.item_id
) AS combined_data
GROUP BY item_name
ORDER BY order_count DESC
LIMIT 1; -- For the most ordered


-- Find the categories of the least and most ordered items:

SELECT m.category, COUNT(*) AS order_count
FROM combined_data
INNER JOIN menu_items m ON combined_data.item_id = m.item_id
GROUP BY m.category
ORDER BY order_count ASC
LIMIT 1; -- For the least ordered category

SELECT m.category, COUNT(*) AS order_count
FROM combined_data
INNER JOIN menu_items m ON combined_data.item_id = m.item_id
GROUP BY m.category
ORDER BY order_count DESC
LIMIT 1; -- For the most ordered category


-- Find the top five orders that spent the most money:

SELECT o.order_id, SUM(m.price) AS total_spent
FROM order_details o
INNER JOIN menu_items m ON o.item_id = m.item_id
GROUP BY o.order_id
ORDER BY total_spent DESC
LIMIT 5;


-- View the details of the highest spend order:

SELECT o.order_id, m.item_name, m.price
FROM order_details o
INNER JOIN menu_items m ON o.item_id = m.item_id
WHERE o.order_id = (
    SELECT order_id
    FROM (
        SELECT order_id, SUM(m.price) AS total_spent
        FROM order_details o
        INNER JOIN menu_items m ON o.item_id = m.item_id
        GROUP BY o.order_id
        ORDER BY total_spent DESC
        LIMIT 1
    ) AS highest_spend_order
);


-- View the details of the top five highest spend orders:

SELECT o.order_id, m.item_name, m.price
FROM order_details o
INNER JOIN menu_items m ON o.item_id = m.item_id
WHERE o.order_id IN (
    SELECT order_id
    FROM (
        SELECT order_id, SUM(m.price) AS total_spent
        FROM order_details o
        INNER JOIN menu_items m ON o.item_id = m.item_id
        GROUP BY o.order_id
        ORDER BY total_spent DESC
        LIMIT 5
    ) AS top_spend_orders
);