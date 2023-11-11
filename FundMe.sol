// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minimumUsd = 5;

    function fund() public payable {
        // Allow to send $
        // Have a minimum $ send
        // 1) How to send ETH to this contract?
        require(msg.value > 1e18, "didn't send enough ETH"); // 1e18 Wei = 1 ETH = 1 00000 00000 00000 000 (18 zeros)
        // What is a revert?
        // Undo any actions that have been done, and send the remaing gas back

        //... a ton of computation
    }

    function getPrice() public view {
        // Contract Address -> 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
    }

    function getVersion() public view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
    }

    function getConversionRate() public {}

    // function withdraw() public {}
}
