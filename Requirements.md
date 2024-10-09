Requirements
Create a database to store some simple data using any data of your choice and using any database server of your choice.
For example you can use the attached NHL data that has data on NHL hockey players, their goals, assists and points.
Some examples of databases you can use to store the data include MySQL, PostgreSQL, MongoDB, etc.
Create an API server in any programming language and framework of your choice. Some examples:
FastAPI
Node + Express
Java Springboot
Create a few GET endpoints in your API server so users can retrieve data from your database via your API microservice. Some examples of endpoints
/players: Returns the first 10 players from the data, e.g. via query SELECT Player Name FROM nhl LIMIT 10
/toronto: Returns all players from the Toronto Maple Leafs, e.g. via query SELECT Player Name FROM nhl WHERE Team = ‘TOR’ information about the Linux OS
/points: Returns top 10 players leading in points scored, e.g. via query SELECT Player Name,Pts FROM nhl ORDER BY Pts LIMIT 10
Deploy your database server and API microservice on the AWS cloud. Since you've already created AWS infrastructure using bash shell scripts from project 1, you can re-use those scripts and modify accordingly to deploy the API and databases if it's convenient to do so.
Ensure your API is accessible on the public internet.
Create a public GitHub repo to store all your code used in this project.
In the README.md of your GitHub repo
Include an architectural diagram of your API and database set up.
Include instructions on how users can use your API service, including available endpoints.
Bonus:
If you want to make your API microservice fancy you can create a frontend e.g. Angular, React, Bootstrap, etc. to allow users to interact with your API endpoints. However this is not necessary. Users can hit your endpoints via entering the endpoints as URL’s in the web browser, using Postman, or other API clients, etc.
To add high availability and scalability to your API service you can deploy your API in EC2 instances that are part of an autoscaling group, and add an application load balancer in front. Your users will then hit your API via the application load balancer address.
Note: Sample data file you can use for your database can be found in the tab "Exercise Files". The file is called "nhl-stats-2022.csv".