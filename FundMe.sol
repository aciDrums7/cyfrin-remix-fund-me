// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18; // 5 000 000 000 000 000 000

    address public immutable i_owner;

    // Called in the same tx that deploys the contract
    constructor() {
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        // Allow to send $
        // Have a minimum $ send
        // 1) How to send ETH to this contract?
        require(
            msg.value.getEthAmountInUsd() >= MINIMUM_USD,
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

    // What happens if someone sends this contract ETH without calling the fund() function?

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
