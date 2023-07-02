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
        /*
        GIVEN: fundMe contract
        WHEN: fund is called with insufficient value
        THEN: It reverts
        */
        fundMe.fund();
    }

    function testCantFundWithInsufficientValueSent() public {
        /*
        GIVEN: fundMe contract
        WHEN: fund is called with insufficient value
        THEN: It reverts
        */
        try fundMe.fund() {
            // Did not revert in called func
            revert();
        } catch {}
    }

    function testCanFund() public {
        /* 
        GIVEN: fundMe contract
        WHEN: fund is called with sufficient value
        THEN: fundMe contract balance is increased by value
        */

        assertEq(address(fundMe).balance, 0);
        fundMe.fund{value: 4e10}();
        assertEq(address(fundMe).balance, 4e10);
    }
}
