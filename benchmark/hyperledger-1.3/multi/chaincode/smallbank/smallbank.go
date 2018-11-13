package main

import (
	"fmt"
	"strconv"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	sc "github.com/hyperledger/fabric/protos/peer"
)

type SmallBank struct {
}

var MAX_ACCOUNTS int = 100000
var BALANCE int = 100000
var accountTab string = "accounts"
var savingTab string = "saving"
var checkingTab string = "checking"

func main() {
	err := shim.Start(new(SmallBank))
	if err != nil {
		fmt.Printf("Error starting smallbank: %s", err)
	}
}

func (t *SmallBank) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	return shim.Success(nil)
}

func (t *SmallBank) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {

	function, args := APIstub.GetFunctionAndParameters()
	if function == "getBalance" {
		return t.getBalance(APIstub, args)
	} else if function == "updateSaving" {
		return t.updateSaving(APIstub, args)
	}

	return shim.Error("Invalid Smart Contract function name.")
}

func (t *SmallBank) getBalance(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	var bal1, bal2 int
	var err error
	bal_str1, err := stub.GetState(savingTab + "_" + args[0])
	if err != nil {
		bal_str1 = []byte(strconv.Itoa(BALANCE))
	}
	bal_str2, err := stub.GetState(checkingTab + "_" + args[0])
	if err != nil {
		bal_str2 = []byte(strconv.Itoa(BALANCE))
	}

	bal1, err = strconv.Atoi(string(bal_str1))
	if err != nil {
		bal1 = BALANCE
	}
	bal2, err = strconv.Atoi(string(bal_str2))
	if err != nil {
		bal2 = BALANCE
	}
	bal1 += bal2

	return shim.Success("Balance for " + args[0] + ": " + bal1)
}

func (t *SmallBank) updateSaving(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	bal_str3, err3 := stub.GetState(savingTab + "_" + args[0])
	if err3 != nil {
		bal_str3 = []byte(strconv.Itoa(BALANCE))
	}
	var bal1, bal2 int
	var err error

	bal1, err = strconv.Atoi(string(bal_str3))
	if err != nil {
		bal1 = BALANCE
	}
	bal2, err = strconv.Atoi(args[1])
	if err != nil {
		return nil, err
	}
	bal1 += bal2

	err = stub.PutState(savingTab+"_"+args[0], []byte(strconv.Itoa(bal1)))

	if err != nil {
		return shim.Error(err)
	}
	return shim.Success("Saving updated!")
}

