// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Base_Test } from "./Base.t.sol";

contract ContinuousToken is Base_Test {
    function setUp() public virtual override {
        Base_Test.setUp();
    }

    function test_Buy() external {
        // Make Bob the caller for the next suite of tests
        vm.startPrank({ msgSender: users.bob });

        // Set the amount of tokens to buy
        uint256 amount = 1500e18;

        // Get the current supply
        uint256 totalSupply = continuousToken.totalSupply();

        // Get the price for the purchase of the `amount`
        uint256 price = continuousToken.getPrice({ currentSupply: totalSupply, newSupply: totalSupply + amount });

        // Run the test
        continuousToken.buy{ value: price }(amount);

        // Assert the actual and expected total supply
        assertEq(continuousToken.totalSupply(), amount);

        // Assert the actual and expected ETH balance of the {ContinuousToken}
        assertEq(address(continuousToken).balance, price);
    }

    function test_GetCurrentPrice() external {
        // Make Bob the caller for the next suite of tests
        vm.startPrank({ msgSender: users.bob });

        uint256 totalSupply = 1500e18;

        // Get the current price simulating that there are `totalSupply` tokens in the pool
        uint256 actualPrice = continuousToken.getCurrentPrice({ currentSupply: totalSupply });

        // Based on the linear curve formula
        // f(x) = a + b*x, replacing x with 1500, a (initial price) with 1 and b (slope) with 0.0005
        // results in f(1500) = 1 + 0.0005*1500 = 1.75
        uint256 expectedPrice = 1.75e18;

        // Asser the actual and expected price
        assertEq(actualPrice, expectedPrice);
    }
}
