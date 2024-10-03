#!/bin/bash

REGION="us-east-1"
SUBNET1_PUBLIC_AZ="us-east-1a"
SUBNET2_PUBLIC_AZ="us-east-1b"

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
echo "IGW $IGW_ID created successfully")

#Attach Internet Gateway to VPC
aws ec2 attach-internet-gateway \
    --internet-gateway-id $IGW_ID \
    --vpc-id $VPC_ID
echo "IGW $IGW_ID successfully attached to VPC $VPC_ID."

#Create Public Subnet 1
SUBNET1_PUBLIC=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.0.0/24 \
    --tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=public_subnet1_apiproject}] \
    --region $REGION \
    --output text \
    --query "Subnet.SubnetId")
echo "Subnet $SUBNET1_PUBLIC created successfully"

#Enable public subnet to auto-assign public IP
aws ec2 modify-subnet-attribute --subnet-id $SUBNET1_PUBLIC --map-public-ip-on-launch
Echo "Public IP auto-assign enabled successfully."

#Create public route table
RT_PUBLIC=$(aws ec2 create-route-table --vpc-id $VPC_ID --output text -- query "RouteTable.RouteTableId" \
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=public_rt_apiproject}]")
echo "Rout Table $RT_PUBLIC created successfully."

#Create route to Internet Gateway
aws ec2 create-route --route-table-id $RT_PUBLIC --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
echo "Route to the IGW $IGW_ID created successfully."

#Associate the public subnet 1 with the route table
aws ec2 associate-route-table --route-table-id $RT_PUBLIC --subnet-id $SUBNET1_PUBLIC
echo "Subnet $SUBNET_PUBLIC1 associated with route table $RT_PUBLIC"
