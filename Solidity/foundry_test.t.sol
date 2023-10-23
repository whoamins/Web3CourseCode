// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Storage} from "../src/Storage.sol";


contract CounterTest is Test {
    Storage public playerStorage;

    function setUp() public {
        playerStorage = new Storage();
        playerStorage.addPlayer("test_username", 123, 1337, 100);
    }

    function test_PlayerInStorage() public {
        assertEq(playerStorage.getMyPlayer(), "test_username");
    }

    function test_DeleteUser() public {
        playerStorage.deletePlayer();
        assertEq(playerStorage.doesMyUserExists(), false);
    }
}
