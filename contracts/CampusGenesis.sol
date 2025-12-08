// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./BLqMinter.sol";
import "./RewardDistributor.sol";

/**
 * @title CampusGenesis
 * @notice ADAM deployment for a single campus / city.
 * Links BLq minting + reward distribution.
 */
contract CampusGenesis {
    string public campusName;
    BLqMinter public blq;
    RewardDistributor public distributor;
    address public admin;

    event BehaviorVerified(address indexed user, bytes32 indexed poolId, uint256 reward);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor(
        string memory _campusName,
        address _blq,
        address _distributor
    ) {
        campusName = _campusName;
        blq = BLqMinter(_blq);
        distributor = RewardDistributor(_distributor);
        admin = msg.sender;
    }

    /**
     * @dev Example: when an off-chain worker verifies a user’s behavior,
     * they call this to mint BLq + allocate a claim.
     */
    function recordVerifiedAction(
        bytes32 poolId,
        address user,
        uint256 rewardAmount
    ) external onlyAdmin {
        blq.mint(address(distributor), rewardAmount);
        // Admin separately calls distributor.allocateReward with a ZK proof.
        emit BehaviorVerified(user, poolId, rewardAmount);
    }
}
