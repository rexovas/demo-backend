#!/usr/bin/env bash

# CERTIFICATE REQUIRED FOR PRODUCTION ONLY
# Certificate will be valid for development domains EXCEPT for www. subdomain

# SOURCE ENVIRONMENT VARIABLES
. scripts/environment.sh

# OBTAIN EXISTING CERTIFICATE ARN
echo "Obtaining existing certificate arn"
EXISTING_CERT=$(aws acm list-certificates \
  --query CertificateSummaryList[0].CertificateArn \
  --output text \
  | awk 'gsub(/\r/, ""){print $1}')
echo "Retrieved arn: $EXISTING_CERT"

# OBTAIN EXISTING SANS
echo "Determining existing subject alternative names"
EXISTING_SANS=$(aws acm describe-certificate \
  --certificate-arn $EXISTING_CERT \
  --query Certificate.SubjectAlternativeNames \
  --output text \
  | awk 'gsub(/\r/, "")gsub(/\t/, " "){print}')
  
echo "Retrieved SANS: $EXISTING_SANS"

# REQUEST NEW CERTIFICATE
echo "Requesting new certificate for domains *$DOMAIN *.$HOST$DOMAIN $EXISTING_SANS"
NEW_CERT=$(aws acm request-certificate \
  --domain-name *$TOP_DOMAIN \
  --validation-method DNS \
  --subject-alternative-names *$DOMAIN *.$HOST$DOMAIN $EXISTING_SANS \
  --query CertificateArn --output text \
  | awk 'gsub(/\r/, ""){print}')

echo "Obtained new certificate: $NEW_CERT"

# OBTAIN REQUIRED CNAMES FOR DNS VALIDATION
echo "Obtaining required resource records for DNS validation"
file="resources.json"
aws acm describe-certificate \
  --certificate-arn $NEW_CERT
  --query Certificate.DomainValidationOptions >> $file

# CONSTRUCT ROUTE53 CHANGE BATCH FILE
echo "Creating CNAME records for DNS validation"
i=0 
echo [ >> _$file
for row in $(jq -r '.[] | @base64' $file); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }

   DNS_NAME=$(_jq '.ResourceRecord.Name')
   DNS_TYPE=$(_jq '.ResourceRecord.Type')
   DNS_VALUE=$(_jq '.ResourceRecord.Value')
   DNS_DOMAIN=$(_jq '.DomainName')
   echo $DNS_DOMAIN: $DNS_NAME $DNS_TYPE $DNS_VALUE

   ((i+=1))

   jq -n \
   --arg Name $DNS_NAME \
   --arg Type $DNS_TYPE \
   --arg Value $DNS_VALUE \
   '{
     Action: "CREATE",
     ResourceRecordSet: {
       Name: $Name,
       Type: $Type,
       TTL: 300,
       ResourceRecords: [{ Value: $Value }]
     }
   }' \
   >> _$file
   echo , >> _$file
done
sed -i '$d' _$file 
echo ] >> _$file
   jq -n \
   --arg Type $DNS_TYPE \
   --arg Domains "$EXISTING_SANS *.$HOST$DOMAIN" \
   --argjson Actions $(jq -r '. | @base64' _$file | base64 --decode) \
   '{
     Comment: "Create \($Type) record(s) for \($Domains)",
     Changes: $Actions
   }' \
   > _$file 

# CREATE CNAME RECORDS FOR DNS VALIDATION
$(aws route53 change-resource-record-sets \
--hosted-zone-id $HOSTED_ZONE \
--change-batch file://_$file)

rm $file _$file

# MONITOR FOR DNS VALIDATION COMPLETION
echo "Waiting for DNS validation to complete.  This may take several minutes."
while true; do
  STATUS=$(aws acm describe-certificate \
  --certificate-arn $NEW_CERT \
  --query Certificate.Status)
  echo "Certificate Status: $STATUS"
  case $STATUS in
    ISSUED ) break;;
  esac
  sleep 10
done

# UPDATE ELB CERTIFICATE
echo "Replacing ELB SSL certificate"
aws elb set-load-balancer-listener-ssl-certificate \
--load-balancer-name $ELB \
--load-balancer-port 443 \
--ssl-certificate-id $NEW_CERT

echo "ELB configured with new certificate"

# DELETE EXISTING CERTIFICATE
echo "Deleting old certificate"
aws acm delete-certificate --certificate-arn $EXISTING_CERT

echo "Certificate deleted"
echo "Successfully created new SSL certificate for $EXISTING_SANS *.$HOST.$DOMAIN"
exit 0