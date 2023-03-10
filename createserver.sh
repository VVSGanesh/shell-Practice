#!/bin/bash

###### Change these values ###
#SG_NAME="allow-all"
#env=dev
##############################

#
#
#create_ec2() {
#  PRIVATE_IP=$(aws ec2 run-instances \
#      --image-id ${AMI_ID} \
#      --instance-type t3.micro \
#      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}, {Key=Monitor,Value=yes}]" "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${COMPONENT}}]"  \
#      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
#      --security-group-ids ${SGID} \
#      | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
#      current_path=${pwd}
#
#}
#
#
### Main Program
#
#AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-8-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
#if [ -z "${AMI_ID}" ]; then
#  echo "AMI_ID not found"
#  exit 1
#fi
#
#SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${SG_NAME} | jq  '.SecurityGroups[].GroupId' | sed -e 's/"//g')
#if [ -z "${SGID}" ]; then
#  echo "Given Security Group does not exit"
#  exit 1
#fi
#
#  echo "Please enter the component name"
#  read server
#
#  COMPONENT="${server}-${env}"
#  create_ec2
#
#Footer

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-8-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
SG_NAME="allow-all"
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${SG_NAME} | jq  '.SecurityGroups[].GroupId' | sed -e 's/"//g')

for i in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis dispatch ; do

  PRIVATE_IP=$(aws ec2 run-instances \
        --image-id ${AMI_ID} \
        --instance-type t3.micro \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${i}}, {Key=Monitor,Value=yes}]" "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=${i}}]"  \
        --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
        --security-group-ids ${SGID} \
        | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')


  aws ssm put-parameter --name ${i} --value ${PRIVATE_IP} --type "SecureString" --region "us-east-1" --overwrite

done
