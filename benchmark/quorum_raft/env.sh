QUO_HOME=/users/yuecong/blockbench/benchmark/quorum_raft
HOSTS=$QUO_HOME/hosts
CLIENTS=$QUO_HOME/clients
QUO_DATA=$QUO_HOME/qdata
LOG_DIR=$QUO_HOME/logs
EXE_HOME=$QUO_HOME/../../src/macro/kvstore
BENCHMARK=ycsb
#EXE_HOME=$QUO_HOME/../../src/macro/smallbank
#BENCHMARK=smallbank

QUORUM=$QUO_HOME/quorum/build/bin/geth
ADDRESSES=$QUO_HOME/addresses

##comment these out for smallbank
#EXE_HOME=$QUO_HOME/../../src/macro/smallbank
#BENCHMARK=smallbank 
#LOG_DIR=$QUO_HOME/smallbank_results_2
