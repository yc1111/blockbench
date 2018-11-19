#ifndef SMARTCONTRACT_DRIVERS_HLDB_H_
#define SMARTCONTRACT_DRIVERS_HLDB_H_

#include <string>
#include "DB.h"
#include "utils/timer.h"
#include "utils/utils.h"
#include <unordered_map>
#include <vector>
using std::unordered_map; 
using std::string; 
using std::vector; 

class HLDB : public DB {
 public:
  void Amalgate(unsigned acc1, unsigned acc2) override;
  void GetBalance(unsigned acc) override;
  void UpdateBalance(unsigned acc, unsigned amount) override;
  void UpdateSaving(unsigned acc, unsigned amount) override;
  void SendPayment(unsigned acc1, unsigned acc2, unsigned amount) override;
  void WriteCheck(unsigned acc, unsigned amount) override;

  static HLDB* GetInstance(std::string path, std::string endpoint) {
    static HLDB db;
    db.deploy(path, endpoint);
    return &db;
  }

  HLDB() {}
  HLDB(std::string path, std::string endpoint) {
    deploy(path, endpoint); 
  }

  void Init(unordered_map<string, double> *pendingtx, SpinLock *lock) override {
    pendingtx_ = pendingtx;
    txlock_ = lock;
  }

  ~HLDB() {}

  unsigned int get_tip_block_number() override;
  vector<string> poll_tx(int block_number) override;
  int find_tip(string json);
  vector<string> find_tx(string json); 
  string get_json_field(const string &json, const string &key); 
 private:
  inline void deploy(const std::string& path, const std::string& endpoint) override {
    endpoint_ = endpoint;
  }
  void add_to_queue(string json) override;
  std::string exec(const char* cmd);
  std::string chaincode_name_, endpoint_;
  unordered_map<string, double> *pendingtx_; 
  SpinLock *txlock_; 
};

#endif
