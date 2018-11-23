#!/bin/bash
#nodes
cd `dirname ${BASH_SOURCE-$0}`
. env.sh

rm -rf addPeer.txt
./gather.sh $1
sleep 3
i=0
for host in `cat $HOSTS`; do
  if [[ $i -lt $1 ]]; then
    ssh -oStrictHostKeyChecking=no yuecong@$host $ETH_HOME/start-mining.sh
    echo done start-mining.sh for host: $host
  fi
  let i=$i+1
done
