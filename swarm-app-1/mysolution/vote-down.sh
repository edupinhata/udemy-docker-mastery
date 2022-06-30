#!/bin/bash

docker service rm vote
docker service rm redis
docker service rm worker
docker service rm db
docker service rm result
