const MDY = artifacts.require("BEP20Token");
const Lottery = artifacts.require("Lottery");

module.exports = function(deployer) {
  deployer.deploy(MDY).then(function(){
    return deployer.deploy(Lottery, 10, 100, MDY.address)
  })
};