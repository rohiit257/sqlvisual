# Database

SQL Visual uses PostgreSQL 16 with two primary schemas:

- `northwind`: sample operational data for SQL generation, joins, and analytics demos.
- `analytics`: AI platform tables, query logging, schema metadata, query examples, and derived analytics views.

The database initializes automatically through Docker by mounting `infra/postgres/init` into `/docker-entrypoint-initdb.d`.

## Init Order

| Script | Purpose |
| --- | --- |
| `001_extensions_and_schemas.sql` | Enables extensions, creates schemas, and applies database-level safety defaults. |
| `002_analytics_platform.sql` | Creates `query_runs`, `query_log`, `schema_metadata`, and `sample_queries`. |
| `003_northwind_schema.sql` | Creates the PostgreSQL Northwind relational model. |
| `004_northwind_seed.sql` | Seeds a compact Northwind dataset automatically on first container startup. |
| `005_indexes_and_views.sql` | Adds analytics indexes, revenue view, monthly materialized summary, and statistics. |
| `006_schema_metadata_seed.sql` | Seeds AI-friendly column descriptions and representative sample values. |
| `007_sample_analytics_queries.sql` | Stores reusable example analytics queries in the database. |

Postgres only runs init scripts when the data directory is empty. For a clean local rebuild, start a disposable project or intentionally remove the local Compose volume.

## Platform Tables

### `analytics.query_log`

Captures natural-language prompts, generated SQL, execution status, timing, row counts, errors, model metadata, and session/user identifiers. This is the audit trail for AI-assisted analytics.

Important indexes:

- `idx_query_log_created_at` supports recent activity views.
- `idx_query_log_status_created_at` supports operational monitoring.
- `idx_query_log_user_created_at` supports user/session history.
- `idx_query_log_metadata_gin` supports JSON metadata filtering.

### `analytics.schema_metadata`

Stores AI-readable metadata for database grounding:

- `table_name`
- `column_name`
- `description`
- `sample_values`

It also includes `table_schema`, `semantic_type`, and `is_sensitive` so future LangChain tools can filter context and avoid unsafe column exposure.

### `analytics.sample_queries`

Stores curated SQL examples for product demos, prompt few-shot grounding, and regression tests.

## Northwind ERD

Core relationships:

```text
customers.customer_id 1 ── * orders.customer_id
employees.employee_id 1 ── * orders.employee_id
shippers.shipper_id   1 ── * orders.ship_via

orders.order_id       1 ── * order_details.order_id
products.product_id   1 ── * order_details.product_id

categories.category_id 1 ── * products.category_id
suppliers.supplier_id  1 ── * products.supplier_id

regions.region_id      1 ── * territories.region_id
employees.employee_id  * ── * territories.territory_id
```

Analytical grain:

- `northwind.orders` is the order header grain.
- `northwind.order_details` is the order-line grain.
- `analytics.order_line_revenue` is the main semantic view for revenue analysis.
- `analytics.monthly_sales_summary` is a materialized aggregate by month, category, and country.

## Performance Notes

The local Postgres service is configured with pragmatic analytics-oriented defaults:

- `pg_stat_statements` preloaded for query observability.
- `work_mem=16MB` and `maintenance_work_mem=128MB` for local analytical workloads.
- `wal_compression=on` to reduce WAL size.
- `random_page_cost=1.1` and `effective_io_concurrency=200` for SSD-like local environments.
- BRIN and B-tree indexes on order dates for time-series scans.
- Trigram indexes on customer and product names for fuzzy search.
- Covering index on `order_details` for revenue aggregations.

Tune these values per environment before production deployment; container memory limits, workload concurrency, and storage class matter.

## Sample Queries

SQL files live in `infra/postgres/queries` and are also inserted into `analytics.sample_queries`.

Examples:

- Monthly revenue by category.
- Top products by revenue.
- Customer lifetime revenue.
- Employee sales performance.
- Late shipments.
- Inventory reorder candidates.

## Refreshing Aggregates

Refresh the monthly materialized view after bulk data changes:

```sql
SELECT analytics.refresh_monthly_sales_summary();
```

## AI Integration Readiness

Future LangChain tools can use:

- `analytics.schema_metadata` for schema context retrieval.
- `analytics.sample_queries` for SQL generation examples.
- `analytics.query_log` for prompt/SQL auditing and evaluation.
- `analytics.order_line_revenue` as a safe semantic layer instead of exposing raw joins first.

