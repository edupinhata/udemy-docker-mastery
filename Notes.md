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


## 91. DOcker in production

Bret Fisher lecture in Docker con17 EU.

1. Don't spend too much time in the beggining of the project with
- Fully automatic CI/CD
- Dynamic performance scaling
- Containerizing all or nothing

### Important to focus in the beggining
- Make it start
- Make it log all things to stdout/stderr -> don't put the logs in that container. Let docker and
  orchestration to handle your logs
- Make it documented in file
- Make it work for others
- Make it lean - don't worry much in the begging about the size of the image. There are more
  importante things to focus: well documented docker file, etc.
- Make it scale


### Dockerfile Anti-pattern: 
- trapping Data
    - Problem: Storing unique data in container
    - Solution: Define VOLUME for each location

- Using Latest
    - Problem: Image builds pull FROM latest
    - SOlution: Use specific FROM tags

- Leaving Defalut Config
    - Problem: Not changing app default, or blindly copying VM conf
    - Solution: Update default configs via ENV, RUN and ENTRYPOINT

    E.g.:
    ```
    ENV MYSQL_ALLOW_EMPTY_PASSWORD=true \
        MYSQL_DATABASE=sysbench \
        MYSQL_CONFIG=/etc/mysql/mysql.conf.d/mysqld.cnf \
        MYSQL_BUFFERSIZE=18G \
        MYSQL_LOGSIZE=512M \
        MYSQL_LOG_BUFFERSIZE=64M \
        MYSQL_FLUSHLOG=1 \
        MYSQL_FLUSHMETHOD=O_DIRECT

    RUN echo "innodb_buffer_pool_size = ${MYSQL_BUFFERSIZE}" >> ${MYSQL_CONFIG} && \
        echo "innodb_log_file_size = ${MYSQL_LOGSIZE}" >> ${MYSQL_CONFIG} && \
        echo "innodb_log_buffer_size = ${MYSQL_LOG_BUFFERSIZE}" >> ${MYSQL_CONFIG} && \
        echo "innodb_flush_log_at_trx_commit = ${MYSQL_FLUSHLOG}" > ${MYSQL_CONFIG} && \
        echo "innodb_flush_method = $MYSQL_FLUSHMETHOD}" >> ${MYSQL_CONFIG}
    ```

    > OBS: the code above was copied from a picture and not tested, so might contain misstype.

- Environment Specifig
    - Problem: Copy in environment config at image build
    - Solution: Single Dockerfile with default ENV's, and overwrite per-environment with ENTRYPOINT
      script

 ### Containers-on-VM or Container-on-Bare-Metal?
 - Do either, or both. Lots of pros/cons to either
 - Stick with wat you know at first
 - Do some basic performance testing. You will learn lots!
 - [Paper of docker benchmark](bretfisher.com/dockercon17eu)

 ### OS Linux Distribution/Kernel Matters
 - Docker is very kernel and storage driver dependent
 - Innovations/fixes are still happening here
 - "Minimum" version != "best" version
 - No pre-existing opinion? Ubuntu 16.04 LTS
    - Popular, well-tested with Docker
    - 4.x Kernel and wide storage driver support
- Or InfraKit and LinuxKit (may delay the project, not the fastest choice)
- Get correct Docker for your distro from store.docker.com

### Container Base Distribution: Which One?
- Which FROM image should you use?
- Don't make a decision based on image size (remember it's Single Instance Storage)
- At first: match yout existing deployment process
- Consider changing to Alpine later, maybe much later


### Good Defaults: Swarm Architectures
- Simple sizing guidelines based off:
    - Docker internal testing
    - Docker reference architectures
    - Real world deployments
    -Swarm3k lessons learned

#### Baby Swarm: 1-Node
- "docker swarm init! done!
- Solo VM's do it, so can Swarm
- Gives you more features then docker run

#### HA Swarm: 3-Node
- Minimum for HAS
- All Managers
- One node can fail
- One when very small budget
- Pet projects or Test-CI

#### Biz Swarm: 5-Node
- Better high-availability
- All Managers
- Two nodes can fail
- My minimum for uptime that affects $$$

#### Flexy Swarm: 10+ Nodes
- 5 dedicated Managers
- Workers in DMZ
- Anything beyound 5 nodes, stick with 5 managers and rest Workers
- Control container placement with labels + constraints

