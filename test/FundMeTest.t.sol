// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {console} from "forge-std/console.sol";

contract FundMeTest is Test {
    event Funded(address indexed funder, uint256 amount);

    FundMe fundMe;
    address USER = address(1);
    uint256 FUND_AMOUNT = 4e10;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundme = new DeployFundMe();
        fundMe = deployFundme.run();
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    function testFail_CantFundWithInsufficientValueSent() public {
        /*
        GIVEN: fundMe contract
        WHEN: fund is called with insufficient value
        THEN: It reverts
        */
        fundMe.fund();
    }

    function testCantFundWithInsufficientValueSentVM() public {
        /*
        GIVEN: fundMe contract
        WHEN: fund is called with insufficient value
        THEN: It reverts
        */
        vm.expectRevert();
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

    function testCanWithdraw() public funded {
        /* 
        GIVEN: fundMe contract
        WHEN: withdraw is called
        THEN: fundMe contract balance is 0
        */

        vm.startPrank(fundMe.owner());
        fundMe.withdraw();
        vm.stopPrank();

        assertEq(address(fundMe).balance, 0);
    }

    function testFail_CantWithdrawFromNonOwnerAccount() public funded {
        /* 
        GIVEN: fundMe contract
        WHEN: withdraw is called
        THEN: it reverts
        */

        fundMe.withdraw();
    }

    function testFunderSaved() public funded {
        /*
        GIVEN: fundMe contract
        WHEN: fund is called
        THEN: funder is saved
        */
        assertEq(fundMe.getAmountFundedForUser(USER), FUND_AMOUNT);
        assertEq(fundMe.getFunder(0), USER);
    }

    modifier funded() {
        vm.startPrank(USER);
        uint256 initBalance = address(fundMe).balance;
        vm.expectEmit(address(fundMe));
        emit Funded(USER, FUND_AMOUNT);
        fundMe.fund{value: FUND_AMOUNT}();
        assert(address(fundMe).balance > initBalance);
        _;
    }
}
