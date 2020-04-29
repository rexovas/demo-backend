#!/usr/bin/env bash

kubectl apply -f ./templates/helm/$NAME/namespace-$STAGE.yaml
helm upgrade --install $NAME --namespace $NAME-$STAGE -f ./templates/helm/$NAME/values-$STAGE.yaml ./templates/helm/$NAME --set image.tag=$TAG  --set ingress.host=$HOST --set ingress.domain=$DOMAIN --set deployment.port=$PORT --debug
