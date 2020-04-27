#!/usr/bin/env sh
redis-server &
sleep 5
node src/server.js
