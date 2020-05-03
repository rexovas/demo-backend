from src.version import __version__
from flask import Flask
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_caching import Cache
from flask_cors import CORS
import os

debug = False
if os.environ.get("FLASK_DEBUG"):
    debug = os.environ["FLASK_DEBUG"]


app = Flask(__name__)
CORS(app)
limiter = Limiter(app, key_func=get_remote_address, default_limits=["100 per minute"])

cache = Cache(
    app,
    config={
        "DEBUG": True if debug == 1 else False,
        "CACHE_TYPE": "redis",
        "CACHE_DEFAULT_TIMEOUT": 0,
    },
)

from flask import request
from src.routes import routes
from typing import Any
# from src import app


@app.before_request
def before_request() -> Any:
    print(request.headers)


routes(app)


if __name__ == "__main__":
    app.run()
