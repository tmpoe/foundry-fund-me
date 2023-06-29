// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../script/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe(5);
    }

    function testi() public {
        assertEq(fundMe.i_minFundUSD(), 5);
    }
}
