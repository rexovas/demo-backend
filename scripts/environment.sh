#!/usr/bin/env bash

export NAME="demo-backend"
# - export VERSION=$(node -e "console.log(require('./package.json').version)")
export VERSION="1.0.0"
if [ -z "$VERSION" ]; then echo "VERSION variable is missing"; exit 1; fi
export HOST="demo"
export DOMAIN=".api.rex.vision"
export PORT=5000
export TAG="$STAGE-$VERSION"
