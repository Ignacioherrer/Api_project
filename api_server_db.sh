#!/bin/bash

REGION="us-east-1a"
SUBNET1_PUBLIC-AZ="us-east-1a"
SUBNET2_PUBLIC-AZ="us-east-1b"

#Create VPC
aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=vpc_apiproject}]" \
    --region $REGION \
    --output text 

#Create Internet Gateway
