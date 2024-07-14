// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Base_Test } from "../../../../Base.t.sol";
import { Errors } from "../../../../utils/Errors.sol";

contract Sell_Unit_Concret_Test is Base_Test {
    function setUp() public virtual override {
        Base_Test.setUp();
    }

    function test_RevertWhen_ERC20InsufficientBalance() external {
        // Make Bob the caller for this test suite
        vm.startPrank({ msgSender: users.bob });

        // Set the amount of tokens to buy
        uint256 amount = 1500e18;

        // Expect the call to revert with the {ERC20InsufficientBalance} error
        vm.expectRevert(abi.encodeWithSelector(Errors.ERC20InsufficientBalance.selector, users.bob, 0, amount));

        // Run the test
        linearToken.sell(amount);
    }

    function test_Sell() external {
        // Make Bob the caller for this test suite
        vm.startPrank({ msgSender: users.bob });

        // Set the amount of tokens to buy
        uint256 amountToBuy = 1500e18;

        // Set the amount of tokens to sell
        uint256 amountToSell = 1000e18;

        // Get the price to purchase the desired amount of tokens
        uint256 buyPrice = linearToken.getPrice({ currentSupply: 0, newSupply: amountToBuy });

        // Buy these tokens for Bob
        linearToken.buy{ value: buyPrice }(amountToBuy);

        // Get the price at which Bob will sell his tokens
        uint256 sellPrice = linearToken.getPrice({ currentSupply: amountToBuy - amountToSell, newSupply: amountToBuy });

        // Run the test
        linearToken.sell(amountToSell);

        // Assert the actual and expected total supply
        assertEq(linearToken.totalSupply(), amountToBuy - amountToSell);

        // Assert the actual and expected balance of Bob
        assertEq(linearToken.balanceOf(users.bob), amountToBuy - amountToSell);

        // Assert the actual and expected ETH balance of the {ContinuousLinearToken}
        assertEq(address(linearToken).balance, buyPrice - sellPrice);
    }
}
