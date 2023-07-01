// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // send to RPC - transactions - will cost gas
        vm.startBroadcast();
        FundMe fundMe = new FundMe(
            5,
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        vm.stopBroadcast();
        return fundMe;
    }
}
