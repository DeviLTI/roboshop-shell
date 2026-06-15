#!/bin/bash

AMI_ID=ami-0220d79f3f480ecf5
SG_ID=sg-0f5d722990e27d6eb
Instances=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
Zone_ID=Z07085248BXF6N8LMPZW
DOMAIN_NAME=daws23.space


for instance in ${Instances[@]}
do
    INSTANCE_ID=INSTANCE_ID=$(aws ec2 run-instances \
      --image-id $AMI_ID \
      --instance-type t3.micro \
      --security-group-ids $SG_ID \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
      --query "Instances[0].InstanceId" \
      --output text)

    if [ $instance != "frontend" ]
    then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
        RECORD_NAME="$instance.$DOMAIN_NAME"
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
        RECORD_NAME="$DOMAIN_NAME"
    fi
echo "$instance IP address: $IP"

done