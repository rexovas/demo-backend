#!/usr/bin/env sh	
nohup redis-server &	
sleep 5	
npm run start:local