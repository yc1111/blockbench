package main

import (
	"bytes"
	"fmt"
	"strconv"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	sc "github.com/hyperledger/fabric/protos/peer"
)

// Define the Smart Contract structure
type SmallBank struct {
}

var MAX_ACCOUNTS int = 100000
var BALANCE int = 100000
var accountTab string = "accounts"
var savingTab string = "saving"
var checkingTab string = "checking"

/*
 * The Init method is called when the Smart Contract "fabcar" is instantiated by the blockchain network
 * Best practice is to have any Ledger initialization in separate function -- see initLedger()
 */
func (s *SmallBank) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	return shim.Success(nil)
}

/*
 * The Invoke method is called as a result of an application request to run the Smart Contract "fabcar"
 * The calling application program has also specified the particular smart contract function to be called, with arguments
 */
func (s *SmallBank) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {

	// Retrieve the requested Smart Contract function and arguments
	function, args := APIstub.GetFunctionAndParameters()
	// Route to the appropriate handler function to interact with the ledger appropriately
	if function == "amalgate" {
		return s.amalgate(APIstub, args)
	} else if function == "getBalance" {
		return s.getBalance(APIstub, args)
	} else if function == "updateBalance" {
		return s.updateBalance(APIstub, args)
	} else if function == "updateSaving" {
		return s.updateSaving(APIstub, args)
	} else if function == "sendPayment" {
		return s.sendPayment(APIstub, args)
	} else if function == "writeCheck" {
		return s.writeCheck(APIstub, args)
	} else if function == "Query" {
		return s.Query(APIstub, args)
	}

	return shim.Error("Invalid Smart Contract function name.")
}

func (s *SmallBank) Query(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	valAsbytes, _ := APIstub.GetState(args[0])
	return shim.Success(valAsbytes)
}

func (s *SmallBank) amalgate(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	var bal1, bal2 int
	bal_str1, err := APIstub.GetState(savingTab + "_" + args[0])
	if err != nil {
		bal_str1 = []byte(strconv.Itoa(BALANCE))
	}
	bal_str2, err := APIstub.GetState(checkingTab + "_" + args[1])
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

	err = APIstub.PutState(checkingTab+"_"+args[0], []byte(strconv.Itoa(0)))

	if err != nil {
		return shim.Error(err.Error())
	}

	err = APIstub.PutState(savingTab+"_"+args[1], []byte(strconv.Itoa(bal1)))

	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success(nil)
}

func (s *SmallBank) getBalance(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	var bal1, bal2 int
	bal_str1, err := APIstub.GetState(savingTab + "_" + args[0])
	if err != nil {
		bal_str1 = []byte(strconv.Itoa(BALANCE))
	}
	bal_str2, err := APIstub.GetState(checkingTab + "_" + args[0])
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
	var buffer bytes.Buffer
	buffer.WriteString("{\"result\":\"")
	buffer.WriteString(strconv.Itoa(bal1))
	buffer.WriteString("\"}")
	return shim.Success(buffer.Bytes())
}

func (s *SmallBank) updateBalance(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	
	bal_str, err2 := APIstub.GetState(checkingTab + "_" + args[0])
	if err2 != nil {
		bal_str = []byte(strconv.Itoa(BALANCE))
	}
	
	var bal1, bal2 int
	var err error
	bal1, err = strconv.Atoi(string(bal_str))
	if err != nil {
		bal1 = BALANCE
	}
	bal2, err = strconv.Atoi(args[1])
	if err != nil {
		return shim.Error(err.Error())
	}
	bal1 += bal2

	err = APIstub.PutState(checkingTab+"_"+args[0], []byte(strconv.Itoa(bal1)))

	if err != nil {
		shim.Error(err.Error())
	}
	return shim.Success(nil)
}

func (s *SmallBank) updateSaving(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	bal_str3, err3 := APIstub.GetState(savingTab + "_" + args[0])
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
		return shim.Error(err.Error())
	}
	bal1 += bal2

	err = APIstub.PutState(savingTab+"_"+args[0], []byte(strconv.Itoa(bal1)))

	if err != nil {
		shim.Error(err.Error())
	}
	return shim.Success(nil)
}

func (s *SmallBank) sendPayment(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	
	var bal1, bal2, amount int
	var err error

	bal_str1, err := APIstub.GetState(checkingTab + "_" + args[0])
	if err != nil {
		bal_str1 = []byte(strconv.Itoa(BALANCE))
	}
	bal_str2, err := APIstub.GetState(checkingTab + "_" + args[1])
	if err != nil {
		bal_str2 = []byte(strconv.Itoa(BALANCE))
	}
	amount, err = strconv.Atoi(args[2])

	bal1, err = strconv.Atoi(string(bal_str1))
	if err != nil {
		bal1 = BALANCE
	}
	bal2, err = strconv.Atoi(string(bal_str2))
	if err != nil {
		bal2 = BALANCE
	}
	bal1 -= amount
	bal2 += amount

	err = APIstub.PutState(checkingTab+"_"+args[0], []byte(strconv.Itoa(bal1)))

	if err != nil {
		return shim.Error(err.Error())
	}

	err = APIstub.PutState(checkingTab+"_"+args[1], []byte(strconv.Itoa(bal2)))

	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success(nil)
}

func (s *SmallBank) writeCheck(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	
	bal_str2, err2 := APIstub.GetState(checkingTab + "_" + args[0])
	if err2 != nil {
		bal_str2 = []byte(strconv.Itoa(BALANCE))
	}
	bal_str3, err3 := APIstub.GetState(savingTab + "_" + args[0])
	if err3 != nil {
		bal_str3 = []byte(strconv.Itoa(BALANCE))
	}

	var bal1, bal2 int
	var amount int
	var err error
	bal1, err = strconv.Atoi(string(bal_str2))
	if err != nil {
		bal1 = BALANCE
	}
	bal2, err = strconv.Atoi(string(bal_str3))
	if err != nil {
		bal2 = BALANCE
	}
	amount, err = strconv.Atoi(args[1])
	if amount < bal1+bal2 {
		err = APIstub.PutState(checkingTab+"_"+args[0], []byte(strconv.Itoa(bal1-amount-1)))
	} else {
		err = APIstub.PutState(checkingTab+"_"+args[0], []byte(strconv.Itoa(bal1-amount)))
	}

	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success(nil)
}


// The main function is only relevant in unit test mode. Only included here for completeness.
func main() {

	// Create a new Smart Contract
	err := shim.Start(new(SmallBank))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}

