// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract FundMe {
    function fund() public payable {
        // Allow to send $
        // Have a minimum $ send
        // 1) How to send ETH to this contract?
        require (msg.value > 1e18, "didn't send enough ETH"); // 1e18 Wei = 1 ETH = 1 00000 00000 00000 000 (18 zeros)
    }

    // function withdraw() public {}
}