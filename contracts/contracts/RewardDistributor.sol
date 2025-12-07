// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../interfaces/IZKVerifier.sol";

/// @title RewardDistributor
/// @notice Escrow + reward distribution contract for BLq credits.
///         A student submits a ZK proof → verifier validates → contract releases reward.
contract RewardDistributor {

    address public admin;
    IZKVerifier public verifier;

    mapping(address => uint256) public pendingRewards;
    mapping(address => uint256) public claimedRewards;

    event ProofSubmitted(address indexed user, uint256 reward, bool isValid);
    event RewardClaimed(address indexed user, uint256 amount);
    event AdminUpdated(address indexed newAdmin);
    event VerifierUpdated(address indexed newVerifier);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor(address _verifier) {
        admin = msg.sender;
        verifier = IZKVerifier(_verifier);
    }

    /// @notice Student submits proof to earn BLq reward units.
    function submitProof(bytes memory proof, uint256 rewardAmount) external {
        bool valid = verifier.verifyProof(proof);

        emit ProofSubmitted(msg.sender, rewardAmount, valid);

        if (!valid) return;

        pendingRewards[msg.sender] += rewardAmount;
    }

    /// @notice Claim your accumulated payout.
    function claimReward() external {
        uint256 amount = pendingRewards[msg.sender];
        require(amount > 0, "Nothing to claim");

        pendingRewards[msg.sender] = 0;
        claimedRewards[msg.sender] += amount;

        emit RewardClaimed(msg.sender, amount);
    }

    /// @notice Admin can update verifier if needed.
    function setVerifier(address _new) external onlyAdmin {
        verifier = IZKVerifier(_new);
        emit VerifierUpdated(_new);
    }

    /// @notice Transfer admin role.
    function updateAdmin(address _newAdmin) external onlyAdmin {
        admin = _newAdmin;
        emit AdminUpdated(_newAdmin);
    }
}
