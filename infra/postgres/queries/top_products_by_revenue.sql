SELECT
    product_name,
    category_name,
    SUM(net_revenue) AS net_revenue,
    SUM(quantity) AS units_sold
FROM analytics.order_line_revenue
GROUP BY product_name, category_name
ORDER BY net_revenue DESC
LIMIT 10;

