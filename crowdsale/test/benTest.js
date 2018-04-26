var GoodCitizenNetworkToken = artifacts.require("../contracts/GoodCitizenNetworkToken.sol");
var GoodCitizenNetworkCrowdsale = artifacts.require("../contracts/GoodCitizenNetworkCrowdsale.sol");
var expectThrow = require("./helpers/expectThrow.js");
var increaseTime = require("./helpers/increaseTime.js");

//glitchy bc race conditions
	//owner is account[0], alice is account[1], bob is account[2]
	let aliceAddress = web3.eth.accounts[1];
	let bobAddress = web3.eth.accounts[2];

contract('TokenCheckOwner', async (accounts) => {
	it("token contract owner should be account[0]", async() => {
		let gcnToken = await GoodCitizenNetworkToken.deployed();
		let gcnOwner = await gcnToken.owner();
		assert.equal(gcnOwner, accounts[0], 'gcnOwner is not accounts[0]')
	});
});

contract('CrowdsaleOwnershipAndWithdrawal', async (accounts) => {
	it("alice balance should be zero", async() => {
		let gcnToken = await GoodCitizenNetworkToken.deployed();
		let gcnCrowdsale = await GoodCitizenNetworkCrowdsale.deployed();
		let aliceAccountBalance = await gcnToken.balanceOf(aliceAddress);
		assert.equal(aliceAccountBalance, 0, 'Alice Balance != 0');
	});
	it("passes ownership of token contract to crowdsale", async() => {
		let gcnToken = await GoodCitizenNetworkToken.deployed();
		let gcnCrowdsale = await GoodCitizenNetworkCrowdsale.deployed();
		//we transfer ownership of the token to the crowdsale, so it can mint tokens as neccesary
		gcnToken.transferOwnership(gcnCrowdsale.address); 
		assert.equal(await gcnToken.owner(), await gcnCrowdsale.address, 'Ownership not transferred');
		//gcnCrowdsale can now buy tokens, and mint them as necessary
	});
	it('alice purchases 1000 tokens', async() => {
		let gcnToken = await GoodCitizenNetworkToken.deployed();
		let gcnCrowdsale = await GoodCitizenNetworkCrowdsale.deployed();
		let purchaseValue = web3.toWei(1, 'ether');
		await gcnCrowdsale.buyTokens(aliceAddress, { from: aliceAddress, 
			value: purchaseValue, gas: '1000000' });
		let aliceBalance = await gcnCrowdsale.getBalanceForAddress(aliceAddress);
		// let testy = web3.fromWei((await gcnToken.balanceOf(aliceAddress)).toString(10), 'ether');
		// console.log('balance of: ' + await testy);
		assert.equal(web3.fromWei(aliceBalance, 'ether'), 1000, 
			'Alice balance != 1000');
	});
	it('Alice cannot call withdrawTokens because crowdsale is open', async() => {
		let gcnToken = await GoodCitizenNetworkToken.deployed();
		let gcnCrowdsale = await GoodCitizenNetworkCrowdsale.deployed();
		await expectThrow(gcnCrowdsale.withdrawTokens({from: aliceAddress}));
	});
	it('Owner closes crowdsale right now', async() => {
		let gcnToken = await GoodCitizenNetworkToken.deployed();
		let gcnCrowdsale = await GoodCitizenNetworkCrowdsale.deployed();
		console.log('Opening Time: ' + (await gcnCrowdsale.openingTime()).toString(10));
		gcnCrowdsale.setClosingTime(await gcnCrowdsale.openingTime()).toString(10);
		console.log('Closing Time: ' + (await gcnCrowdsale.closingTime()).toString(10));
		assert.equal((await gcnCrowdsale.openingTime()).toString(10), 
			(await gcnCrowdsale.closingTime()).toString(10), 'openingTime != closingTime');
	});
	it('Crowdsale should be closed', async() => {
		let gcnToken = await GoodCitizenNetworkToken.deployed();
		let gcnCrowdsale = await GoodCitizenNetworkCrowdsale.deployed();
		await increaseTime(10);
		console.log('Current Time: ' + await web3.eth.getBlock('latest').timestamp);
		assert.isTrue(await gcnCrowdsale.hasClosed(), 'hasClosed != true')
	});
	it('Alice withdraws tokens', async() => {
		let gcnToken = await GoodCitizenNetworkToken.deployed();
		let gcnCrowdsale = await GoodCitizenNetworkCrowdsale.deployed();
		await gcnCrowdsale.withdrawTokens({from: aliceAddress});
		let aliceBalance = web3.fromWei((await gcnToken.balanceOf(aliceAddress)).toString(10), 'ether');
		assert.equal(aliceBalance, 1000, 'alice balance != 1000');
	});

});