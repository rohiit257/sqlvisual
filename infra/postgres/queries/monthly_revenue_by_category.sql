SELECT
    sales_month,
    category_name,
    SUM(net_revenue) AS net_revenue
FROM analytics.monthly_sales_summary
GROUP BY sales_month, category_name
ORDER BY sales_month, net_revenue DESC;

