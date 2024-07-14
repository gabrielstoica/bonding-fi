// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library Errors {
    error InsufficientPaymentAmount();
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error SaleFailed();
}
