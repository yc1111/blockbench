#!/bin/bash
# installing hyperledger-fabric with docker 

cd `dirname ${BASH_SOURCE-$0}`
. env.sh

i=0
for peer in `cat $HOSTS`; do
  if [[ $i -eq 0 ]]; then
    echo $peer
    ssh $peer ". $HL_HOME/generate.sh && . $HL_HOME/start.sh"
  else
    echo $peer
    ssh $peer ". $HL_HOME/generate.sh && . $HL_HOME/start-peer.sh"
  fi
  let i=$i+1
done
