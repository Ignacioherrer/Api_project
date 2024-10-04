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
    --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=igw-apiproject}]" \
    --output text \
    --query "InternetGateway.InternetGatewayId")
echo "IGW $IGW_ID created successfully"

#Attach Internet Gateway to VPC
aws ec2 attach-internet-gateway \
    --internet-gateway-id $IGW_ID \
    --vpc-id $VPC_ID
echo "IGW $IGW_ID successfully attached to VPC $VPC_ID."

#Create Public Subnet 1
SUBNET1_PUBLIC=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.0.0/24 \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=public_subnet1_apiproject}]" \
    --region $REGION \
    --output text \
    --query "Subnet.SubnetId")
echo "Subnet $SUBNET1_PUBLIC created successfully"

#Enable public subnet to auto-assign public IP
aws ec2 modify-subnet-attribute --subnet-id $SUBNET1_PUBLIC --map-public-ip-on-launch
echo "Public IP auto-assign enabled successfully."

#Create public route table
RT_PUBLIC=$(aws ec2 create-route-table --vpc-id $VPC_ID --output text --query "RouteTable.RouteTableId" \
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=public_rt_apiproject}]")
echo "Route Table $RT_PUBLIC created successfully."

#Create route to Internet Gateway
aws ec2 create-route --route-table-id $RT_PUBLIC --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
echo "Route to the IGW $IGW_ID created successfully."

#Associate the public subnet 1 with the route table
aws ec2 associate-route-table --route-table-id $RT_PUBLIC --subnet-id $SUBNET1_PUBLIC
echo "Subnet $SUBNET1_PUBLIC associated with route table $RT_PUBLIC"

#Create Public Subnet 2
SUBNET2_PUBLIC=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.9.0/24 \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=public_subnet2_apiproject}]" \
    --region $REGION \
    --output text \
    --query "Subnet.SubnetId")
echo "Subnet $SUBNET2_PUBLIC created successfully"

#Enable public subnet to auto-assign public IP
aws ec2 modify-subnet-attribute --subnet-id $SUBNET2_PUBLIC --map-public-ip-on-launch
echo "Public IP auto-assign enabled successfully."

#Associate the public subnet 1 with the route table
aws ec2 associate-route-table --route-table-id $RT_PUBLIC --subnet-id $SUBNET2_PUBLIC
echo "Subnet $SUBNET2_PUBLIC associated with route table $RT_PUBLIC"

#Create private subnet
SUBNET_PRIVATE=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.10.0/24 \
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=private_subnet_apiproject}]" \
    --availability-zone $SUBNET1_PUBLIC_AZ \
    --region $REGION \
    --output text \
    --query "Subnet.SubnetId")
echo "Subnet $SUBNET_PRIVATE created successfully"

#Create private route table
RT_PRIVATE=$(aws ec2 create-route-table --vpc-id $VPC_ID --output text --query "RouteTable.RouteTableId" \
    --tag-specifications "ResourceType=route-table,Tags=[{Key=string,Value=private_rt_apiproject}]")

#Associate the private subnet with the private route table
aws ec2 associate-route-table --route-table-id $RT_PRIVATE --subnet-id $SUBNET_PRIVATE
echo "Subnet $SUBNET_PRIVATE associated with route table $RT_PRIVATE"

#Create ALB Security group
SG_ALB_ID=$(aws ec2 create-security-group \
    --group-name apiproject_alb_sg \
    --description "Application Load Balancer sg" \
    --tag-specifications "ResourceType=security-group,Tags=[{Key=string,Value=alb_sg_apiproject}]" \
    --vpc-id $VPC_ID \
    --output text \
    --query "GroupId")
echo "Security group $SG_ALB_ID created successfully."

#Enable the ALB security group to allow HTTP, HTTPS access from anywhere
aws ec2 authorize-security-group-ingress --group-id $SG_ALB_ID --protocol tcp --port 80 --cidr 0.0.0.0/0  
aws ec2 authorize-security-group-ingress --group-id $SG_ALB_ID --protocol tcp --port 443 --cidr 0.0.0.0/0
echo "Security group $SG_ALB_ID authorized for HTTP and HTTPS ingress."
