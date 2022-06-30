#!/bin/bash

# Creating the services to setup a voting app which will have a python front-end communicating to redis. A .net worker will make the interaction between redis and a postgres db, which will be accessed by a node backend

# Create vote app python front
docker service create -d --network frontend -p 80:80 --replicas 2 --name vote bretfisher/examplevotingapp_vote

#create redis
docker service create -d --network frontend --replicas 1 --name redis redis 

#create worker .net
docker service create -d --network frontend --network backend --replicas 1 --name worker bretfisher/examplevotingapp_worker

#create db
docker service create -d --network backend --replicas 1 --name db -e POSTGRES_HOST_AUTH_METHOD=trust --mount type=volume,src=db-data,target=/var/lib/postgresql/data postgres:9.4

#create result node backend
docker service create -d --network backend --replicas 1 --name result -p 5001:80 bretfisher/examplevotingapp_result
