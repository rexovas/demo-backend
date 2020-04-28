#!/usr/bin/env sh
redis-server &
sleep 5
export FLASK_APP=src/app.py
flask run -h 0.0.0.0 -p 3000