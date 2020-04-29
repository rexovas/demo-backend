aws secretsmanager create-secret --name $NAME-deploy-key \
--description "$NAME GitHub Deploy Key" \
--secret-string file://access_token
# aws secretsmanager update-secret --secret-id $NAME-deploy-key \
# --secret-string file://access_token