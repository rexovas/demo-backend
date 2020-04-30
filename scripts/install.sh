#!/usr/bin/env bash

aws cloudformation deploy \
--stack-name $NAME-config-$STAGE \
--template-file ./templates/cloudformation/cft.service.yaml \
--parameter-overrides Stage=$STAGE Domain=$DOMAIN \
--capabilities CAPABILITY_NAMED_IAM \
--no-fail-on-empty-changeset

kubectl apply -f ./templates/helm/$NAME/namespace-$STAGE.yaml

helm upgrade --install $NAME \
--namespace $NAME-$STAGE \
--values ./templates/helm/$NAME/values-$STAGE.yaml ./templates/helm/$NAME \
--set image.tag=$TAG  \
--set ingress.host=$HOST \
--set ingress.domain=$DOMAIN \
--set deployment.port=$PORT --debug
