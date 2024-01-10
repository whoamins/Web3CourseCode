// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    function run() external returns(FundMe, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        address ethUsedPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsedPriceFeed);
        vm.stopBroadcast();

        return (fundMe, helperConfig);
    }
}