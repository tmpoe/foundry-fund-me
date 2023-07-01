// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library EthToUsdConverter {
    function convert(uint256 weiAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        return (weiAmount * ethPrice) / (1e18);
    }

    function getPrice() private view returns (uint256) {
        AggregatorV3Interface dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int answer, , , ) = dataFeed.latestRoundData();
        // for some reason 10**11 is needed to get the correct value
        return uint256(answer) * 10**11;
    }
}
