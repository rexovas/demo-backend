from flask import Flask
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_caching import Cache
from flask_cors import CORS
import os

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
