#!/bin/bash

cd `dirname ${BASH_SOURCE-$0}`
. env.sh

if [ -z $3 ]; then
  exit
fi

./generate.sh $1

sleep 10

./start.sh

sleep 10

./start-clients.sh $2 $3

sleep 120

killall -KILL driver

./shutdown.sh
