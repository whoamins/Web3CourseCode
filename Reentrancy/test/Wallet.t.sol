// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import "forge-std/Test.sol";
import "src/Wallet.sol";
import "src/AttackWallet.sol";


contract TestReentrancy is Test {
    using stdStorage for StdStorage;
    Wallet public wallet;
    AttackWallet public attackWallet;

    function setUp() public{
        wallet = new Wallet();
        attackWallet = new AttackWallet(payable(wallet));
        vm.deal(address(wallet), 10 ether);
        vm.deal(address(attackWallet), 2 ether);
    }

    function test_testSetup() public {  
        attackWallet.depositAttack();
        attackWallet.attack();
        console.log(address(attackWallet).balance);
    }
} 
