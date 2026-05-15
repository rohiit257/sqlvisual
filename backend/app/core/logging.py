import logging
import sys
from typing import Any

from pythonjsonlogger.json import JsonFormatter

from app.core.config import Settings
from app.utils.trace import get_trace_id


class TraceIdFilter(logging.Filter):
    def filter(self, record: logging.LogRecord) -> bool:
        record.trace_id = get_trace_id()
        return True


def configure_logging(settings: Settings) -> None:
    root_logger = logging.getLogger()
    root_logger.handlers.clear()
    root_logger.setLevel(settings.log_level.upper())

    handler = logging.StreamHandler(sys.stdout)
    handler.addFilter(TraceIdFilter())
    handler.setFormatter(_build_formatter(settings.json_logs))

    root_logger.addHandler(handler)

    for logger_name in ("uvicorn", "uvicorn.error", "sqlalchemy.engine"):
        logging.getLogger(logger_name).handlers.clear()
        logging.getLogger(logger_name).propagate = True

    logging.getLogger("uvicorn.access").disabled = True


def _build_formatter(json_logs: bool) -> logging.Formatter:
    if json_logs:
        return JsonFormatter(
            "%(asctime)s %(levelname)s %(name)s %(message)s %(trace_id)s",
            rename_fields={"asctime": "timestamp", "levelname": "level"},
        )

    return logging.Formatter(
        "%(asctime)s %(levelname)s [%(trace_id)s] %(name)s: %(message)s"
    )


def log_extra(**kwargs: Any) -> dict[str, Any]:
    return {"extra": kwargs}

