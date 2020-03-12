from backend_src.routes.methods import health_check, table_data, filter_list
from typing import NoReturn
from flask import Flask


def routes(app: Flask) -> NoReturn:
    app.add_url_rule("/health", "health_check", health_check, methods=["GET"])
    app.add_url_rule("/table-data", "get_table_data", table_data, methods=["GET"])
    app.add_url_rule("/filter-list", "get_filter_list", filter_list, methods=["GET"])
