// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HemiGravityDrop {
    struct ScoreEntry {
        address player;
        uint256 score;
        uint256 timestamp;
    }

    mapping(address => uint256) public personalBest;
    ScoreEntry[15] public leaderboard;
    uint256 public leaderboardLength;
    uint256 public constant MAX_SCORE = 50000;

    event ScoreSubmitted(address indexed player, uint256 score, uint256 timestamp);
    event NewPersonalBest(address indexed player, uint256 score);

    function submitScore(uint256 score) external {
        require(score > 0, "Score must be greater than 0");
        require(score <= MAX_SCORE, "Score too high");

        if (score > personalBest[msg.sender]) {
            personalBest[msg.sender] = score;
            emit NewPersonalBest(msg.sender, score);
        }

        _updateLeaderboard(msg.sender, score);
        emit ScoreSubmitted(msg.sender, score, block.timestamp);
    }

    function _updateLeaderboard(address player, uint256 score) internal {
        if (leaderboardLength < 15 || score > leaderboard[leaderboardLength - 1].score) {
            uint256 insertIndex = leaderboardLength;
            for (uint256 i = 0; i < leaderboardLength; i++) {
                if (score > leaderboard[i].score) {
                    insertIndex = i;
                    break;
                }
            }

            uint256 maxIndex = leaderboardLength < 15 ? leaderboardLength : 14;
            for (uint256 i = maxIndex; i > insertIndex; i--) {
                leaderboard[i] = leaderboard[i - 1];
            }

            leaderboard[insertIndex] = ScoreEntry({
                player: player,
                score: score,
                timestamp: block.timestamp
            });

            if (leaderboardLength < 15) {
                leaderboardLength++;
            }
        }
    }

    function getLeaderboard() external view returns (ScoreEntry[15] memory, uint256) {
        return (leaderboard, leaderboardLength);
    }

    function getPersonalBest(address player) external view returns (uint256) {
        return personalBest[player];
    }

    function getPlayerRank(address player) external view returns (uint256) {
        for (uint256 i = 0; i < leaderboardLength; i++) {
            if (leaderboard[i].player == player) {
                return i + 1;
            }
        }
        return 0;
    }
}
Crea il file, incolla questo codice e fai il commit.




