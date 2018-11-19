#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error, print all commands.
cd `dirname ${BASH_SOURCE-$0}`
. env.sh

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1
export INDEX=1
export PEER=10.0.0.9

cd $GOROOT/src/github.com/hyperledger1.3/multi/

docker-compose -f docker-compose.yml down

CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose.yml -p multi up -d ca.example.com orderer.example.com peer0.org1.example.com couchdb cli

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/users/msp/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c mychannel -f /etc/hyperledger/configtx/channel.tx --tls --cafile /etc/hyperledger/orderers/msp/tlscacerts/tlsca.example.com-cert.pem
# Join peer0.org1.example.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/users/msp/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b mychannel.block
