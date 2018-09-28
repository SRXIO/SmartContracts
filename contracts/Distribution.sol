pragma solidity ^0.4.24;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


contract Token{
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
}
contract Distribution{

    using SafeMath for uint;

    address public owner;
    Token token;
    constructor() public{
        // owner =  // TODO
        token = Token(0xb444264c33eF3c8F9Ba46DF194826C22D54d0D12);
    }

    bool distribution_in_process = false;

    address[] public users;
    mapping(address => bool) public userExists;

    uint public indexOfPayee = 0;

    uint public current_distribution_balance = 0;

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner{
        require(_newOwner != 0x0);
        owner = _newOwner;
    }

    function() public payable{
        //fallback function accepts ETH
    }

    function addUsers(address[] _users) public{
        require(_users.length > 0);

        for(uint i = 0; i < _users.length; i++){
            if(!userExists[_users[i]]){
                users.push(_users[i]);
            }
        }
    }

    function setupDistribution() public onlyOwner{
        require(!distribution_in_process);

        indexOfPayee = 0;
        current_distribution_balance = address(this).balance;
        distribution_in_process = true;
    }

    function distributeETH() public onlyOwner{
        require(current_distribution_balance > 0);
        require(distribution_in_process);

        uint i = indexOfPayee;
        while(i<users.length && msg.gas > 90000){
            

            uint EthToSend = current_distribution_balance.mul(token.balanceOf(users[i])).div(token.totalSupply()); //TODO
                
            require(address(this).balance >= EthToSend);
            users[i].transfer(EthToSend);
            
            i++;
        }

        indexOfPayee = i;

        if(i == users.length){
            distribution_in_process = false;
        }
    }
}