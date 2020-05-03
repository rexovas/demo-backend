#!/usr/bin/env sh
redis-server &
sleep 5
# COMMENT LINE BELOW IF RUNNING DEVELOPMENT SERVER
gunicorn -w 4 -b 0.0.0.0 src:app --log-level debug
# UNCOMMENT LINES BELOW TO RUN DEVELOPMENT SERVER
# export FLASK_APP=src/app.py
# flask run -h 0.0.0.0