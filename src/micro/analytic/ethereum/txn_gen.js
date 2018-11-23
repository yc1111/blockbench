const TXNS_PER_BLOCK = 3
const INVOKE_TIMES = 10

var Web3 = require('web3');
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider());

var accounts = web3.personal.listAccounts;
var len = accounts.length;

console.log("accounts available:" + len + " balance of first:" + web3.eth.getBalance(accounts[0]));

var t = 0;

function gen_txns() {
  for (var i = 0; i < TXNS_PER_BLOCK; ++i) {
    var x = Math.floor(Math.random() * len); 
    var y = Math.floor(Math.random() * len); 
    var val = Math.floor(Math.random() * 100); 
    try {
      web3.personal.unlockAccount(accounts[x], "");
        web3.personal.sendTransaction({
        from: accounts[x],
        to: accounts[y],
        value: val,
        gasPrice: 0,
        gas: 0x16E360
      });
	console.log("tx sent: account #" + x + " sent " + val + " to account #" + y);
    } catch (error) {
      console.log("account: " + accounts[x]);
      console.log(error);
    }
  }
}

function sleep(time, callback) {
    var stop = new Date().getTime();
    while(new Date().getTime() < stop + time) {
        ;
    }
    callback();
}

for(var i = 0; i < INVOKE_TIMES; ++i){
   //sleep(1000, function() {
      gen_txns();
   //});
}
console.log("most recent block numer: #" + web3.eth.blockNumber);
