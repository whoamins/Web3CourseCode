// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract Storage {
    struct Player {
        string username;
        uint age;
        uint score;
        uint healthPoints;
    }

    mapping(address => Player) players;
    event Log(string functionName, string message);

    function addPlayer(string memory _username, uint _age, uint _score, uint _healthPoints) public  {
        players[msg.sender] = Player(_username, _age, _score, _healthPoints);
        emit Log("addPlayer", "Player created");
    }

    function deletePlayer() public {
        delete players[msg.sender];
        emit Log("deletePlayer", "Player has been deleted");
    }
}
