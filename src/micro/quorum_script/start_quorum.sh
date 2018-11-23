#!/bin/bash

QUORUM="/users/yuecong/blockbench/benchmark/quorum_raft/quorum/build/bin/geth"
QUO_HOME="/users/yuecong/blockbench/src/micro/quorum_script"
QUO_DATA=$QUO_HOME/qdata
LOG_DIR=$QUO_HOME/logs

cd `dirname ${BASH_SOURCE-$0}`
pwd 

echo "[*] cleaning previous" 
killall -KILL geth ${QUORUM}
rm -rf $QUO_DATA
rm -rf ~/.eth*
rm -rf $QUO_DATA/{geth,keystore}

echo "[*] setting up quorum instance"
mkdir -p $QUO_DATA/{keystore,geth}
cp keys/* $QUO_DATA/keystore/
cp static-nodes.json $QUO_DATA/static-nodes.json
cp nodekey1 $QUO_DATA/geth/nodekey

# init
${QUORUM} --datadir=$QUO_DATA init $QUO_HOME/genesis_quorum.json

# ------------private chain(10 accounts)------------
PRIVATE_CONFIG=ignore ${QUORUM} --datadir $QUO_DATA --nodiscover --verbosity 5 --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft --emitcheckpoints --raftport 50400 --rpcport 8555 --port 9000 --rpc --raft  --rpccorsdomain "*" --gasprice 0 --maxpeers 0 --networkid 19 --raftblocktime 4000 --unlock "0x12f029d57082315085bfb4d4d8345c92c5cdd881" --password <(echo -n "") --mine --minerthreads 1