#### Swole Swarm: 100+ Nodes
Similar to Flexy Swarm, but more workers. And probably need to scale the managers.

#### Don't Turn Cattle into Pets
- Assume nodes will be replaced
- Assume containers will be recreated
- Docker for (AWS/Azure) does this
- LinuxKit and InfraKit expect it

#### Reasons for Multiple Swarms
- Bad Reasons
    - Different hardware config (or OS)
    - Different subnets or security groups
    - Different availability zones
    - Security boundaries for compliance
- Good Reasons
    - Learning: Run Stuff on Test Swarm
    - Geographical boundaries
    - Management boundaries using Docker API (or Docker EE RBAC, or other auth plugin)

### Outsource Well-Defined Plumbing
- Beware the "not implemented here" syndrome
- If challenge to implement and maintain
- + SaaS/commercial market is mature
- = Opportunities for outsourcing

- For Your consideration
    - Image registry
    - Logs
    - Monitoring and alerting
    - Tools/Projects: https://github.com/cncf/landscape


### Pure Open Source Self-Hosted Tech Stacks

Swarm GUI           |   Portainer
--- | ---
Central Monitoring  | Prometheus + Grafana
Central Logging     | ELK
Layer 7 Proxy       | Flow-Proxy Traefik
Registry            | Docker hub
CI/CD               | Jenkins
Storage             | REX-Ray
Networking          | Docker Swarm
Orchestration       | Docker Swarm
Runtime             | Docker
HW / OS             | Infrakit / Terraform


### Docker for X: Cheap and Easy Tech Stacks

Swarm GUI           |   Portainer
--- | ---
Central Monitoring  | Librato / Sysdig
Central Logging     |DOcker for AWS/Azure 
Layer 7 Proxy       | Flow-Proxy Traefik
Registry            | Docker Hub / Quay
CI/CD               | Codeship / TravisCI 
Storage             | Docker for AWS/Azure
Networking          | Docker Swarm
Orchestration       | Docker Swarm
Runtime             | Docker
HW / OS             | Docker for AWS/Azure


### Must We Have and Orchestrator?
- Let's accelerate your docker migration even more
- Already have good infrastructure automation?
- Maybe you have great VM autoscale?
- Like the security boundary of the VM OS?
 
*ONE CONTAINER PER VM*
 - Why don't we talk about this more?
 - Least amount of infrastructure change but also:
    - Run on Dockerfiles recipes rather then Puppet etc
    - Improve your Docker management skills
    - Simplify your VM OS build
    - Hyper-V Containers (Windows), Intel Clear Containers (Linux), Immutable OS (LinuxKit)

### Summary
- Trim the optional requirements at first
- First, focus on Dockerfile/docker-compose.yml
- Watch out for Dockerfile anti-patterns
- Stick with familiar OS and FROM images
- Grow Swarm as you grow
- Find ways to outsource plumbing
- Realize parts of your tech stack may change, stay flexible

## 95, 96, 97. Kubernetes

- Kubernetes = popular container orchestrator
- Container Orchestration = Make many servers act like one
- Runs on top of Docker (usually) as a set of APIs in containers
- Provides API/CLI to manage containers across servers
- Many clouds provide it for you

- Why Kubernetes
    - Not every solution needs orchestration
    - Servers + Change Rate = Benefit of orchestration
    - Decide which orchestration
    - If Kubernetes, decide which distribution
        - cloud or self-managed (Docker Enterprise, Rancher, OpenShift, Canonical, VMWare PKS)

- Kubernetes or Swarm?
    - Both solve same problems
    - Both are solid platforms
    - Swarm: easier to deploy/manage
    - Kubernetes: More features and flexibility
    - What's right for you? Understand both and know your requirements

    - *Advantages of Swarm*
        - Comes with docker, single vendor container platform
        - Easiest orchestrator to deplaoy/manage yourself
        - Follow 80/20 rule, 20% of features for 80% of use cases
        - Runs anywhere Docker does
            - local, cloud, datacenter
            - ARM, WIndows, 32-bit
        - Secure by default
        - Easier to troubleshoot
        - When you used most of features and you starting feeling that you can not get more of the
          Swarm, then you might want to move to Kubernetes

    - *Advantages of Kubernetes*
        - Clouds will deploy/manage Kubernetes for you
        - Infrastructure vendors are making their own distribution
        - Widest adoption and community
        - Flexible: Covers widest set of use cases
        - "Kubernetes first" vendor support
        - "No one ever got fired for buying IBM"
            - Picking solutions isn't 100% rational
            - Trendy, will benefit your career
            - CIO/CTO Checkbox


