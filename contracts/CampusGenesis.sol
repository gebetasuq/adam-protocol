// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IZKVerifier {
    function verifyProof(bytes memory proof) external returns (bool);
}

contract CampusGenesis {
    address public admin;
    IZKVerifier public verifier;

    uint256 public totalBLqMinted;
    uint256 public totalParticipants;

    mapping(address => uint256) public userBLq;
    mapping(address => uint256) public userRewards;
    mapping(address => uint256) public userContributions;

    event ProofVerified(address indexed user, uint256 blqAmount, uint256 reward);

    constructor(address _verifier) {
        admin = msg.sender;
        verifier = IZKVerifier(_verifier);
    }

    function submitEnergyProof(bytes calldata zkProof) external {
        require(verifier.verifyProof(zkProof), "Invalid ZK proof");

        uint256 blqAmount = 10; // demo amount
        userBLq[msg.sender] += blqAmount;
        totalBLqMinted += blqAmount;

        uint256 reward = blqAmount * 100; // 100 UIC per BLq (demo)
        userRewards[msg.sender] += reward;

        userContributions[msg.sender] += 1;
        totalParticipants += 1;

        emit ProofVerified(msg.sender, blqAmount, reward);
    }

    function getMetrics()
        external
        view
        returns (uint256 participants, uint256 totalBLq, uint256 avgContribution)
    {
        participants = totalParticipants;
        totalBLq = totalBLqMinted;
        avgContribution = totalParticipants > 0
            ? totalBLqMinted / totalParticipants
            : 0;
    }
}