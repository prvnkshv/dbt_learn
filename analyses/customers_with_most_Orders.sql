SELECT
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.id) AS total_orders
FROM
    raw.jaffle_shop.customers c
JOIN
    raw.jaffle_shop.orders o ON c.id = o.user_id
GROUP BY
    c.id, c.first_name, c.last_name
ORDER BY
    total_orders DESC

