import json
from typing import Tuple, Dict, Any


def flask_http_response(status: int, data: Any) -> Tuple[str, int, Dict[str, str]]:
    """
    Create a tuple for flask to return
    Args:
        status: integer http status to use
        data: json dump-able data for the return body
    """
    return (
        json.dumps(data, separators=(",", ":")),
        status,
        {"Content-Type": "application/json"},
    )
