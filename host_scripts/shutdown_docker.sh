#!/bin/bash

# STOP ALL DOCKER CONTAINERS
docker stop $(docker ps -q)