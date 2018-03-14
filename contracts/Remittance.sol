pragma solidity ^0.4.17;

import "./Ownable.sol";
contract Remittance  is Ownable {
    
    uint public deadLine;

     struct ExchangeType {
        uint amount;
        address exchange;
     }
    mapping(bytes32 => ExchangeType) public hashExchangeMapper;
    
    event Remit(address exchangeAddress, uint valueSent);
    event WithDraw(address exchangeAddress, uint amountWithDraw);
    event WarningToWithDrawBeforeRemit(address exchangeAddress, uint amountWithDraw);
    
    function getHash(bytes32 password1,bytes32 password2) public pure returns(bytes32) {
        return  keccak256(password1,password2);
    }
    
    function remit(bytes32 hash) public payable {
        require(msg.value>0);
        require(hash!=bytes32(0));
        require(hashExchangeMapper[hash].amount==0);

       ExchangeType memory exchangeType;
       exchangeType.exchange = msg.sender;
       exchangeType.amount += msg.value;
       hashExchangeMapper[hash] = exchangeType;
       Remit(msg.sender,msg.value);
        
    }
     
   function withdraw(bytes32 hash) public {
      //Check if the amount is present and greater than zero.
    uint  amount = hashExchangeMapper[hash].amount;
    require(amount>0);
    require(hashExchangeMapper[hash].exchange == msg.sender);

    //Change state before transer
    hashExchangeMapper[hash].amount = 0;
    //Send the amount
    msg.sender.transfer(amount);
    WithDraw(msg.sender,amount);

  } 
}