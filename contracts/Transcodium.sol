pragma solidity ^0.4.11;


import "/zeppelin-solidity/contracts/token/MintableToken.sol";
import "/zeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */
contract Transcodium is Ownable, StandardToken  {

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

    function issueTokens(address _to, uint256 _value) public onlyOwner {
        balances[tokenIssuer] = balances[tokenIssuer].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(tokenIssuer, _to, _value);
    }

    function changeTokenIssuer(address newTokenIssuer) public onlyOwner {
        tokenIssuer = newTokenIssuer;
    }

}