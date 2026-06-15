#!/bin/bash
AMI_ID=ami-0220d79f3f480ecf5
SG_ID=sgr-0202e527062c48de9
Instances=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
Zone_ID=Z07085248BXF6N8LMPZW
Domain_name=daws23.space

for instance in ${instances[@]}
do
 InstanceID = $(aws ec2 run-instances 
    --image-id "$AMI_ID" 
    --instance-type "t3.micro"
   --securitygroupids "$SG_ID" --tag-specifications
   "Resourcetype=instance,Tags=[{key=name, value=$instance}]"
    --query 'Instances[0].InstanceId' 
    --output text)
if [ $instance != frontend]
then 
echo "IP=$(aws ec2 describe-instance 
  --query 'Reservations[0].Instances[0].[$InstanceId, PrivateIpAddress]' 
  --output text)"
  else
  echo "IP=$(aws ec2 describe-instance 
  --query 'Reservations[0].Instances[0].[$InstanceId, PublicIpAddress]' 
  --output text)"
  fi
  echo "$instance IP Address = $IP"
  done 