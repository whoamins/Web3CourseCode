// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract Storage {
    struct Player {
        string username;
        uint age;
        uint score;
        uint healthPoints;
    }

    mapping(address => Player) public players;
    event Log(string functionName, string message);

    function addPlayer(string memory _username, uint _age, uint _score, uint _healthPoints) public  {
        players[msg.sender] = Player(_username, _age, _score, _healthPoints);
        emit Log("addPlayer", "Player created");
    }

    function deletePlayer() public {
        delete players[msg.sender];
        emit Log("deletePlayer", "Player has been deleted");
    }

    function isMyUserExists() public view returns (bool) {
        string memory user = players[msg.sender].username;

        if (bytes(user).length > 0) {
            return true;
        }

        return false;
    }

    function getMyPlayer() public view returns (string memory) {
        return players[msg.sender].username;
    }
}
