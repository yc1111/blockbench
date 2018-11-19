#!/bin/bash
cd `dirname ${BASH_SOURCE-$0}`
. env.sh

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1
export PEER=10.0.0.10

cd $GOROOT/src/github.com/hyperledger1.3/multi

docker-compose -f docker-compose-peer.yml down
docker-compose -f docker-compose-peer.yml -p multi up -d peer1.org1.example.com couchdb1

export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/users/msp/Admin@org1.example.com/msp" peer1.org1.example.com peer channel fetch config -o orderer.example.com:7050 -c mychannel

docker exec -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/users/msp/Admin@org1.example.com/msp" peer1.org1.example.com peer channel join -b mychannel.block
