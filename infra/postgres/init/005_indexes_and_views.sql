CREATE INDEX IF NOT EXISTS idx_customers_country_city
    ON northwind.customers (country, city);

CREATE INDEX IF NOT EXISTS idx_customers_company_trgm
    ON northwind.customers USING GIN (company_name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_suppliers_country
    ON northwind.suppliers (country);

CREATE INDEX IF NOT EXISTS idx_products_category_supplier
    ON northwind.products (category_id, supplier_id);

CREATE INDEX IF NOT EXISTS idx_products_discontinued
    ON northwind.products (discontinued);

CREATE INDEX IF NOT EXISTS idx_products_name_trgm
    ON northwind.products USING GIN (product_name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_orders_order_date
    ON northwind.orders (order_date);

CREATE INDEX IF NOT EXISTS idx_orders_order_date_brin
    ON northwind.orders USING BRIN (order_date);

CREATE INDEX IF NOT EXISTS idx_orders_customer_date
    ON northwind.orders (customer_id, order_date DESC);

CREATE INDEX IF NOT EXISTS idx_orders_employee_date
    ON northwind.orders (employee_id, order_date DESC);

CREATE INDEX IF NOT EXISTS idx_orders_ship_country_date
    ON northwind.orders (ship_country, order_date DESC);

CREATE INDEX IF NOT EXISTS idx_order_details_product_order
    ON northwind.order_details (product_id, order_id);

CREATE INDEX IF NOT EXISTS idx_order_details_revenue_covering
    ON northwind.order_details (order_id, product_id)
    INCLUDE (unit_price, quantity, discount);

CREATE OR REPLACE VIEW analytics.order_line_revenue AS
SELECT
    o.order_id,
    o.order_date,
    o.customer_id,
    c.company_name AS customer_name,
    c.country AS customer_country,
    o.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    p.product_id,
    p.product_name,
    cat.category_name,
    od.unit_price,
    od.quantity,
    od.discount,
    ROUND((od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS net_revenue
FROM northwind.order_details od
JOIN northwind.orders o ON o.order_id = od.order_id
JOIN northwind.products p ON p.product_id = od.product_id
JOIN northwind.categories cat ON cat.category_id = p.category_id
LEFT JOIN northwind.customers c ON c.customer_id = o.customer_id
LEFT JOIN northwind.employees e ON e.employee_id = o.employee_id;

CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.monthly_sales_summary AS
SELECT
    DATE_TRUNC('month', order_date)::date AS sales_month,
    category_name,
    customer_country,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(quantity) AS units_sold,
    ROUND(SUM(net_revenue), 2) AS net_revenue
FROM analytics.order_line_revenue
GROUP BY 1, 2, 3;

CREATE UNIQUE INDEX IF NOT EXISTS idx_monthly_sales_summary_unique
    ON analytics.monthly_sales_summary (sales_month, category_name, customer_country);

CREATE INDEX IF NOT EXISTS idx_monthly_sales_summary_revenue
    ON analytics.monthly_sales_summary (net_revenue DESC);

CREATE OR REPLACE VIEW analytics.monthly_sales_summary_view AS
SELECT
    sales_month,
    category_name,
    customer_country,
    order_count,
    units_sold,
    net_revenue
FROM analytics.monthly_sales_summary;

CREATE OR REPLACE FUNCTION analytics.refresh_monthly_sales_summary()
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY analytics.monthly_sales_summary;
END;
$$;

ANALYZE northwind.categories;
ANALYZE northwind.suppliers;
ANALYZE northwind.customers;
ANALYZE northwind.employees;
ANALYZE northwind.shippers;
ANALYZE northwind.products;
ANALYZE northwind.orders;
ANALYZE northwind.order_details;
