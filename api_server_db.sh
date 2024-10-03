#!/bin/bash

REGION="us-east-1"
SUBNET1_PUBLIC-AZ="us-east-1a"
SUBNET2_PUBLIC-AZ="us-east-1b"

#Create VPC
VPC_ID=$(aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=vpc_apiproject}]" \
    --region $REGION \
    --output text \
    --query "Vpc.VpcId") 
echo "VPC $VPC_ID created successfully"

#Create Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway \
    --tag-specifications ResourceType=internet-gateway,Tags=[{Key=Name,Value=igw-apiproject}] \
    --output text \
    --query "InternetGateway.InternetGatewayId"
echo "IGW $IGW_ID created successfully"

#Attach Internet Gateway to VPC
aws ec2 attach-internet-gateway \
    --internet-gateway-id $IGW_ID \
    --vpc-id $VPC_ID
echo "IGW $IGW_ID successfully attached to VPC $VPC_ID."