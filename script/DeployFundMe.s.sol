// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {Config} from "./Config.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // send to RPC - transactions - will cost gas
        Config config = new Config();
        address priceFeedAddress = config.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(5, priceFeedAddress);
        vm.stopBroadcast();
        return fundMe;
    }
}
