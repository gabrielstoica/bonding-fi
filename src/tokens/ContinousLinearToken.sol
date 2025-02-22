// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { LinearCurve } from "./../curves/LinearCurve.sol";

/// @title ContinuousLinearToken
contract ContinuousLinearToken is ERC20, LinearCurve {
    error InsufficientPaymentAmount();
    error SaleFailed();

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _slope,
        uint256 _initialPrice
    ) ERC20(_name, _symbol) LinearCurve(_slope, _initialPrice) { }

    function buy(uint256 amount) public payable {
        // Calculates the price that must be paid for `amount` of tokens
        uint256 totalSupply = totalSupply();
        uint256 price = getPrice(totalSupply, totalSupply + amount);

        // Checks: the amount of native token is high enough to pay for the requested amount of tokens
        if (msg.value < price) {
            revert InsufficientPaymentAmount();
        }

        // Interactions: mint the purchased amount of tokens
        _mint({ account: msg.sender, value: amount });
    }

    function sell(uint256 amount) public {
        // Store the current total supply
        uint256 totalSupply = totalSupply();

        // Checks, Effects, Interactions: burn the sold amount of tokens
        _burn({ account: msg.sender, value: amount });

        // Calculate the amount of native token (ETH) to receive
        uint256 price = getPrice(totalSupply - amount, totalSupply);

        // Interactions: pay the seller
        (bool success,) = payable(msg.sender).call{ value: price }("");
        if (!success) revert SaleFailed();
    }
}
