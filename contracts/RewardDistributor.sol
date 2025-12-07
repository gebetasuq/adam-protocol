// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
 * @title RewardDistributor
 * @notice Distributes UIC rewards to users based on BLq earned.
 *
 *         BLq = verified positive impact
 *         UIC = reward currency of the ADAM Mesh
 *
 *         This contract pulls BLq balances from BLqMinter, calculates
 *         proportional rewards, and safely transfers UIC.
 */

interface IBLqMinter {
    function blqBalance(address user) external view returns (uint256);
}

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract RewardDistributor {
    
    // ---------------------------------------------------------
    // STATE
    // ---------------------------------------------------------

    address public admin;
    address public treasury;

    IERC20 public uicToken;           // Reward currency (UIC)
    IBLqMinter public blqMinter;      // Reference to BLqMinter contract

    uint256 public totalDistributed;  // Total UIC distributed
    uint256 public rewardPerBLq = 100; // 1 BLq = 100 UIC (default demo multiplier)

    mapping(address => uint256) public claimedRewards; // Track past payouts

    // ---------------------------------------------------------
    // EVENTS
    // ---------------------------------------------------------

    event RewardsClaimed(address indexed user, uint256 uicAmount, uint256 timestamp);
    event RewardRateUpdated(uint256 oldRate, uint256 newRate);
    event TreasuryUpdated(address indexed oldTreasury, address indexed newTreasury);

    // ---------------------------------------------------------
    // MODIFIERS
    // ---------------------------------------------------------

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor(address _uicToken, address _blqMinter, address _treasury) {
        admin = msg.sender;
        uicToken = IERC20(_uicToken);
        blqMinter = IBLqMinter(_blqMinter);
        treasury = _treasury;
    }

    // ---------------------------------------------------------
    // CORE FUNCTION: CLAIM REWARDS
    // ---------------------------------------------------------

    /**
     * @notice Claim UIC rewards based on BLq earned
     */
    function claimRewards() external {
        uint256 userBLq = blqMinter.blqBalance(msg.sender);
        require(userBLq > 0, "No BLq earned");

        // Calculate total entitled UIC
        uint256 totalEntitlement = userBLq * rewardPerBLq;

        // Subtract already-claimed rewards
        uint256 owed = totalEntitlement - claimedRewards[msg.sender];
        require(owed > 0, "Nothing to claim");

        // Update state
        claimedRewards[msg.sender] += owed;
        totalDistributed += owed;

        // Transfer UIC
        require(uicToken.transfer(msg.sender, owed), "UIC transfer failed");

        emit RewardsClaimed(msg.sender, owed, block.timestamp);
    }

    // ---------------------------------------------------------
    // ADMIN CONTROLS
    // ---------------------------------------------------------

    function updateRewardRate(uint256 newRate) external onlyAdmin {
        emit RewardRateUpdated(rewardPerBLq, newRate);
        rewardPerBLq = newRate;
    }

    function updateTreasury(address newTreasury) external onlyAdmin {
        emit TreasuryUpdated(treasury, newTreasury);
        treasury = newTreasury;
    }

    function withdrawFromTreasury(uint256 amount) external onlyAdmin {
        require(uicToken.transfer(admin, amount), "Withdraw failed");
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        admin = newAdmin;
    }

    // ---------------------------------------------------------
    // VIEW FUNCTIONS
    // ---------------------------------------------------------

    function pendingRewards(address user) external view returns (uint256) {
        uint256 blq = blqMinter.blqBalance(user);
        uint256 total = blq * rewardPerBLq;
        return total - claimedRewards[user];
    }
}
