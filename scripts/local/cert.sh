#!/usr/bin/env bash

# CERTIFICATE REQUIRED FOR PRODUCTION ONLY
# Certificate will be valid for development domains EXCEPT for www. subdomain

# Obtain new domains to register
source scripts/environment.sh
TOP_DOMAIN=".rex.vision"

# OBTAIN EXISTING CERTIFICATE ARN FOR DELETION
echo "Obtaining existing certificate arn"
EXISTING_CERT=$(aws acm list-certificates \
  --query CertificateSummaryList[0].CertificateArn \
  --output text \
  | awk 'gsub(/\r/, ""){print $1}')
echo "Retrieved arn: $EXISTING_CERT"

echo "Determining existing subject alternative names"
EXISTING_SANS=$(aws acm describe-certificate \
  --certificate-arn $EXISTING_CERT \
  --query Certificate.SubjectAlternativeNames --output text)
  
echo "Retrieved SANS: $EXISTING_SANS"

# REQUEST NEW CERTIFICATE
NEW_CERT=$(aws acm request-certificate \
--domain-name *$TOP_DOMAIN \
--validation-method DNS \
--subject-alternative-names *$DOMAIN *.$HOST$DOMAIN) # $EXISTING_SANS \
# NEW SANS
# EXISTING SANS
# $EXISTING_SANS)

# PROMPT USER TO PROCEED ONCE DNS VALIDATION COMPLETE
# echo "Waiting for DNS validation to complete"
# while true; do
#   # STATUS=$(aws acm describe-certificate --certificate-arn $NEW_CERT \
#   STATUS=$(aws acm describe-certificate --certificate-arn $EXISTING_CERT) # \
#   # --query Certificate.Status)
#   echo $STATUS
#   # case $STATUS in
#     # ISSUED ) break;;
#   # esac
#   sleep 10
#   # --query Certificate.DomainValidationOptions[0].ValidationStatus
# done

# # DELETE EXISTING CERTIFICATE
# aws acm delete-certificate --certificate-arn $EXISTING_CERT