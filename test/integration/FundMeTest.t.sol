// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {Fund, Withdraw} from "../../script/Interactions.s.sol";
import {console} from "forge-std/console.sol";

contract FundMeIntegrationTest is Test {
    event Funded(address indexed funder, uint256 amount);

    FundMe fundMe;
    address USER = address(1);
    uint256 FUND_AMOUNT = 0.001 ether;
    uint256 public constant STARTING_USER_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundme = new DeployFundMe();
        fundMe = deployFundme.run();
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    function testFundAndWithdraw() public {
        /*
        GIVEN: fundMe contract
        WHEN: fund is called with sufficient value then it is withdrawn
        THEN: Fund is withdrawn
        */
        uint256 initBalance = address(fundMe).balance;
        Fund fund = new Fund();
        fund.fund(address(fundMe));
        assert(address(fundMe).balance > initBalance);

        Withdraw withdraw = new Withdraw();
        withdraw.withdraw(address(fundMe));
        assert(address(fundMe).balance == 0);
    }
}
