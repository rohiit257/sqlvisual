import pytest

from app.services.agents.tools import SQLToolRouter, SQLValidationError


def test_validate_read_only_sql_allows_select_without_semicolon() -> None:
    router = SQLToolRouter.__new__(SQLToolRouter)

    sql = router.validate_read_only_sql("SELECT product_name FROM analytics.order_line_revenue;")

    assert sql == "SELECT product_name FROM analytics.order_line_revenue"


def test_validate_read_only_sql_rejects_mutations() -> None:
    router = SQLToolRouter.__new__(SQLToolRouter)

    with pytest.raises(SQLValidationError):
        router.validate_read_only_sql("DROP TABLE analytics.query_log")

