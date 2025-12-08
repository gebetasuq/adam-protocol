// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./IZKVerifier.sol";

/**
 * @title RewardDistributor
 * @notice Simple reward escrow for BLq holders based on verified behavior.
 */
contract RewardDistributor {
    address public admin;
    IZKVerifier public verifier;
    IERC20 public blqToken;

    struct RewardPool {
        uint256 totalAllocated;
        uint256 totalClaimed;
        mapping(address => uint256) allocatedTo;
        mapping(address => uint256) claimedBy;
    }

    // Example: one pool per campaign (campus, city, etc.)
    mapping(bytes32 => RewardPool) private pools;

    event PoolFunded(bytes32 indexed poolId, uint256 amount);
    event RewardAllocated(bytes32 indexed poolId, address indexed user, uint256 amount);
    event RewardClaimed(bytes32 indexed poolId, address indexed user, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor(address _verifier, address _blqToken) {
        admin = msg.sender;
        verifier = IZKVerifier(_verifier);
        blqToken = IERC20(_blqToken);
    }

    function setVerifier(address _verifier) external onlyAdmin {
        verifier = IZKVerifier(_verifier);
    }

    function fundPool(bytes32 poolId, uint256 amount) external onlyAdmin {
        require(amount > 0, "amount = 0");
        blqToken.transferFrom(msg.sender, address(this), amount);
        pools[poolId].totalAllocated += amount;
        emit PoolFunded(poolId, amount);
    }

    function allocateReward(
        bytes32 poolId,
        address user,
        uint256 amount,
        bytes calldata zkProof
    ) external onlyAdmin {
        require(verifier.verifyProof(zkProof), "Invalid proof");
        RewardPool storage pool = pools[poolId];

        pool.allocatedTo[user] += amount;
        pool.totalAllocated += amount;

        emit RewardAllocated(poolId, user, amount);
    }

    function claim(bytes32 poolId) external {
        RewardPool storage pool = pools[poolId];

        uint256 entitled = pool.allocatedTo[msg.sender];
        uint256 alreadyClaimed = pool.claimedBy[msg.sender];

        uint256 claimable = entitled - alreadyClaimed;
        require(claimable > 0, "Nothing to claim");

        pool.claimedBy[msg.sender] += claimable;
        pool.totalClaimed += claimable;

        blqToken.transfer(msg.sender, claimable);
        emit RewardClaimed(poolId, msg.sender, claimable);
    }
}

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}
