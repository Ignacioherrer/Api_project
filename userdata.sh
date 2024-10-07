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

#Install MongoDB
sudo apt install -y mongodb-org

#Download the csv file from the Github repo
curl -o nhl-stats-2022.csv https://github.com/Ignacioherrer/Api_project/blob/main/nhl-stats-2022.csv

#Set the IP of the MongoDB host
sudo sed -i 's/127.0.0.1/10.0.10.10,127.0.0.1/g' /etc/mongod.conf

#Start the MongoDB service
sudo service mongod start

#Service the MongoDB connection details
MONGO_HOST="10.0.10.10"
MONGO_PORT="27017"
MONGO_DB="API_PROJECT"
COLLECTION_NAME="nhl_stats_2022"
CSV_FILE="nhl-stats-2022.csv"

#Use mongoimport to import the CSVfile into the specified MongoDB collection
sudo mongoimport --host $MONGO_HOST --port $MONGO_PORT --db $MongoDB --collection $COLLECTION_NAME --type csv --headerline --file $CSV_FILE
