pragma solidity ^0.4.18;

import "./GoodCitizenNetworkToken.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/validation/IndividuallyCappedCrowdsale.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "../node_modules/zeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol";



/**
 * @title GoodCitizenNetworkCrowdsale
 * @dev This is an example of a fully fledged crowdsale.
 * The way to add new features to a base crowdsale is by multiple inheritance.
 * In this example we are providing following extensions:
 * CappedCrowdsale - sets a max boundary for raised funds
 * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
 *
 * After adding multiple features it's good practice to run integration tests
 * to ensure that subcontracts works together as intended.
 */
contract GoodCitizenNetworkCrowdsale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale, IndividuallyCappedCrowdsale, PostDeliveryCrowdsale {

  // Cap for individual purchase
  uint256 private individualCap;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function GoodCitizenNetworkCrowdsale(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, uint256 _cap, uint256 _goal) public
    Crowdsale(_startTime, _endTime, _rate, _wallet)
    CappedCrowdsale(_cap)
    TimedCrowdsale(_openingTime, _closingTime)
    RefundableCrowdsale(_goal)
  {
    //As goal needs to be met for a successful crowdsale
    //the value needs to less or equal than a cap which is limit for accepted funds
    require(_goal <= _cap);
  }

  function createTokenContract() internal returns (MintableToken) {
    return new GoodCitizenNetworkToken(); 
  }

  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
    //require(_beneficiary != address(0));
    //require(_weiAmount != 0);
    //require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);
    //require(weiRaised.add(_weiAmount) <= cap);
  }

  function setClosingTime(uint256 time) onlyOwner {
    //require(time >= now);
    closingTime = time;
  }

  function getClosingTime() external view returns (uint256) {
    return closingTime;
  }

  function getBalanceForAddress(address _beneficiary) external view returns (uint256) {
    return balances[_beneficiary];
  }
}
