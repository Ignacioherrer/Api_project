Project - API Server and Database
The project deploys a Nodejs API microservice connected to a MongoDB database using Bash Script. This API will have exposed endpoints that users can send HTTP requests to and get a response as JSON payloads.

This project is composed of a main script (api_server_db.sh) and auxiliary scripts. The main script is responsible for deploying the AWS cloud infrastructure using AWS CLI. Specifically, the AWS architecture will have a VPC, internet gateway, two public subnets, public route table, public EC2 instances, auto-scaling group, application load balancer, security groups, NAT Gateway, one private subnet, private route table, and private EC2 instance.