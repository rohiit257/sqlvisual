INSERT INTO analytics.sample_queries (name, category, description, query_sql) VALUES
    (
        'monthly_revenue_by_category',
        'revenue',
        'Monthly net revenue grouped by product category.',
        'SELECT sales_month, category_name, SUM(net_revenue) AS net_revenue
FROM analytics.monthly_sales_summary
GROUP BY sales_month, category_name
ORDER BY sales_month, net_revenue DESC;'
    ),
    (
        'top_products_by_revenue',
        'product',
        'Top products ranked by net revenue.',
        'SELECT product_name, category_name, SUM(net_revenue) AS net_revenue, SUM(quantity) AS units_sold
FROM analytics.order_line_revenue
GROUP BY product_name, category_name
ORDER BY net_revenue DESC
LIMIT 10;'
    ),
    (
        'customer_revenue_lifetime',
        'customer',
        'Customer lifetime revenue and order count.',
        'SELECT customer_id, customer_name, customer_country, COUNT(DISTINCT order_id) AS orders, SUM(net_revenue) AS net_revenue
FROM analytics.order_line_revenue
GROUP BY customer_id, customer_name, customer_country
ORDER BY net_revenue DESC;'
    ),
    (
        'employee_sales_performance',
        'sales',
        'Sales performance by employee.',
        'SELECT employee_id, employee_name, COUNT(DISTINCT order_id) AS orders, SUM(net_revenue) AS net_revenue
FROM analytics.order_line_revenue
GROUP BY employee_id, employee_name
ORDER BY net_revenue DESC;'
    ),
    (
        'late_shipments',
        'operations',
        'Orders shipped after their required date.',
        'SELECT order_id, customer_id, order_date, required_date, shipped_date, shipped_date - required_date AS days_late
FROM northwind.orders
WHERE shipped_date > required_date
ORDER BY days_late DESC, shipped_date DESC;'
    ),
    (
        'inventory_reorder_candidates',
        'inventory',
        'Products where stock is at or below reorder level.',
        'SELECT product_id, product_name, units_in_stock, units_on_order, reorder_level, discontinued
FROM northwind.products
WHERE discontinued = FALSE
  AND units_in_stock + units_on_order <= reorder_level
ORDER BY units_in_stock ASC, reorder_level DESC;'
    )
ON CONFLICT (name) DO UPDATE
SET
    category = EXCLUDED.category,
    description = EXCLUDED.description,
    query_sql = EXCLUDED.query_sql;

