// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FPVRushDroneRacing {
    struct Racer {
        address racer;
        uint256 skill;
        uint256 lastRaceBlock;
    }

    mapping(address => Racer) public racers;
    address[] public leaderboard;
    uint256 public raceCount;

    event Registered(address indexed racer);
    event RaceFinished(address indexed racer, uint256 skill, bool winner);

    function register() external {
        require(racers[msg.sender].racer == address(0), "Already registered");

        racers[msg.sender] = Racer({
            racer: msg.sender,
            skill: 0,
            lastRaceBlock: 0
        });

        emit Registered(msg.sender);
    }

    function race() external {
        Racer storage player = racers[msg.sender];
        require(player.racer != address(0), "Not registered");
        require(block.number > player.lastRaceBlock, "Wait next block");

        // Simulate racing skill (pseudo-random)
        uint256 randomSkill = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, raceCount))
        ) % 100;

        player.skill = randomSkill;
        player.lastRaceBlock = block.number;
        raceCount++;

        // Add to leaderboard if skill is high enough (e.g. above 75)
        bool winner = false;
        if (randomSkill >= 75) {
            leaderboard.push(msg.sender);
            winner = true;
        }

        emit RaceFinished(msg.sender, randomSkill, winner);
    }

    function getLeaderboard() external view returns (address[] memory) {
        return leaderboard;
    }
}
