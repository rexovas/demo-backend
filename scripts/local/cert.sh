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
echo -e "Retrieved arn: $EXISTING_CERT\n"

# OBTAIN EXISTING SANS
echo "Determining existing subject alternative names"
EXISTING_SANS=$(aws acm describe-certificate \
  --certificate-arn $EXISTING_CERT \
  --query Certificate.SubjectAlternativeNames \
  --output text \
  | awk 'gsub(/\r/, "")gsub(/\t/, " "){print}')
  
echo -e "Retrieved SANS: $EXISTING_SANS\n"

# REQUEST NEW CERTIFICATE
echo "Requesting new certificate for domains *$DOMAIN *.$HOST$DOMAIN $EXISTING_SANS"
NEW_CERT=$(aws acm request-certificate \
  --domain-name *$TOP_DOMAIN \
  --validation-method DNS \
  --subject-alternative-names *$DOMAIN *.$HOST$DOMAIN $EXISTING_SANS \
  --query CertificateArn --output text \
  | awk 'gsub(/\r/, ""){print}')

echo -e "Obtained new certificate: $NEW_CERT\n"
# SLEEP REQUIRED TO ENSURE CNAME RECORDS ARE PRESENT DURING 'describe-certificate'
echo "Waiting for resource records for DNS validation to be generated"
sleep 3 # THIS NUMBER MAY NEED TO BE INREASED

# OBTAIN REQUIRED CNAMES FOR DNS VALIDATION
echo -e "Obtaining required resource records for DNS validation\n"
file="resources.json"
aws acm describe-certificate \
  --certificate-arn $NEW_CERT \
  --query Certificate.DomainValidationOptions >> $file

jq -r '.' $file

# CONSTRUCT ROUTE53 CHANGE BATCH FILE
echo -e "\nCreating CNAME records for DNS validation"
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
   echo $DNS_DOMAIN: Name: $DNS_NAME Type: $DNS_TYPE Value: $DNS_VALUE

   ((i+=1))

   jq -n \
   --arg Name $DNS_NAME \
   --arg Type $DNS_TYPE \
   --arg Value $DNS_VALUE \
   '{
     Action: "UPSERT",
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

echo -e "\n"
# CREATE CNAME RECORDS FOR DNS VALIDATION
aws route53 change-resource-record-sets \
--hosted-zone-id $HOSTED_ZONE \
--change-batch file://_$file \
| jq -r '.'

# rm $file _$file

# MONITOR FOR DNS VALIDATION COMPLETION
echo -e "\nWaiting for DNS validation to complete.  This may take several minutes."
seconds=0
while true; do
  STATUS=$(aws acm describe-certificate \
  --certificate-arn $NEW_CERT \
  --query Certificate.Status \
  --output text \
  | awk 'gsub(/\r/, ""){print $1}')
  echo -e "STATUS: $STATUS\tTIME ELAPSED: $seconds seconds"
  case $STATUS in
    ISSUED ) break;;
  esac
  sleep 10
  ((seconds+=30))
done

# UPDATE ELB CERTIFICATE
echo -e "\nReplacing ELB SSL certificate"
aws elb set-load-balancer-listener-ssl-certificate \
--load-balancer-name $ELB \
--load-balancer-port 443 \
--ssl-certificate-id $NEW_CERT

echo -e "ELB configured with new certificate\n"

# DELETE EXISTING CERTIFICATE
echo "Deleting old certificate"
aws acm delete-certificate --certificate-arn $EXISTING_CERT

echo -e "Certificate deleted\n"
echo "Successfully created new SSL certificate for $EXISTING_SANS *.$HOST$DOMAIN"
exit 0