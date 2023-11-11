// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getCurrentEthPriceInUsd()
        internal
        view
        returns (uint256 currentEthPriceInUsd)
    {
        // using a library -> msg.sender.getCurrentEthPriceInUsd()
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

    // The type of the 1st param will be the type for which use the library
    function getEthAmountInUsd(uint256 _ethAmount)
        internal
        view
        returns (uint256 ethAmountInUsd)
    {
        // ALWAYS MULTIPLY BEFORE DIVIDE!!! -> 1 /2 = 0 (in solidity, we work just with integer numbers)
        return (getCurrentEthPriceInUsd() * _ethAmount) / 1e18; // (n * 1e18) * (m * 1e18) / 1e18 = n * m * 1e18
    }

    function getVersion() internal view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
    }
}
