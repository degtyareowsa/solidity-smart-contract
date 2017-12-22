pragma solidity ^0.4.11;

import "./library/CappedCrowdsale.sol";
import "/zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "/zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./library/RefundableCrowdsale.sol";

/**
 * @title TNSPreSale
 * @dev This is an example of a fully fledged crowdsale.
 * The way to add new features to a base crowdsale is by multiple inheritance.
 * In this example we are providing following extensions:
 * CappedCrowdsale - sets a max boundary for raised funds
 * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
 *
 * After adding multiple features it's good practice to run integration tests
 * to ensure that subcontracts works together as intended.
 */
contract TNSCrowdSale is Ownable, Pausable, RefundableCrowdsale, CappedCrowdsale{

    uint256 public tokenSold;

    uint256 public preSaleEndTime;

    uint256[5] internal slabs = [5710000, 6680000, 22190000, 25220000, 26600000];

    function TNSCrowdSale(address _tokenAddress, uint256 _startTime, uint256 _preEndTime, uint256 _endTime, uint256 _rate, uint256 _cap, uint256 _goal, address _wallet)
    CappedCrowdsale(_cap)
    RefundableCrowdsale(_goal)
    Crowdsale(_tokenAddress, _startTime, _endTime, _rate, _wallet)
    {
        preSaleEndTime = _preEndTime;
    }

    function buyTokens(address beneficiary) public payable {
        require(beneficiary != 0x0);
        require(!paused);
        require(validPurchase());

        uint256 weiAmount = msg.value;

        // calculate token amount to be created
        uint256 tokens_temp = weiAmount.mul(rate);

        rate = appyDiscount(rate, tokens_temp);

        uint256 tokens = weiAmount.mul(rate);

        tokenSold = tokenSold.add(tokens);

        // update state
        weiRaised = weiRaised.add(weiAmount);

        token.issueTokens(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

        forwardFunds();
    }

    function appyDiscount(uint256 base_rate, uint256 t_tokens) internal returns (uint256) {
        uint256 tmp_tokens = tokenSold + t_tokens;

        if(tmp_tokens <= (slabs[0] * 1000000000000000000) && now <= preSaleEndTime){
            base_rate = discountPrice[0];
        }else if(tmp_tokens > (slabs[0] * 1000000000000000000) && now <= preSaleEndTime){
            base_rate = discountPrice[4];
        } else if(tmp_tokens < ((slabs[1] - slabs[0]) * 1000000000000000000) + tokenSold){
            base_rate = discountPrice[1];
        }else if(tmp_tokens < ((slabs[2] - slabs[0]) * 1000000000000000000) + tokenSold){
            base_rate = discountPrice[2];
        }else if(tmp_tokens < ((slabs[3] - slabs[0]) * 1000000000000000000) + tokenSold){
            base_rate = discountPrice[3];
        }else if(tmp_tokens < ((slabs[4] - slabs[0]) * 1000000000000000000) + tokenSold){
            base_rate = discountPrice[4];
        }

        return base_rate;
    }

    function updateDiscount(uint256 new_rate, uint256 index) public onlyOwner{
        require(index >= 0 && index < discountPrice.length);
        discountPrice[index] = new_rate;
        rate = appyDiscount(rate, tokenSold);
    }

    function getDiscountRate(uint256 index) external constant onlyOwner returns (uint256){
        require(index >= 0 && index < discountPrice.length);
        return discountPrice[index];
    }

    function updatePreSaleEndTime(uint256 newEndTime) public onlyOwner{
        require(tokenSold >= (slabs[0] * 1000000000000000000));
        preSaleEndTime = newEndTime;
    }

}