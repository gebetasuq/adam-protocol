// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BLqMinter
/// @notice Minimal non-transferable reward token for ADAM protocol
/// @dev BLq = Behavioral Ledger Quantized Score (non-transferable reputation points)
contract BLqMinter {
    address public admin;

    mapping(address => uint256) public balanceOf;

    event Minted(address indexed user, uint256 amount);
    event AdminChanged(address newAdmin);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /// @notice Mint BLq reputation points to a user
    function mint(address user, uint256 amount) external onlyAdmin {
        balanceOf[user] += amount;
        emit Minted(user, amount);
    }

    /// @notice Non-transferable: disable transfer function
    function transfer(address, uint256) external pure returns (bool) {
        revert("BLq is non-transferable");
    }

    /// @notice Change admin (used by CampusGenesis)
    function setAdmin(address newAdmin) external onlyAdmin {
        admin = newAdmin;
        emit AdminChanged(newAdmin);
    }
}
