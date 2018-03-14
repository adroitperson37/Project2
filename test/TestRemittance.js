Promise = require("bluebird");
Promise.promisifyAll(web3.eth, { suffix: "Promise" });
var Remittance = artifacts.require("./Remittance.sol");

contract('Remittance', function(accounts){

    var instance;
    var owner = accounts[0];
    var exchange = accounts[1];
    var differentAccount = accounts[2];
    var password1 ="123";
    var password2="456";
    var hash;

    beforeEach('create Remittance Instance',function(){
        return Remittance.new({from:owner}).then(function(_instance) {
            console.log("created new contract");
            instance = _instance;
        })
    });


describe("Testing", () => { 

    beforeEach(function(){
      
        return Remittance.deployed().then(() => {
            return instance.getHash(password1,password2)
        .then(hash => {
           hash = hash;
           assert.isNotNull(hash);
           return instance.remit(hash,{from:exchange,value:10});
        }) 
        .then(txObject => {
            assert.strictEqual(1, txObject.receipt.status);
            assert.strictEqual("Remit", txObject.logs[0].event);
            assert.strictEqual(exchange, txObject.logs[0].args.exchangeAddress);
            assert.strictEqual(10, txObject.logs[0].args.valueSent.toNumber());
            return web3.eth.getBlockNumberPromise();
        })
        .then(blockNumber => {
            console.log(blockNumber);
        })
    
    })
})
});


//TODO:Not working 
    // })
    //     it("should withdraw exchange",() => {
    //     return instance.withdraw(hash,{from:exchange})
    //     .then(txObject => {
    //         assert.strictEqual(1, txObject.receipt.status);
    //         assert.strictEqual("WithDraw", txObject.logs[0].event);
    //         assert.strictEqual(exchange, txObject.logs[0].args.exchangeAddress);
    //         assert.strictEqual(10, txObject.logs[0].args.valueSent.toNumber());
    //     })
    //    }); 
   
    
   
    // it("Check entire functionality",function(){
    //     return instance.getHash(password1,password2)
    //     .then(hash => {
    //        hash = hash;
    //        assert.isNotNull(hash);
    //        return instance.remit(hash,{from:exchange,value:10});
    //     })
    //     .then(txObject => {
    //         assert.strictEqual(1, txObject.receipt.status);
    //         assert.strictEqual("Remit", txObject.logs[0].event);
    //         assert.strictEqual(exchange, txObject.logs[0].args.exchangeAddress);
    //         assert.strictEqual(10, txObject.logs[0].args.valueSent.toNumber());
    //         return web3.eth.getBlockNumberPromise();
    //     })
    //     .then(blockNumber => {
    //         console.log(blockNumber);
    //     })
    //    });

    //    it("checks for hash", () =>{
    //      return instance.hashExchangeMapper.call(hash)
    //      .then(val => console.log(val));

    //    })
//});

})