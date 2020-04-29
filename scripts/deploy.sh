#!/usr/bin/env bash

# export VERSION=$(cat package.json | jq -r '.version')
STAGE='production'

aws cloudformation deploy \
--stack-name demo-backend-cicd \
--template-file ./templates/cloudformation/cft.cicd.yaml \
--parameter-overrides Stage=$STAGE Name=$NAME Port=$PORT Host=$HOST \
--capabilities CAPABILITY_NAMED_IAM
