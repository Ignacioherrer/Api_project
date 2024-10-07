#!/bin/bash

#Update packages
sudo apt update

#Download the app.js and package.json from the Github repo
curl -o app.js https://raw.githubusercontent.com/Ignacioherrer/Api_project/refs/heads/main/app.js
curl -o package.json https://raw.githubusercontent.com/Ignacioherrer/Api_project/refs/heads/main/package.json

#Install dependencies
sudo apt install -y dirmngr apt-transport-https lsb-release ca-certificates

#Add the NodeSource repository's signing key
curl sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource.gpg

#Setup NodeSource repository for Node16
decho "deb [signe-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/nodesource.list

#Update packages again
sudo apt update

#Install nodejs
sudo apt install -y nodejs

#Install npm v9
sudo npm install -y -g npm@9.7.1

#Install npm
npm install 

#Set the application variables
export DB_HOST="10.0.10.10"
export DB_PORT="27017"
export DB_NAME="API_PROJECT"

#Start the application
npm start