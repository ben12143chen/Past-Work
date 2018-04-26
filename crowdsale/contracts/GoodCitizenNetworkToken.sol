pragma solidity ^0.4.18;


import "../node_modules/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";


/**
 * @title GoodCitizenNetworkToken
 * @dev Very simple ERC20 Token that can be minted.
 * It is meant to be used in a crowdsale contract.
 */
contract GoodCitizenNetworkToken is MintableToken {

  string public constant name = "Gold Good Citizen Token"; // solium-disable-line uppercase
  string public constant symbol = "GGCT"; // solium-disable-line uppercase
  uint8 public constant decimals = 18; // solium-disable-line uppercase

}