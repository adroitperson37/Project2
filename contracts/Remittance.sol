pragma solidity ^0.4.17;

import "./Ownable.sol";
contract Remittance  is Ownable {
    
    uint public deadLine;

     struct ExchangeType {
        uint amount;
        address exchange;
     }
    mapping(bytes32 => ExchangeType) public hashExchangeMapper;
    
    event LogRemit(address indexed sender, ExchangeType indexed exchangeType, bytes32 indexed hash);
    event LogWithDraw(address indexed exchangeAddress, uint indexed amountWithDraw);
    event LogWarningToWithDrawBeforeRemit(address indexed exchangeAddress, uint indexed amountWithDraw);
    
    function getHash(address exchange,bytes32 password1,bytes32 password2) public pure returns(bytes32) {
        return  keccak256(exchange,password1,password2);
    }
    
    function remit(bytes32 hash, address exchange) public payable {
        require(msg.value>0);
        require(hash!=bytes32(0));
        require(hashExchangeMapper[hash].amount==0);
        require(exchange!=address(0));
        //To make sure sender is not the one who is remitting.
        require(msg.sender!=exchange);

       ExchangeType memory exchangeType;
       exchangeType.exchange = exchange;
       exchangeType.amount += msg.value;
       hashExchangeMapper[hash] = exchangeType;
       LogRemit(msg.sender,exchangeType,hash);
        
    }
     
   function withdraw(bytes32 hash) public {
      //Check if the amount is present and greater than zero.
    uint  amount = hashExchangeMapper[hash].amount;
    require(amount>0);
    require(hashExchangeMapper[hash].exchange == msg.sender);

    //Change state before transer
    hashExchangeMapper[hash].amount = 0;
    LogWithDraw(msg.sender,amount);
    //Send the amount
    msg.sender.transfer(amount);
    

  } 
}