# Performance Benchmarking of Private Blockchain Systems

The performance of blockchain systems is a critical issue. To understand the performance bottleneck of the blockchainsystems, and the performance implications according to different design choices and system parameters, we have bench-marked two prevalent blockchain systems, Hyperledger v1.3 and Quorum v2.1.0. It has been studied throughput, latency and scalability of the systems by using a suite of macro andmicro benchmarks under various range of system settings. Comparison against previously benchmarked blockchain systems under same settings has been carried on, and some interesting insights were deduced from it.

## Benchmark Workloads 

### Macro-benchmark

* YCSB (KVStore).
* SmallBank (OLTP).

### Micro-benchmark

* DoNothing (consensus layer).
* Analytics (data model layer).
* CPUHeavy (execution layer).

## Source file structure

* Smart contract sources are in [benchmark/contracts](benchmark/contracts) directory.
* Drivers for benchmark workloads are in [src](src) directory.
* Micro benchmarks workloads and scripts are in [src/micro](src/micro) for each blockchain system.
* Macro benchmarks scripts are in [benchmark](benchmark) for each blockchain system.

## Dependency

### C++ libraries
* [restclient-cpp](https://github.com/mrtazz/restclient-cpp)
* [libcurl](https://curl.haxx.se/libcurl/)

### Node.js libraries
Go to [micro](src/micro) directory and use `npm install` to install the dependency libraries
* [Web3.js](https://github.com/ethereum/web3.js/)
* [zipfian](https://www.npmjs.com/package/zipfian)
* [bignumber.js](https://www.npmjs.com/package/bignumber.js)

### Install

## Quorum
* Go to [benchmark/quorum_raft/quorum](benchmark/quorum_raft/quorum) directory and use `make` to build the geth executable

## Hyerledger v1.3

### Running the Macro Benchmark

## Quorum Raft
* Go to [benchmark/quorum_raft](benchmark/quorum_raft) directory
* Modify the file `env.sh` to choose the YCSB or Smallbank by uncommenting and commetting the respective lines
* Run  `run-bench.sh <n_servers> <n_threads> <n_clients> <tx_rate>` to run the network and the macro benchmark

## Quorum IBFT
* Go to [benchmark/quorum_ibft](benchmark/quorum_ibft) directory
* Modify the file `env.sh` to choose the YCSB or Smallbank by uncommenting and commetting the respective lines
* Run  `run-bench.sh <n_servers> <n_threads> <n_clients> <tx_rate>` to run the network and the macro benchmark

## Hyperledger v1.3 

### Running the Micro Benchmark

## Quorum
* Go to [src/micro/quorum_script](src/micro/quorum_script) directory
* Run the single node by executing `start_client.sh`
* On another terminal, go to the folder of the benchmark you intend to run located at [src/micro/<benchmark_name>](src/micro)
* See the Readme for the instructions relative to that micro benchmark
