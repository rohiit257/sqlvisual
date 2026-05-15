SELECT
    customer_id,
    customer_name,
    customer_country,
    COUNT(DISTINCT order_id) AS orders,
    SUM(net_revenue) AS net_revenue
FROM analytics.order_line_revenue
GROUP BY customer_id, customer_name, customer_country
ORDER BY net_revenue DESC;

