pragma solidity ^0.8.10;
import "./accessModifier.sol";

interface IBank {
	// Customer Struct.
	struct Customer {
		bytes32 usernameOfTheCustomer;// unique
		bytes32 customerData;
		bool kycStatus;
		uint downvotes;
		uint upvotes;
		address bankAddress;
	}
	// Bank Struct.
	struct Bank {
		bytes32 name;
		address ethAddress;
		uint complaintsReported;
		uint KYC_count;
		bool isAllowedToVote;
		bytes32 regNumber;
	}
    function addCustomer(bytes32 _usernameOfTheCustomer,bytes32 _customerData) external returns (bool);
    function modifyCustomer(bytes32 _usernameOfTheCustomer,bytes32 _customerData) external returns (bool);
    function viewCustomer(bytes32 _usernameOfTheCustomer) external view returns(Customer memory);
    function addRequest(bytes32 _usernameOfTheCustomer,bytes32 _customerDataHash) external returns (bool);
    function removeRequest(bytes32 _usernameOfTheCustomer) external returns (bool);
    function upVoteCustomers(bytes32 _usernameOfTheCustomer) external returns (bool);
    function downVoteCustomers(bytes32 _usernameOfTheCustomer) external returns (bool);
    function getBankComplaints(address _ethAddress) external view returns (uint);
    function viewBankDetails(address _ethAddress) external view returns(Bank memory);
    function reportBank(address _ethAddress) external returns (bool);
}

interface IAdmin {
    function addBank(bytes32 _bankName,address _bankAddress, bytes32 _regNumber) external returns (bool);
    function removeBank(address _bankAddress) external returns (bool);
    function modifyBankIsAllowedToVote(address _bankAddress,bool _isVote) external returns (bool);
}

