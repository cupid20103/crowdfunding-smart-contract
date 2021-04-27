pragma solidity >=0.7.0 <0.9.0;

contract Crowdfund {
    
    address payable public beneficiaryAddress;
    uint public beneficiaryTarget;
    uint public endDate;
    bool public ended = false; 
    address donorAddress;
    uint donorValue;
    bool public returnDonors;
    uint public currentTotal;
        
    mapping (address => uint) public donors;
    
    constructor (
        address payable _beneficiaryAddress, 
        uint target, 
        uint biddingTime 
    ) public {
        beneficiaryAddress = _beneficiaryAddress;
        beneficiaryTarget = target;
        endDate = block.timestamp + biddingTime;
        returnDonors = false; 
    }
    
    function donate () public payable {
        require(block.timestamp <= endDate,
            "Sorry, this fundraising session has ended.");
        currentTotal += msg.value;
        donors[msg.sender] = msg.value; 
    } 
    
    modifier beneficiary() {
        require(msg.sender == beneficiaryAddress);
        _;
    }
    
    function endAuction () public beneficiary {
        require(block.timestamp >= endDate, "The auction has not yet ended.");
        require(!ended, "The auction has already ended.");
    
        ended = true;
        
        if (currentTotal >= beneficiaryTarget){
            beneficiaryAddress.transfer(currentTotal);
            currentTotal -= currentTotal;
        } else {
            returnDonors = true; 
        }
    }
    
    function returnFunds () public returns (bool) {
        require (returnDonors == true);
        uint value = donors[msg.sender];
        if (value > 0) {
            payable(msg.sender).transfer(value);
            currentTotal -= value; 
            return false;
        }
        return true;
    }
}


