// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";


contract ToAttack {
    mapping (address => uint) private userBalances;

    constructor() {
    }

    function depositETH() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function getUserBalance() view public returns (uint) {
        return userBalances[msg.sender] / 1 ether;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        (bool success,) = msg.sender.call{value:amountToWithdraw}("");
        require(success);
        userBalances[msg.sender] = 0;
    }
}