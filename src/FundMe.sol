// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {EthToUsdConverter} from "./EthToUsdConverter.sol";
import {console} from "forge-std/console.sol";

error FundMe__TooLowFundSent();
error FundMe__WithDrawFailed();

contract FundMe is Ownable {
    using EthToUsdConverter for uint256;

    event Funded(address indexed funder, uint256 amount);

    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;
    uint256 public immutable i_minFundUSD;
    address public immutable i_priceFeedAddress;

    constructor(uint256 minFundUSD, address priceFeedAddress)
        Ownable(msg.sender)
    {
        console.log("called");
        console.log(msg.sender);
        i_minFundUSD = minFundUSD;
        i_priceFeedAddress = priceFeedAddress;
    }

    function fund() public payable {
        if (msg.value.convert(i_priceFeedAddress) < i_minFundUSD) {
            revert FundMe__TooLowFundSent();
        }

        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);

        emit Funded(msg.sender, msg.value);
    }

    function withdraw() public payable onlyOwner {
        // call will not run out of gas, transfer could and I would not want to have the funds get stuck
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!success) {
            revert FundMe__WithDrawFailed();
        }
    }

    function getAmountFundedForUser(address user)
        public
        view
        returns (uint256)
    {
        return s_addressToAmountFunded[user];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getNumberOfFunders() public view returns (uint256) {
        return s_funders.length;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
