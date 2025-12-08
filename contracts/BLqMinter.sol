// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title BLqMinter
 * @notice Minimal minting contract for the BLq (Behavior Liquidity Unit) token.
 * In a real deployment this would be a full ERC-20; here it’s a simplified demo.
 */
contract BLqMinter {
    string public constant name = "Behavior Liquidity Unit";
    string public constant symbol = "BLq";
    uint8  public constant decimals = 18;

    address public admin;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    event Mint(address indexed to, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function mint(address to, uint256 amount) external onlyAdmin {
        require(to != address(0), "zero address");
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Mint(to, amount);
        emit Transfer(address(0), to, amount);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "insufficient");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }
}
