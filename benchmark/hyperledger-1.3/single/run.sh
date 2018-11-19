#!/bin/bash

cd `dirname ${BASH_SOURCE-$0}`
. env.sh

./generate.sh

sleep 10

./start.sh

