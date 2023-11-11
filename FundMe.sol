// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    uint256 public minimumUsd = 5e18; // 5 000 000 000 000 000 000

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        // Allow to send $
        // Have a minimum $ send
        // 1) How to send ETH to this contract?
        require(
            msg.value.getEthAmountInUsd() >= minimumUsd,
            "didn't send enough ETH"
        ); // 1e18 Wei = 1 ETH = 1 000 000 000 000 000 000 (18 zeros)
        // What is a revert?
        // Undo any actions that have been done, and send the remaing gas back

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    // function withdraw() public {}
}
