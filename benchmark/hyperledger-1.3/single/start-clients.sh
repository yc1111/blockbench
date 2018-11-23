#!/bin/bash
# args=THREADS index N txrate
if [ $# -lt 2 ]; then
	echo "Usage: $0 <threads> <txrate>"
	exit 1
fi
NTHREADS=$1
TXRATE=$2

cd `dirname ${BASH_SOURCE-$0}`
. env.sh

echo IN START_CLIENTS $1 $2

LOG_DIR=$LOG_DIR/hl_exp_$NTHREADS"_"threads_$TXRATE"_"rates
mkdir -p $LOG_DIR
cd $EXE_HOME
export LD_LIBRARY_PATH=/users/yuecong/local/lib
nohup ./driver -db hl1.3 -ops 1000000 -threads $NTHREADS -txrate $TXRATE -fp $LOG_DIR/stat.log -endpoint 0.0.0.0:7050/chaincode | grep --line-buffered -v "\[.*\]" > $LOG_DIR/client_0_$NTHREADS 2>&1 &

