var Transcodium = artifacts.require("./Transcodium.sol");

module.exports = function(deployer, network, accounts) {

    deployer.deploy(Transcodium);
};
