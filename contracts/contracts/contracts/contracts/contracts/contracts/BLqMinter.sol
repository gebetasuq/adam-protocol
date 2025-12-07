// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
 * @title BLqMinter
 * @notice Mints Behavior Liquidity Units (BLq) when ZK proofs are validated.
 *         This is the core financial primitive of the ADAM protocol.
 *
 *         BLq is not a token in the ERC20 sense — it is a behavior credit system.
 *         BLq can later be tokenized or bridged into ADAM-X financial layer.
 */

interface IZKVerifier {
    function verifyProof(bytes calldata proof) external view returns (bool);
}

contract BLqMinter {

    // ---------------------------------------------------------
    // STATE
    // ---------------------------------------------------------

    address public admin;
    IZKVerifier public verifier;

    // Total BLq minted across the Mesh
    uint256 public totalBLq;

    // BLq balance per user
    mapping(address => uint256) public blqBalance;

    // Cooldown to prevent spam submissions (per user)
    uint256 public constant SUBMISSION_COOLDOWN = 30 seconds;
    mapping(address => uint256) public lastSubmissionTime;

    // Multiplier (dynamic adjustment by AIGARTH AI governor)
    uint256 public globalMultiplier = 100; // default: 1 reduction = 100 BLq

    // ---------------------------------------------------------
    // EVENTS
    // ---------------------------------------------------------

    event BLqMinted(address indexed user, uint256 blqAmount, uint256 newBalance, uint256 timestamp);
    event MultiplierUpdated(uint256 oldValue, uint256 newValue);
    event VerifierUpdated(address indexed oldVerifier, address indexed newVerifier);
    event AdminChanged(address indexed oldAdmin, address indexed newAdmin);

    // ---------------------------------------------------------
    // MODIFIERS
    // ---------------------------------------------------------

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor(address _verifier) {
        admin = msg.sender;
        verifier = IZKVerifier(_verifier);
    }

    // ---------------------------------------------------------
    // CORE MINTING FUNCTION
    // ---------------------------------------------------------

    /**
     * @notice Mint BLq for verified positive actions (e.g., energy reduction).
     *
     * @param proof            Zero-knowledge proof bytes
     * @param reductionValue   Value of reduction (public input)
     */
    function mintBLq(bytes calldata proof, uint256 reductionValue) external {
        require(reductionValue > 0, "Invalid reduction value");

        // --- Rate limiting to stop spam ---
        require(
            block.timestamp - lastSubmissionTime[msg.sender] >= SUBMISSION_COOLDOWN,
            "Too many submissions. Please wait."
        );
        lastSubmissionTime[msg.sender] = block.timestamp;

        // --- Verify ZK Proof ---
        bool ok = verifier.verifyProof(proof);
        require(ok, "Invalid zero-knowledge proof");

        // --- Mint BLq Amount ---
        uint256 blqAmount = reductionValue * globalMultiplier;

        blqBalance[msg.sender] += blqAmount;
        totalBLq += blqAmount;

        emit BLqMinted(msg.sender, blqAmount, blqBalance[msg.sender], block.timestamp);
    }

    // ---------------------------------------------------------
    // ADMIN CONTROLS
    // ---------------------------------------------------------

    function updateMultiplier(uint256 newMultiplier) external onlyAdmin {
        require(newMultiplier > 0, "Invalid multiplier");
        emit MultiplierUpdated(globalMultiplier, newMultiplier);
        globalMultiplier = newMultiplier;
    }

    function updateVerifier(address newVerifier) external onlyAdmin {
        emit VerifierUpdated(address(verifier), newVerifier);
        verifier = IZKVerifier(newVerifier);
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        emit AdminChanged(admin, newAdmin);
        admin = newAdmin;
    }

    // ---------------------------------------------------------
    // VIEWS
    // ---------------------------------------------------------

    function getBLq(address user) external view returns (uint256) {
        return blqBalance[user];
    }
}
