cd `dirname ${BASH_SOURCE-$0}`

HL_HOME=`pwd`
HOSTS=$HL_HOME/hosts

GOROOT=/data/yuecong/go
FABRIC_HOME=$GOROOT/src/github.com/hyperledger1.3/multi
FABRIC_CFG_PATH=$FABRIC_HOME
PATH=$GOROOT/src/github.com/hyperledger1.3/fabric-samples/bin:/users/yuecong/local/bin:$PATH
IMAGE_TAG=latest
CHANNEL_NAME=mychannel
