# STOP ALL RUNNING CONTAINERS
docker stop $(docker ps -aq)

# REMOVE ALL CONTAINERS
docker rm -f $(docker ps -aq)

# REMOVE ALL UNUSED IMAGES
docker image prune -a -f

# REMOVE ALL UNUSED VOLUMES
docker volume prune -f

# REMOVE ALL UNUSED NETWORKS
docker network prune -f

# REMOVE ALL UNUSED BUILD CACHE
docker builder prune -f

# REMOVE ALL DOCKER SYSTEM DATA
docker system prune -a -f --volumes