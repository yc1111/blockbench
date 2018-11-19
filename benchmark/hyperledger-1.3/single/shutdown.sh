docker ps -qa | xargs docker rm -f
docker volume rm $(docker volume ls -qf dangling=true)
docker network rm $(docker network ls -q)

DOCKER_IMAGE_IDS=$(docker images | awk '($1 ~ /dev-peer/) {print $3}')
if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
  echo "---- No images available for deletion ----"
else
  docker rmi -f $DOCKER_IMAGE_IDS
fi

