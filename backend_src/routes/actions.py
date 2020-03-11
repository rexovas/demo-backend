from flask import g
from backend_src import helpers


def get_arg(req, key: str) -> str:
    return req.args.get(key)


def redis_test(req):
    key = get_arg(req, "key")
    if not key:
        return helpers.flask_http_response(400, {"message": "key not specified"})
    if req.method == "POST":
        value = get_arg(req, "value")
        g.cache.set(key, value)
        return helpers.flask_http_response(200, {'message': f"value for key '{key}' updated successfully"})
    else:
        value = g.cache.get(key)
        return (
            helpers.flask_http_response(200, {'key': key, 'value': value})
            if value
            else helpers.flask_http_response(
                404, {"message": f"value for key '{key}' not found"}
            )
        )
