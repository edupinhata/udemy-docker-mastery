# Docker Mastery in Udemy

This repository contains the the activities results of the course Docker Mastery.

## 60. Write a compose file

Write a basic compose file for a Drupal content management system website.
Drupal is a content management tools. Easy to make a website.

## 63. Compose for image build

Similar to assignment 60, but I`ll make a Dockerfile to create the image.

## 70. Create a overlay network

When docker nodes need to communicate in a swarm, we can use overlay network so they may communicate.
To do this, create a swarm with multiples nodes in it:

Useful commands:

```
docker swarm init
docker swarm join-token (worker|manager)
docker network create --drive overlay my-network-name
docker service create --network my-network-name --replicas 3 alpine ping 8.8.8.8
docker service create --network my-network-name -p 8080:80 -d drupal
docker service create --network my-network-name -d postgres
```

This set of commands should be enough to make a drupal service to be running kinda reliable (the database will vanish if it runs in other node).

## 72. Create a real life application using SWARM

In this assignment I make a swarm application using 4 AWS isntances, set up as swarm nodes. The application is a voting app which is composed by a Python front-end that communicates with Redis, which communicate with a worker. This worker will make connection between redis and postgres (which are in different network for security). At the end, a backend in node will communicate with postgres and show the results of the voting. 

The docker commands to setup this swarm environemnt is in swarm-app-1/mysolution

![docker-course-class72-assignent-front](https://user-images.githubusercontent.com/6368537/176723397-a345c834-e696-4fb3-866f-6d2f81098aaa.PNG)
![docker-course-class72-assignent-result](https://user-images.githubusercontent.com/6368537/176723404-985e7e31-69d2-410a-8562-a70d2a4c8bca.PNG)
![docker-course-class72-assignent-services](https://user-images.githubusercontent.com/6368537/176723408-28f2c916-2ec7-43d3-bb26-913a6c023364.PNG)
