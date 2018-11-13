docker ps -qa | xargs docker rm -f
docker volume rm $(docker volume ls -qf dangling=true)
docker network rm $(docker network ls -q)
