#!/bin/bash
#nnodes
cd `dirname ${BASH_SOURCE-$0}`
. env.sh 

i=0
for host in `cat $HOSTS`; do
  if [[ $i -lt $1 ]]; then
     s="admin.addPeer("`ssh yuecong@$host $ETH_HOME/enode.sh $host 2>/dev/null | grep enode`")"
     echo $s
     echo $s >> addPeer.txt
  fi
  let i=$i+1
  echo $i
done
