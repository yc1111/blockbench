#!/bin/bash

cd `dirname ${BASH_SOURCE-$0}`
. env.sh

export CC_SRC_PATH=github.com/smallbank
export COMPOSE_PROJECT_NAME=fabric

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo "========= ERROR !!! FAILED to execute End-2-End Scenario ==========="
    echo
    exit 1
  fi
}


# Create the channel
docker exec cli peer channel create -o orderer.example.com:7050 -c mychannel -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Join channel
for org in {1..2}
do
  for peer in {0..3}
  do
    docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${org}.example.com/users/Admin@org${org}.example.com/msp" -e "CORE_PEER_ADDRESS=peer${peer}.org${org}.example.com:7051" -e "CORE_PEER_LOCALMSPID="Org${org}MSP"" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${org}.example.com/peers/peer${peer}.org${org}.example.com/tls/ca.crt" cli peer channel join -b mychannel.block
  done
  docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${org}.example.com/users/Admin@org${org}.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org${org}.example.com:7051" -e "CORE_PEER_LOCALMSPID="Org${org}MSP"" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org${org}.example.com/peers/peer0.org${org}.example.com/tls/ca.crt" cli peer channel update -o orderer.example.com:7050 -c mychannel -f ./channel-artifacts/Org${org}MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
done

# Chaincode install
docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org1.example.com:7051" -e "CORE_PEER_LOCALMSPID="Org1MSP"" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" cli peer chaincode install -n smallbank -v 1.0 -p "$CC_SRC_PATH" >& log.txt
res=$?
set +x
cat log.txt
verifyResult $res "Chaincode installation on peer0.org1 has failed"
echo "===================== Chaincode is installed on peer0.org1 ===================== "
echo


docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" -e "CORE_PEER_LOCALMSPID="Org2MSP"" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" cli peer chaincode install -n smallbank -v 1.0 -p "$CC_SRC_PATH" >& log.txt
res=$?
set +x
cat log.txt
verifyResult $res "Chaincode installation on peer0.org2 has failed"
echo "===================== Chaincode is installed on peer0.org2 ===================== "
echo

# Chaincode instantiation
docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" -e "CORE_PEER_LOCALMSPID="Org2MSP"" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" cli peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n smallbank -v 1.0 -c '{"Args":[""]}' -P "OR ('Org1MSP.member','Org2MSP.member')" >& log.txt
cat log.txt
verifyResult $res "Chaincode instantiation on peer0.org2 on channel 'mychannel' failed"
echo "===================== Chaincode is instantiated on peer0.org2 on channel 'mychannel' ===================== "
echo

sleep 10

# Invoke
#docker exec -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp" -e "CORE_PEER_ADDRESS=peer0.org2.example.com:7051" -e "CORE_PEER_LOCALMSPID="Org2MSP"" -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" cli peer chaincode invoke -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n fabcar -c '{"function":"initLedger","Args":[""]}'
