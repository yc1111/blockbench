#!/bin/sh

export FABRIC_HOME=$GOROOT/src/github.com/hyperledger1.3/fabric
export FABRIC_CFG_PATH=$FABRIC_HOME
export PATH=$GOROOT/src/github.com/hyperledger1.3/fabric-samples/bin:$PATH
export IMAGE_TAG=latest
export COMPOSE_PROJECT_NAME=fabric

mkdir -p $FABRIC_HOME

cp crypto-config-$1.yaml crypto-config.yaml
cp docker-compose-cli-$1.yaml docker-compose-cli.yaml
cp base/docker-compose-base-$1.yaml base/docker-compose-base.yaml
cp crypto-config.yaml $FABRIC_HOME
cp configtx.yaml $FABRIC_HOME
cp docker-compose-cli.yaml $FABRIC_HOME
cp -r base $FABRIC_HOME
cp -r chaincode $FABRIC_HOME

# generate peers
echo
echo "##########################################################"
echo "##### Generate certificates using cryptogen tool #########"
echo "##########################################################"
echo

cd $FABRIC_HOME
rm -rf crypto-config/*
cryptogen generate --config=./crypto-config.yaml

# generate genesis block
echo
echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"
echo

mkdir -p channel-artifacts
rm -rf channel-artifacts/*
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

# generate channel
echo
echo "#################################################################"
echo "### Generating channel configuration transaction 'channel.tx' ###"
echo "#################################################################"
echo

export CHANNEL_NAME="mychannel"
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

# anchor peers
echo
echo "#################################################################"
echo "#######    Generating anchor peer update for Org1MSP   ##########"
echo "#################################################################"
echo

configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

# start
CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli.yaml up -d
