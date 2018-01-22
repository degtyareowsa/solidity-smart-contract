pragma solidity ^0.4.11;


import "/zeppelin-solidity/contracts/token/StandardToken.sol";
import "/zeppelin-solidity/contracts/token/BurnableToken.sol";
import "/zeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title Transcodium
 * @dev Transcodium is the original token that will be used across the Transcodium platform.
 * This is a Burnable token with a supply of 120mn
 */
contract Transcodium is Ownable, StandardToken, BurnableToken  {

    string public constant name = "Transcodium";
    string public constant symbol = "TNS";
    uint8 public constant decimals = 18;

    uint256 public constant INITIAL_SUPPLY = 120000000 * (10 ** uint256(decimals));

    function Transcodium() {
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }

}