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
    address USER;
    uint256 constant STARTING_BALANCE = 100 ether;
    uint256 constant DEFAULT_VALUE_TO_FUND = 12 ether;

    function setUp() public {
        deployer = new DeployFundMe();
        (fundMe, helperConfig) = deployer.run();
        USER = makeAddr("user");
        vm.deal(USER, STARTING_BALANCE);
    }

    function test_WithdrawFailsIfNotOwner() public {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function test_WithdrawFundsAsOwner() public {
        fundMe.fund{value: DEFAULT_VALUE_TO_FUND}();
        uint256 initialBalance = address(fundMe.i_owner()).balance;
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();

        assertEq(address(fundMe.i_owner()).balance, initialBalance + DEFAULT_VALUE_TO_FUND);
    }

    function test_MinimumDepositIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function test_OwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function test_PriceFeedSetCorrectly() public {
        address retreivedPriceFeed = address(fundMe.getPriceFeed());
        address expectedPriceFeed = helperConfig.activeNetworkConfig();
        assertEq(retreivedPriceFeed, expectedPriceFeed);
    }

    function test_FundFailIfAmountNotEnough() public {
        vm.expectRevert();
        fundMe.fund(); // send 0 ether;
    }

    function test_FundSuccess() public {
        vm.prank(USER);
        fundMe.fund{value: DEFAULT_VALUE_TO_FUND}();
        assertEq(fundMe.addressToAmountFunded(USER), DEFAULT_VALUE_TO_FUND);
        assertEq(fundMe.funders(0), USER);
    }

    function test_ReceiveFunction() public payable {
        vm.prank(USER);
        (bool success, ) = address(fundMe).call{value: DEFAULT_VALUE_TO_FUND}("");
        assertTrue(success, "Receive function failed");
        assertEq(fundMe.addressToAmountFunded(USER), DEFAULT_VALUE_TO_FUND);
        assertEq(fundMe.funders(0), USER);
    }
}