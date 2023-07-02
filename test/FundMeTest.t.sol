// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundme = new DeployFundMe();
        fundMe = deployFundme.run();
    }

    function testFail_CantFundWithInsufficientValueSent() public {
        fundMe.fund();
    }

    function testCantFundWithInsufficientValueSent() public {
        try fundMe.fund() {
            // Did not revert in called func
            revert();
        } catch {}
    }
}
