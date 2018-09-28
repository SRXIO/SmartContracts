pragma solidity ^0.4.23;

contract Crowdsale{
    
    
    address public owner;
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    function changeOwner(address _newOwner) public onlyOwner{
        require(_newOwner != address(0x0));
        owner = _newOwner;
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    event Tranferred(address beneficiary, uint tokenAmount, uint bonusAmount);
    
    function transfer(address _beneficiary, uint _tokenAmount, uint _bonusAmont) public onlyOwner{
        emit Tranferred(_beneficiary, _tokenAmount, _bonusAmont);
    }
}