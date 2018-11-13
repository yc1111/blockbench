#!/bin/bash

cd `dirname ${BASH_SOURCE-$0}`
. env.sh

# Shut down the Docker containers that might be currently running.

for peer in `cat $HOSTS`; do
  ssh $peer "docker ps -qa | xargs docker rm -f"
  ssh $peer "docker volume ls -qf dangling=true | xargs docker volume rm"
  ssh $peer "docker network ls -q | xargs docker network rm"
done
