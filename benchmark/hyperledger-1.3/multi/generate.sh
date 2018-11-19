#!/bin/bash
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
cd `dirname ${BASH_SOURCE-$0}`
. env.sh

echo $FABRIC_HOME
mkdir -p $FABRIC_HOME

# remove previous crypto material and config transactions
rm -rf $FABRIC_HOME/*

cp crypto-config.yaml $FABRIC_HOME
cp configtx.yaml $FABRIC_HOME
cp docker-compose.yml $FABRIC_HOME
cp docker-compose-peer.yml $FABRIC_HOME
cp -r chaincode $FABRIC_HOME
cp -r crypto-config $FABRIC_HOME

cd $FABRIC_HOME

echo "=================generate genesis block for orderer=================="
mkdir -p config
configtxgen -profile OneOrgOrdererGenesis -outputBlock ./config/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

echo "============generate channel configuration transaction=============="
configtxgen -profile OneOrgChannel -outputCreateChannelTx ./config/channel.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

echo "=================generate anchor peer transaction=================="
configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./config/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi
