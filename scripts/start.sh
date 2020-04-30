#!/usr/bin/env sh
redis-server &
sleep 5
export FLASK_APP=src/app.py
gunicorn -w 4 src:app
# flask run -h 0.0.0.0