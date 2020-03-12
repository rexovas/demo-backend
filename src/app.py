from flask import request
from src.routes import routes
from typing import Any
from src import app


@app.before_request
def before_request() -> Any:
    print(request.headers)


routes(app)


if __name__ == "__main__":
    app.run()
