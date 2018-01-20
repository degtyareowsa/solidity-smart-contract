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

    event TokenIssued(address indexed from, address indexed to, uint256 value);
    string public constant name = "Transcodium";
    string public constant symbol = "TNS";
    uint8 public constant decimals = 18;

    address public tokenIssuer;

    uint256 public constant INITIAL_SUPPLY = 120000000 * (10 ** uint256(decimals));

    function Transcodium() {
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        tokenIssuer = msg.sender;
    }

    function issueTokens(address _to, uint256 _value) public {
        require(msg.sender == tokenIssuer);
        require(balances[owner] > _value);

        balances[owner] = balances[owner].sub(_value);
        balances[_to] = balances[_to].add(_value);
        TokenIssued(tokenIssuer, _to, _value);
    }

    function changeTokenIssuer(address newTokenIssuer) public onlyOwner {
        tokenIssuer = newTokenIssuer;
    }

}