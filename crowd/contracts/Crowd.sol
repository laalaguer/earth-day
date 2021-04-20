pragma solidity >=0.5.3 <=0.6.4;

// Crowd contract allows users 
// to participate in a crowd funding in a limited time frame.

// Owner of the contract can decide:
// 1. Stop time of this round of crowd funding (using block.number).
// 2. If allow a user to deposit multiple times.
// 3. To which address withdraw the funds collected.

// The public audience can view:
// 1. total VET in the contract.
// 2. total participants in the contract.
// 3. stop time of the crowd funding.
// 4. If crowd funding allows multiple deposits.

contract Crowd {
    event Deposit(address addr, uint amount);
    event Withdrawal(address indexed receiver, uint amount);

    mapping (address => uint) public balanceOf; // Users and their deposit amount
    address[] public users; // Users list

    address public owner; // Owner of the smart contract
    uint public stopBlockNumber; // After which the crowd sale stops
    bool public allowDuplicate; // Allow user to deposit multiple times and counts as multiple.
    uint public minValue; // minimum value (VET in Wei) that required to do donation.

    constructor(uint _blockNumber, bool _allowDuplicate, uint _minValue) public {
        owner = msg.sender;
        stopBlockNumber = _blockNumber;
        allowDuplicate = _allowDuplicate;
        minValue = _minValue;
    }

    // User: deposit VET into this contract
    function() external payable {
        deposit();
    }

    // User: deposit VET into this contract
    function deposit() public payable {
        require(block.number < stopBlockNumber, "too late to participate");
        require(msg.value > minValue, "pay more please");
        if (allowDuplicate == false) {
            if (balanceOf[msg.sender] > 0) {
                revert("Don't allow multiple deposits, and you have already deposited");
            }
        }
        // Track user balance
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
        // Track user position in the list
        users.push(msg.sender);
    }

    // Owner: set block number after which public deposit is not allowed.
    function setStop(uint _blockNumber) public {
        require(msg.sender == owner, "only owner can call");
        stopBlockNumber = _blockNumber;
    }

    // Owner: set if allow a single user to deposit multiple times
    // and counted as multiple times.
    function setAllowDuplicate(bool _allow) public {
        require(msg.sender == owner, "only owner can call");
        allowDuplicate = _allow;
    }
    
    // Public: total VET transferred into this smart contract.
    function total() public view returns (uint) {
        return address(this).balance;
    }

    // Public: total users in the current pool
    function countUsers() public view returns (uint) {
        return users.length;
    }

    // Owner: withdraw all VET from this smart contract.
    function withdraw(address payable _receiver) public {
        require(msg.sender == owner, "only owner can call");
        uint currentBalance = address(this).balance;
        _receiver.transfer(currentBalance);
        emit Withdrawal(_receiver, currentBalance);
    }
}