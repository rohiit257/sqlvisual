CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gin;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

CREATE SCHEMA IF NOT EXISTS analytics;
CREATE SCHEMA IF NOT EXISTS northwind;

DO $$
BEGIN
    EXECUTE format('ALTER DATABASE %I SET timezone TO %L', current_database(), 'UTC');
    EXECUTE format('ALTER DATABASE %I SET statement_timeout TO %L', current_database(), '60s');
    EXECUTE format(
        'ALTER DATABASE %I SET idle_in_transaction_session_timeout TO %L',
        current_database(),
        '60s'
    );
END;
$$;
