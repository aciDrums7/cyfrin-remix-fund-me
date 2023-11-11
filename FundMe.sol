// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    uint256 public minimumUsd = 5e18; // 5 000 000 000 000 000 000

    address public owner;

    // Called in the same tx that deploys the contract
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Sender is not ownwer");
        _;
    }

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

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);

        // withdraw all the funds (https://solidity-by-example.org/sending-ether/):
        // transfer (2300 gas, throws error)
        // payable(msg.sender).transfer(address(this).balance);

        // send (2300 gas, returns bool)
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call (forward all gas or set gas, returns bool)
        (
            bool callSuccess, /* bytes memory dataReturned */

        ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Send failed");
    }
}
