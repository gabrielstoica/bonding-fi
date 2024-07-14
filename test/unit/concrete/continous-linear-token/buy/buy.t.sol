// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Base_Test } from "../../../../Base.t.sol";
import { Errors } from "../../../../utils/Errors.sol";

contract Buy_Unit_Concret_Test is Base_Test {
    function setUp() public virtual override {
        Base_Test.setUp();
    }

    function test_RevertWhen_InsufficientPaymentAmount() external {
        // Make Bob the caller for this test suite
        vm.startPrank({ msgSender: users.bob });

        // Set the amountToBuy of tokens to buy
        uint256 amountToBuy = 1500e18;

        // Expect the call to revert with the {InsufficientPaymentAmount} error
        vm.expectRevert(Errors.InsufficientPaymentAmount.selector);

        // Run the test
        linearToken.buy{ value: 1 ether }(amountToBuy);
    }

    function test_Buy() external {
        // Make Bob the caller for this test suite
        vm.startPrank({ msgSender: users.bob });

        // Set the amount of tokens to buy
        uint256 amountToBuy = 1500e18;

        // Get the price for the purchase of the `amountToBuy`
        uint256 price = linearToken.getPrice({ currentSupply: 0, newSupply: amountToBuy });

        // Run the test
        linearToken.buy{ value: price }(amountToBuy);

        // Assert the actual and expected total supply
        assertEq(linearToken.totalSupply(), amountToBuy);

        // Assert the actual and expected balance of Bob
        assertEq(linearToken.balanceOf(users.bob), amountToBuy);

        // Assert the actual and expected ETH balance of the {ContinuousLinearToken}
        assertEq(address(linearToken).balance, price);
    }
}