## 99. Basic Terms of kubernetes

- *Kubernetes:* The whole orchestration system
    - K8s "k-wights" or Kube for short
- *Kubectl:* CLI to configure Kubernetes and manage apps
    - Using "cube control" official pronunciation
- *Node:* Single server in the Kubernetes cluster
- *Kubelet:* Kubernetes agent running on nodes
- *Control Plane*: Set of containers that manage the cluster
    - Includes API sever, shceduler, controller manager, etcd, and more
    - Sometimes called the "master"
    - Master: etcd, API, scheduler, Control Manager, CoreDNS
    - Node: Kubelet, kube-proxy

 - *Pod*: one or more containers running together on one Node
    - Basic unit of deployment. Containers are always in pods
- *Controller*: For creating/updating pods and other objects
    - Many types of Controllers inc. Deployment, ReplicaSet, StatefulSet, DaemonSet, Job, CronJob,
      etc
- *Service*: network endpoint to connect to a pod
- *Namespace*: filtered group of objects in cluster

## 105. Cheat sheet for kubernetes commands

```kubectl run nginx --image nginx```: creates a Pod named *nginx* in 1.18+
 
```kubectl create deployment nginx --image nginx```: create a deployment, which crates a ReplicaSet,
which creates a Pod

```
kubectl create deployment my-apache --image httpd
kubectl scale deploy/my-apache --replicas 2
kubectl scale deployment my-apache --replicas 2 //same as previous
```

```
kubectl get pods
kubectl logs deployment/my-apache --follow --tail 1
kubectl describe pod/my-apache-xxxx-yyyy
kubectl get pods -w   //watch pods status
kubectl delete pod/my-apache-xxxx-yyy
```

## 109. Exposing Containers

```
kubectl.exe expose deploy/httpenv --port 8888
kubectl expose deployment/httpenv --port 8888 --name httpenv-np --type NodePort
```

**LoadBalancer**

```
kubectl expose deployment/httpenv --port 8888 --name httpenv-lb --type LoadBalancer
```

## 112. Namespaces

```
kubectl get namespaces
```

## 117. Thre Management Approaches

- **Imperative commands**: run, expose, scale, edit, create deployment
    - best for dev/learning/personal projects
    - easy to learn, hardert to manage over time
- **Imperative objects**: create -f file.yml, replace -f file.yml, delete...
    - Good for prod of small environments, single file per command
    - Store your changes in git-based yaml files
    - Hard to automate
- **Declarative objects**: apply -f file.tml, or dir\, diff
    - Best for prod, easier to automate
    - Harder to understand and predict changes

- **Most importante Rule**: Don't mix the three approaches
- **Bret's recommendations**:
    - Learn the Imperative CLI for easy control of local and test setups
    - Move to apply -f file.yml and apply -f directory\ for prod
    - Store yaml in git, git commit each change before you apply
    - This trains you for later doing GitOps (where git commits are automatically applied to
      clusters)

## 121. Building your YAML file

```kubectl api-resources```: get a list of resources that kubectl offers. When
building the YAML file, use the KIND column to figure out which kind you should use in the YAML
file.

API Group is Where in the API the resource can be access, created, deleted.

```kubectl api-versions```: get a short lis of diferent API versions we should worry
about.

```kubectl explain services --recursive```: all the keys each kind supports.
```kubectl explain services.spec```

## 134. Docker Security

[Bret Fisher security recommendations for Docker on Linux servers](https://github.com/BretFisher/ama/issues/17). This is a checklist that would be good to be followed if 

[Docker bench security](https://github.com/docker/docker-bench-security): tool to check if the
Docker configuration is right.


- Scanning tools:
    - [snyk](https://snyk.io): scan repo to find vunerabilities
    - [microscanner](https://github.com/aquasecurity/microscanner): scan inside a container build.
      This was deprecated in favor of trivy.
    - [Trivy](https://github.com/aquasecurity/trivy): scan inside a container build.
    - [Falco](https://sysdig.com/opensource/falco): open source container native runtime security.


Remember to use --continue-on-failure, so build are not interrupted when any vulnerability is find.

