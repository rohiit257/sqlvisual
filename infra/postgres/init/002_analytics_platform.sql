CREATE TABLE IF NOT EXISTS analytics.query_runs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    prompt TEXT NOT NULL,
    generated_sql TEXT,
    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'running', 'succeeded', 'failed', 'cancelled')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS analytics.query_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID NOT NULL DEFAULT uuid_generate_v4(),
    user_id TEXT,
    session_id TEXT,
    prompt TEXT,
    generated_sql TEXT,
    executed_sql TEXT,
    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'running', 'succeeded', 'failed', 'cancelled')),
    row_count INTEGER CHECK (row_count IS NULL OR row_count >= 0),
    duration_ms INTEGER CHECK (duration_ms IS NULL OR duration_ms >= 0),
    error_message TEXT,
    model_name TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS analytics.schema_metadata (
    id BIGSERIAL PRIMARY KEY,
    table_schema TEXT NOT NULL DEFAULT 'northwind',
    table_name TEXT NOT NULL,
    column_name TEXT NOT NULL,
    description TEXT NOT NULL,
    sample_values JSONB NOT NULL DEFAULT '[]'::jsonb,
    semantic_type TEXT,
    is_sensitive BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (table_schema, table_name, column_name)
);

CREATE TABLE IF NOT EXISTS analytics.sample_queries (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL,
    description TEXT NOT NULL,
    query_sql TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_query_runs_status_created_at
    ON analytics.query_runs (status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_query_log_created_at
    ON analytics.query_log (created_at DESC);

CREATE INDEX IF NOT EXISTS idx_query_log_status_created_at
    ON analytics.query_log (status, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_query_log_user_created_at
    ON analytics.query_log (user_id, created_at DESC)
    WHERE user_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_query_log_metadata_gin
    ON analytics.query_log USING GIN (metadata);

CREATE INDEX IF NOT EXISTS idx_schema_metadata_table_column
    ON analytics.schema_metadata (table_schema, table_name, column_name);

CREATE INDEX IF NOT EXISTS idx_schema_metadata_sample_values_gin
    ON analytics.schema_metadata USING GIN (sample_values);

