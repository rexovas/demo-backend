#!/usr/bin/env bash

# export VERSION=$(cat package.json | jq -r '.version')
STAGE='production'

# aws cloudformation deploy --stack-name demo-backend-config-${STAGE} --parameter-overrides Stage=${STAGE} --template-file ./templates/cloudformation/cft.service.yaml --capabilities CAPABILITY_NAMED_IAM
aws cloudformation deploy --stack-name demo-backend-cicd --template-file ./templates/cloudformation/cft.cicd.yaml --capabilities CAPABILITY_NAMED_IAM
# aws --region us-west-2 cloudformation deploy --stack-name demo-backend-cicd --template-file ../templates/cloudformation/cft.cicd.yaml # --capabilities CAPABILITY_NAMED_IAM
# aws --region us-west-2 cloudformation deploy --stack-name demo-backend-config-development --template-file ../templates/cloudformation/cft.service.yaml # --capabilities CAPABILITY_NAMED_IAM
