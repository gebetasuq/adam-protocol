// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title RewardDistributor
/// @notice Simple UIC reward escrow for BLq holders.
contract RewardDistributor {
    address public admin;
    mapping(address => uint256) public uicBalance;

    event Funded(address indexed from, uint256 amount);
    event RewardAssigned(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    // fund the reward pool (purely accounting in demo)
    function fund(uint256 amount) external onlyAdmin {
        emit Funded(msg.sender, amount);
    }

    function assignReward(address user, uint256 amount) external onlyAdmin {
        uicBalance[user] += amount;
        emit RewardAssigned(user, amount);
    }

    function claim() external {
        uint256 amount = uicBalance[msg.sender];
        require(amount > 0, "Nothing to claim");

        uicBalance[msg.sender] = 0;
        emit RewardClaimed(msg.sender, amount);

        // In real deployment, transfer stablecoin here.
    }
}
