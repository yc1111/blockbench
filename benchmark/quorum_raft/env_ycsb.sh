QUO_HOME=/users/yc/blockbench/benchmark/quorum_raft
QUO_DATA=/data/yc/quorum_raft
BENCHMARK=ycsb
EXE_HOME=$QUO_HOME/../../src/macro/kvstore

#####################################################
HOSTS=$QUO_HOME/hosts
CLIENTS=$QUO_HOME/clients
QUORUM=$QUO_HOME/quorum/build/bin/geth
ADDRESSES=$QUO_HOME/addresses
LOG_DIR=$QUO_HOME/logs/${BENCHMARK}results_1
