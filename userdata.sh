#!/bin/bash

#Import the MongoDB GPG public key
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

# Create a MongoDB repository file
echo "deb [arch=amd64] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

#Update the package list
sudo apt update

#Install Node.js and npm
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs

