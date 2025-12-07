// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./CampusGenesis.sol";

/// @title BLqMinter
/// @notice Thin wrapper over CampusGenesis to expose BLq as a simple mintable balance.
contract BLqMinter {
    CampusGenesis public campus;
    address public admin;

    mapping(address => uint256) public balances;

    event Mint(address indexed user, uint256 amount);
    event Burn(address indexed user, uint256 amount);

    constructor(address campusAddress) {
        campus = CampusGenesis(campusAddress);
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    function mintForProof(address user, uint256 amount) external onlyAdmin {
        balances[user] += amount;
        emit Mint(user, amount);
    }

    function burn(address user, uint256 amount) external onlyAdmin {
        require(balances[user] >= amount, "Insufficient BLq");
        balances[user] -= amount;
        emit Burn(user, amount);
    }

    function setCampus(address newCampus) external onlyAdmin {
        campus = CampusGenesis(newCampus);
    }
}
