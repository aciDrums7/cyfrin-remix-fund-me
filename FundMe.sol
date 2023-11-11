// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minimumUsd = 5e18; // 5 000 000 000 000 000 000

    function fund() public payable {
        // Allow to send $
        // Have a minimum $ send
        // 1) How to send ETH to this contract?
        require(getEthAmountInUsd(msg.value) >= minimumUsd, "didn't send enough ETH"); // 1e18 Wei = 1 ETH = 1 00000 00000 00000 000 (18 zeros)
        // What is a revert?
        // Undo any actions that have been done, and send the remaing gas back

        //... a ton of computation
    }

    function getCurrentEthPriceInUsd() public view returns (uint256 currentEthPriceInUsd) {
        // Contract Address -> 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        // prettier-ignore
        (
            /* uint80 roundID */,
            int256 price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        // 'price' has just 8 'decimal' numbers, to align with Wei (1 ETH = 1e18 Wei) we need to multiply for 1e10
        return uint256(price * 1e10); // 2073 366 890 910 000 000 000
    }

    function getEthAmountInUsd(uint256 _ethAmount) public view returns (uint256 ethAmountInUsd) {
        // ALWAYS MULTIPLY BEFORE DIVIDE!!! -> 1 /2 = 0 (in solidity, we work just with integer numbers)
        return (getCurrentEthPriceInUsd() * _ethAmount) / 1e18; // (n * 1e18) * (m * 1e18) / 1e18 = n * m * 1e18
    }

    // function withdraw() public {}

    function getVersion() public view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
    }
}
