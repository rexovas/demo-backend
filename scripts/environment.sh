#!/usr/bin/env bash

export NAME="demo-backend"
VERSION="$(cat src/version.py | awk -F= '/^__version__/ {print $2}')"
export VERSION="$(echo $VERSION | tr -d "'")"
if [ -z "$VERSION" ]; then echo "VERSION variable is missing"; exit 1; fi
export ELB="a169916f7200c4926a3f515a782505d7"
export HOSTED_ZONE="Z050060699L3CKSWFLIF"
export TOP_DOMAIN=".rex.vision"
export HOST="demo"
export DOMAIN=".api.rex.vision"
export PORT=8000
export TAG="$STAGE-$VERSION"