contract CustomerKYC is IBank,IAdmin,AccessModifier {

	// Bank RequestKYC.
	struct RequestKYC {
        bytes32 usernameOfTheCustomer;// unique
        address bankAddress;
        bytes32 customerData;
    }

	// map to store customer list
	mapping(bytes32=> Customer) public customerList;

	// map to store requestKYC list
	mapping(bytes32 => RequestKYC) requestKYCList;

	// map to store requestKYC list
	mapping(address => Bank) bankList;

	// Define events we wish to emit
	event addCustomerEvent(address customer, bytes32 indexed receiver);
	event modifyCustomerEvent(address customer, bytes32 indexed receiver);
	event addRequestEvent(address customer, bytes32 indexed receiver);
	event removeRequestEvent(address customer, bytes32 indexed receiver);
	event addBamkEvent(address customer);
	event modifyBamkEvent(address customer);
	event removeBamkEvent(address customer);

	// function to add customer
	function addCustomer(bytes32 _usernameOfTheCustomer, bytes32 _customerData) external returns(bool){
		// if customer exits or not 
		require(customerList[_usernameOfTheCustomer].bankAddress == address(0),"Invalid parameters! Customer already taken, Please try another one");
		// added to customer list
		customerList[_usernameOfTheCustomer].usernameOfTheCustomer = _usernameOfTheCustomer;
		customerList[_usernameOfTheCustomer].customerData = _customerData;
		customerList[_usernameOfTheCustomer].bankAddress = msg.sender;
		// loging new added customer
		emit addCustomerEvent(msg.sender, _usernameOfTheCustomer);
		return true;
	}
	// function to modify customer
	function modifyCustomer(bytes32 _usernameOfTheCustomer, bytes32 _customerData) external returns(bool){
		// if customer exits or not 
		require(customerList[_usernameOfTheCustomer].bankAddress != address(0),"Invalid parameters! User name already taken, Please try another one");
		// updating to customer list docs
		customerList[_usernameOfTheCustomer].customerData = _customerData;
		// loging new docs added to customer
		emit modifyCustomerEvent(msg.sender, _usernameOfTheCustomer);
		return true;
	}
	// function to view customer
	function viewCustomer(bytes32 _usernameOfTheCustomer) external view returns(Customer memory){
		// if customer exits or not 
		require(customerList[_usernameOfTheCustomer].bankAddress != address(0),"Invalid parameters! User name does not exist, Please try another one");
		// return the same customer
		return customerList[_usernameOfTheCustomer];
	}
	// Adding a KYC request of a customer
    function addRequest(bytes32 _usernameOfTheCustomer, bytes32 _customerDataHash) external returns (bool){
        require(requestKYCList[_usernameOfTheCustomer].bankAddress == address(0), "Request already exist, Please try another one");
        requestKYCList[_usernameOfTheCustomer].usernameOfTheCustomer = _usernameOfTheCustomer;
        requestKYCList[_usernameOfTheCustomer].customerData = _customerDataHash;
        requestKYCList[_usernameOfTheCustomer].bankAddress = msg.sender;
		// loging new addRequest customer
		emit addRequestEvent(msg.sender, _usernameOfTheCustomer);
		return true;
    }
	// Remove the request added by the bank
    function removeRequest(bytes32 _usernameOfTheCustomer) external returns (bool) {
        require(requestKYCList[_usernameOfTheCustomer].bankAddress != address(0), "Request doesn't exist, Please try another one");
        delete requestKYCList[_usernameOfTheCustomer];
		// loging new docs added to customer
		emit removeRequestEvent(msg.sender, _usernameOfTheCustomer);
		return true;
    }
	// upvote customer request added by the bank
	function upVoteCustomers(bytes32 _usernameOfTheCustomer) external returns (bool) {
        require(customerList[_usernameOfTheCustomer].bankAddress != address(0), "Customer doesn't exist");
        customerList[_usernameOfTheCustomer].upvotes += 1;
		return true;
    }
	// down vote customer request added by the bank
	function downVoteCustomers(bytes32 _usernameOfTheCustomer) external returns (bool) {
        require(customerList[_usernameOfTheCustomer].bankAddress != address(0), "Customer doesn't exist");
        customerList[_usernameOfTheCustomer].downvotes += 1;
		return true;
    }
	// Complaints against a bank
    function getBankComplaints(address _ethAddress) public view returns (uint) {
        require(bankList[_ethAddress].ethAddress != address(0), "bank doesn't exist");
        return bankList[_ethAddress].complaintsReported;
    }
	// view bank details
    function viewBankDetails(address _ethAddress) public view returns (Bank memory) {
        require(bankList[_ethAddress].ethAddress != address(0), "bank doesn't exist");
        return bankList[_ethAddress];        
    }
    // Reporting the bank
    function reportBank(address _ethAddress) external returns (bool) {
        require(bankList[_ethAddress].ethAddress != address(0), "bank doesn't exist");
        bankList[_ethAddress].isAllowedToVote = false;
		return true;
    }
  	// add bank
    function addBank(bytes32 _bankName, address _bankAddress, bytes32 _regNumber) external isAdmin returns(bool) {
		require(bankList[_bankAddress].ethAddress == address(0),"Invalid parameters! Bank already exist, Please try another one");
		bankList[_bankAddress].name = _bankName;
        bankList[_bankAddress].ethAddress = _bankAddress;
		bankList[_bankAddress].complaintsReported = 0;
		bankList[_bankAddress].KYC_count = 0;
		bankList[_bankAddress].isAllowedToVote = true;
		bankList[_bankAddress].regNumber = _regNumber;
		// loging new docs added to customer
		emit addBamkEvent(msg.sender);
		return true;
    }
    
    // modify bank
    function modifyBankIsAllowedToVote(address _bankAddress,bool _isVote) external isAdmin returns(bool) {
		require(bankList[_bankAddress].ethAddress == address(0),"Invalid parameters! Bank already exist, Please try another one");
		bankList[_bankAddress].isAllowedToVote = _isVote;
		// loging new docs added to customer
		emit modifyBamkEvent(msg.sender);
		return true;
    }
    
    // remove bank
    function removeBank(address _bankAddress) external isAdmin returns (bool) {
		require(bankList[_bankAddress].ethAddress != address(0),"Invalid parameters! Bank doesn't exist, Please try another one");
		delete bankList[_bankAddress];
		// loging new docs added to customer
		emit removeBamkEvent(msg.sender);
		return true;
    }
}