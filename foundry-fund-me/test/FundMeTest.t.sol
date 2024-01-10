// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";


contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployer;
    HelperConfig helperConfig;

    function setUp() public {
        deployer = new DeployFundMe();
        (fundMe, helperConfig) = deployer.run();
    }

    function test_MinimumDepositIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function test_OwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedSetCorrectly() public {
        address retreivedPriceFeed = address(fundMe.getPriceFeed());
        console.log(retreivedPriceFeed);
        // (address expectedPriceFeed) = helperConfig.activeNetworkConfig();
        address expectedPriceFeed = helperConfig.activeNetworkConfig();
        console.log(expectedPriceFeed);
        assertEq(retreivedPriceFeed, expectedPriceFeed);
    }
}