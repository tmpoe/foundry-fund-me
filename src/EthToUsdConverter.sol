// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {console} from "forge-std/console.sol";

library EthToUsdConverter {
    function convert(uint256 weiAmount, address priceFeedAddress)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice(priceFeedAddress);
        return (weiAmount * ethPrice) / (1e18);
    }

    function getPrice(address priceFeedAddress) private view returns (uint256) {
        AggregatorV3Interface dataFeed = AggregatorV3Interface(
            priceFeedAddress
        );
        console.log("kutya");
        console.log(priceFeedAddress);
        console.log(address(dataFeed));
        (, int answer, , , ) = dataFeed.latestRoundData();
        // for some reason 10**11 is needed to get the correct value
        return uint256(answer) * 10**11;
    }
}
