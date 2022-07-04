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

## 81. SWARM life cycle

Here he explains how the CI/CD life cycle works. How to use the yml config file to setup an test, staging and product environemnt. Check this class if setting up staging/production environment.

It's possible to override the docker-compose.yml file using docker-compose.override.yml. What it'll do it to read the docker-compose.yml file first and then read the docker-compose.override.yml, overriding what was set by the first and adding the other information.

Make ```docker-compose -f a.yml -f b.yml config``` to generate a yml config file containing both information from a.yml and b.yml.

## 82. Service update

Common commands:
```
// update image used to a new version
docker service update --image myapp:1.2.1 <service name>

// Add an environment variable and remove a port
docker service update --env-add NODE_ENV=production --publish-rm 8080

//Changing  number of replicas of two services
docker service scale web=8 api=6
```

In SWARM updates, there is no different command, only update the yml file and deploy again
```
docker stack deploy -c file.yml <stackname>
```

## 87. Creating a registry

- Run the registry image: 
  - ```docker container run -d -p 5000:5000 --name registry registry```
- Re-tag an existing image and push it to your new registry
  - ```docker tag hello-world 127.0.0.1:5000/hello-world```
  - ```docker push  127.0.0.1:5000/hello-world```
- Remove that image from your local cache and pull it from your new registry
  - ```docker image remove hello-world```
  - ```docker image remove 127.0.0.1:5000/hello-world```
  - ```docker pull 127.0.0.1:5000/hello-world```
- Recreating registry using a bind mount and see how it stores data
  - ```docker container run -d -p 5000:5000 --name registry -v $(pdw)/registry-data:/var/lib/registry registry```

## 88. Setup a secure registry server

Use the following [steps](https://training.play-with-docker.com/linux-registry-part2/) to create a HTTPS environment with working Registry. 
