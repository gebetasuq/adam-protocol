// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../interfaces/IZKVerifier.sol";
import "./RewardDistributor.sol";

/// @title CampusGenesis
/// @notice Main ADAM Campus contract handling proof submission, BLq minting, and performance metrics.
contract CampusGenesis {
    address public admin;
    IZKVerifier public verifier;
    RewardDistributor public distributor;

    uint256 public totalParticipants;
    uint256 public totalBLq;
    uint256 public totalActions;

    struct Participant {
        bool registered;
        uint256 blqEarned;
        uint256 actions;
    }

    mapping(address => Participant) public participants;

    event ParticipantRegistered(address indexed user);
    event ProofVerified(address indexed user, uint256 reward, bool valid);
    event MetricsUpdated(uint256 totalParticipants, uint256 totalBLq, uint256 totalActions);
    event VerifierUpdated(address newVerifier);
    event DistributorUpdated(address newDistributor);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor(address _verifier, address _distributor) {
        admin = msg.sender;
        verifier = IZKVerifier(_verifier);
        distributor = RewardDistributor(_distributor);
    }

    /// @notice Register new participant (campus student or user)
    function register() external {
        require(!participants[msg.sender].registered, "Already registered");
        participants[msg.sender].registered = true;
        totalParticipants++;
        emit ParticipantRegistered(msg.sender);
    }

    /// @notice Submit proof and update campus metrics
    /// @param proof The encoded ZK-SNARK proof
    /// @param rewardAmount The BLq value reward for this proof
    function submitEnergyProof(bytes memory proof, uint256 rewardAmount) external {
        if (!participants[msg.sender].registered) {
            register();
        }

        bool valid = verifier.verifyProof(proof);
        emit ProofVerified(msg.sender, rewardAmount, valid);

        if (!valid) return;

        participants[msg.sender].blqEarned += rewardAmount;
        participants[msg.sender].actions += 1;
        totalBLq += rewardAmount;
        totalActions += 1;

        distributor.submitProof(proof, rewardAmount);

        emit MetricsUpdated(totalParticipants, totalBLq, totalActions);
    }

    /// @notice Returns current metrics
    function getMetrics()
        external
        view
        returns (uint256 participantsCount, uint256 totalBlq, uint256 actionsCount)
    {
        return (totalParticipants, totalBLq, totalActions);
    }

    /// @notice Admin: update verifier contract
    function updateVerifier(address newVerifier) external onlyAdmin {
        verifier = IZKVerifier(newVerifier);
        emit VerifierUpdated(newVerifier);
    }

    /// @notice Admin: update reward distributor contract
    function updateDistributor(address newDistributor) external onlyAdmin {
        distributor = RewardDistributor(newDistributor);
        emit DistributorUpdated(newDistributor);
    }
}
