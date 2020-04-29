#!/usr/bin/env bash

source ./environment.sh

aws cloudformation deploy \
--stack-name demo-backend-cicd \
--template-file ./templates/cloudformation/cft.cicd.yaml \
--parameter-overrides Stage=$STAGE Name=$NAME \
--capabilities CAPABILITY_NAMED_IAM
