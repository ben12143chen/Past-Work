// var GoodCitizenNetworkCrowdsale = artifacts.require("GoodCitizenNetworkCrowdsale");
 var GoodCitizenNetworkToken = artifacts.require("GoodCitizenNetworkToken.sol");

var GoodCitizenNetworkCrowdsale = artifacts.require("./GoodCitizenNetworkCrowdsale.sol");

module.exports = function(deployer) {
  const startTime = web3.eth.getBlock('latest').timestamp + 2; // two secs in the future
  const endTime = Math.round((new Date().getTime() + (86400000 * 20))/1000); // Today + 20 days
  deployer.deploy(GoodCitizenNetworkCrowdsale, 
    startTime, 
    endTime,
    1000, 
    web3.eth.accounts[0], // Replace this wallet address with the last one (10th account) from Ganache UI. This will be treated as the beneficiary address. 
    5000000000000000000, // 5 ETH cap
    2000000000000000000 // 2 ETH goal
  );
};



// module.exports = function(deployer, network, accounts) {


//     const openingTime = web3.eth.getBlock('latest').timestamp + 2; // two secs in the future
//     const closingTime = openingTime + 86400 * 20; // 20 days
//     const ethRate = new web3.BigNumber(1000);
// 	const wallet = accounts[1];
// 	const weiCap = 5000000000000000000; //5 ether
// 	const goal = 2000000000000000000; //2 ether
// 	const individualCap = 3000000000000000000; //3 ether

// deployer.deploy(GoodCitizenNetworkToken).then(function() {
// return deployer.deploy(GoodCitizenNetworkCrowdsale, openingTime, closingTime, ethRate, wallet, weiCap, GoodCitizenNetworkToken.address, goal).then( async () => {
//     const instance = await GoodCitizenNetworkCrowdsale.deployed();
//     const token = await instance.token.call();
//     console.log('Token Address', token);
// });
// });
// };