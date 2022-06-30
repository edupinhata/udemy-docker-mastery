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

