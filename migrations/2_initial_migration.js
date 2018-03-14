var Remittance = artifacts.require("./Remittance.sol");
var Ownable = artifacts.require("./Ownable.sol");

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.link(Ownable,Remittance);
  deployer.deploy(Remittance);
};
