pragma solidity ^0.4.11;

/**
 * @title AbstractToken
 * @dev AbstractToken is a interface token for the pre & main crowdsale contracts
 * to invoke the already deployed AlloyToken
 */
contract AbstractToken {

    function issueTokens(address _to, uint256 _value) public;
    function transferOwnership(address newOwner) public;
    function finishMinting() public returns (bool);

}