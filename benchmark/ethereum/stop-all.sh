#!/bin/bash
#arg nnodes
cd `dirname ${BASH_SOURCE-$0}`
. env.sh

i=0
for host in `cat $CLIENTS`; do
    ssh -oStrictHostKeyChecking=no yuecong@$host  killall -KILL driver 
    echo done kill driver for client: $host
done

for host in `cat $HOSTS`; do
  if [[ $i -lt $1 ]]; then
    ssh -oStrictHostKeyChecking=no yuecong@$host $ETH_HOME/stop.sh
    echo done stop.sh for host: $host
  fi
  let i=$i+1
done


