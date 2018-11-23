#include "HLDB.h"

#include <restclient-cpp/restclient.h>
#include <string>
#include <vector>
#include <iostream>
#include <cstdio>
#include <memory>
#include <stdexcept>
#include <array>

#include "utils/chaincode_apis.h"
#include "utils/timer.h"

using namespace RestClient;
using namespace std;
const string CHAIN_END_POINT = "/chain";
const string BLOCK_END_POINT = "/chain/blocks";

const string PREFIX = "docker exec \
    -e 'CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp' \
    -e 'CORE_PEER_ADDRESS=peer0.org2.example.com:7051' \
    -e 'CORE_PEER_LOCALMSPID=Org2MSP' \
    -e 'CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt' \
    cli ";

const string ORDERER = "orderer.example.com:7050 ";
const string ORDERCA = "--tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem ";
const string INVOKE = PREFIX + "peer chaincode invoke -C mychannel -n smallbank -o " + ORDERER + ORDERCA;

string HLDB::get_json_field(const std::string &json,
                                  const std::string &key) {
  auto key_pos = json.find(key);
  auto quote_sign_pos_1 = json.find('\"', key_pos + 1);
  auto quote_sign_pos_2 = json.find('\"', quote_sign_pos_1 + 1);
  auto quote_sign_pos_3 = json.find('\"', quote_sign_pos_2 + 1);
  return json.substr(quote_sign_pos_2 + 1,
                     quote_sign_pos_3 - quote_sign_pos_2 - 1);
}

vector<string> HLDB::find_tx(string json){
  vector<string> ss;
  auto key_pos = json.find("tx_id");
  while (key_pos!=string::npos){
    auto quote_sign_pos_1 = json.find('\"', key_pos + 1);
    auto quote_sign_pos_2 = json.find('\"', quote_sign_pos_1 + 1);
    auto quote_sign_pos_3 = json.find('\"', quote_sign_pos_2 + 1);
    string temp = json.substr(quote_sign_pos_2 + 1, quote_sign_pos_3 - quote_sign_pos_2 - 1);
    ss.push_back(json.substr(quote_sign_pos_2 + 1,
          quote_sign_pos_3 - quote_sign_pos_2 - 1));
    key_pos = json.find("tx_id", quote_sign_pos_3+1);
  }
  return ss;
}

int HLDB::find_tip(string json){
  if (json.find("Failed")!=string::npos)
    return -1;
  int key_pos = json.find("height");
  auto close_quote_pos = json.find('\"',key_pos+1);
  auto comma_pos = json.find(',', key_pos+1);
  string sval = json.substr(close_quote_pos+2, comma_pos-close_quote_pos-2);
  return stoi(sval);
}

vector<string> HLDB::poll_tx(int block_number) {
  string command = PREFIX + "peer channel fetch " + to_string(block_number) + " -c mychannel";
  system(command.c_str());
  command = PREFIX + "cat mychannel_" + to_string(block_number) + ".block > mychannel_" + to_string(block_number) + ".block";
  system(command.c_str());
  command = "configtxlator proto_decode --type=common.Block --input=mychannel_" + to_string(block_number) + ".block --output=mychannel_" + to_string(block_number) + ".json";
  system(command.c_str());
  command = "cat mychannel_" + to_string(block_number) + ".json";
  return find_tx(exec(command.c_str()));
}

unsigned int HLDB::get_tip_block_number(){
  string command = PREFIX + "peer channel getinfo -c mychannel";
  return find_tip(exec(command.c_str()));
}

void HLDB::add_to_queue(string json){
  
}

void HLDB::Amalgate(unsigned acc1, unsigned acc2) {
  string command = INVOKE + "-c ' \
      { \
        \"function\":\"amalgate\", \
        \"Args\":[ \
          \"" + to_string(acc1) + "\", \
          \"" + to_string(acc2) + "\" \
          ] \
      }'";
  //cout << command << endl;
  system(command.c_str());
}

void HLDB::GetBalance(unsigned acc) {
  string command = INVOKE + "-c ' \
      { \
        \"function\":\"getBalance\", \
        \"Args\":[ \
          \"" + to_string(acc) + "\" \
          ] \
      }'";
  //cout << command << endl;
  system(command.c_str());
}

void HLDB::UpdateBalance(unsigned acc, unsigned amount) {
  string command = INVOKE + "-c ' \
      { \
        \"function\":\"updateBalance\", \
        \"Args\":[ \
          \"" + to_string(acc) + "\", \
          \"" + to_string(amount) + "\" \
          ] \
      }'";
  //cout << command << endl;
  system(command.c_str());
}

void HLDB::UpdateSaving(unsigned acc, unsigned amount) {
  string command = INVOKE + "-c ' \
      { \
        \"function\":\"updateSaving\", \
        \"Args\":[ \
          \"" + to_string(acc) + "\", \
          \"" + to_string(amount) + "\" \
          ] \
      }'";
  //cout << command << endl;
  system(command.c_str());
}

void HLDB::SendPayment(unsigned acc1, unsigned acc2, unsigned amount) {
  string command = INVOKE + "-c ' \
      { \
        \"function\":\"sendPayment\", \
        \"Args\":[ \
          \"" + to_string(acc1) + "\", \
          \"" + to_string(acc2) + "\", \
          \"" + to_string(amount) + "\" \
          ] \
      }'";
  //cout << command << endl;
  system(command.c_str());
}

void HLDB::WriteCheck(unsigned acc, unsigned amount) {
  string command = INVOKE + "-c ' \
      { \
        \"function\":\"writeCheck\", \
        \"Args\":[ \
          \"" + to_string(acc) + "\", \
          \"" + to_string(amount) + "\" \
          ] \
      }'";
  //cout << command << endl;
  system(command.c_str());
}

std::string HLDB::exec(const char* cmd) {
  std::array<char, 128> buffer;
  std::string result;
  std::shared_ptr<FILE> pipe(popen(cmd, "r"), pclose);
  if (!pipe) throw std::runtime_error("popen() failed!");
  while (!feof(pipe.get())) {
    if (fgets(buffer.data(), 128, pipe.get()) != nullptr)
      result += buffer.data();
  }
  return result;
}
