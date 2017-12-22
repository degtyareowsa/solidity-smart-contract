
var TNSCrowdSale = artifacts.require("./TNSCrowdSale.sol");
var Transcodium = artifacts.require("./Transcodium.sol");

module.exports = function(deployer, network, accounts) {

    // Timelines
    const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 300 // one second in the future
    const preEndTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 3000 // one second in the future
    const endTime = startTime + (86400 * 20) // 20 days

    // Rate of ether to Transcodium in wei + 20% Pre-sale bonus
    const rate = 850

    // Multisigned Crowdsale wallet
    const wallet = accounts[0]

    // Hardcap
    const cap = web3.toWei(200, "ether")
    const goal = web3.toWei(100, "ether")

    const tokenAddress = Transcodium.address;

    deployer.deploy(TNSCrowdSale, tokenAddress, startTime, preEndTime, endTime, rate, cap, goal, wallet);

};
