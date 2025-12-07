// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/**
 * @title CampusGenesis
 * @notice First deployment of ADAM protocol — tracking provable energy reduction
 *         on university campuses using zero-knowledge proofs. No personal data.
 *
 * @dev This contract accepts:
 *      - encoded ZK proof bytes
 *      - public signal minimumRequired (kWh reduction)
 *      - emits events
 *      - updates leaderboard
 *
 *      External verifier contract MUST implement:
 *          function verifyProof(bytes calldata proof) external returns (bool);
 */

interface IZKVerifier {
    function verifyProof(bytes calldata proof) external view returns (bool);
}

contract CampusGenesis {
    
    // ---------------------------------------------------------
    // STORAGE
    // ---------------------------------------------------------
    IZKVerifier public verifier;
    address public admin;

    struct StudentScore {
        uint256 totalReductions;  // cumulative energy reduction
        uint256 submissions;      // number of proofs submitted
    }

    mapping(address => StudentScore) public scores;

    // ranking list (simple + hackathon-ready)
    address[] public participants;

    // ---------------------------------------------------------
    // EVENTS
    // ---------------------------------------------------------
    event ProofSubmitted(address indexed student, uint256 reduction, uint256 timestamp);
    event VerifierUpdated(address indexed oldVerifier, address indexed newVerifier);
    event AdminChanged(address indexed oldAdmin, address indexed newAdmin);

    // ---------------------------------------------------------
    // MODIFIERS
    // ---------------------------------------------------------
    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    // ---------------------------------------------------------
    // CONSTRUCTOR
    // ---------------------------------------------------------
    constructor(address _verifier) {
        admin = msg.sender;
        verifier = IZKVerifier(_verifier);
    }

    // ---------------------------------------------------------
    // CORE LOGIC: SUBMIT ENERGY PROOF
    // ---------------------------------------------------------
    /// @notice Student submits zk-SNARK / zk-STARK proof that energy reduction >= required
    /// @param proof Encoded proof bytes
    /// @param claimedReduction The amount of reduction user claims (public input)
    function submitEnergyProof(bytes calldata proof, uint256 claimedReduction) external {
        require(claimedReduction > 0, "Reduction must be positive");

        // 1. Verify ZK proof via external verifier
        bool ok = verifier.verifyProof(proof);
        require(ok, "Invalid zero-knowledge proof");

        // 2. Update student score
        if (scores[msg.sender].submissions == 0) {
            participants.push(msg.sender);
        }

        scores[msg.sender].totalReductions += claimedReduction;
        scores[msg.sender].submissions += 1;

        // 3. Emit event for off-chain systems (leaderboard, AI agent, analytics)
        emit ProofSubmitted(msg.sender, claimedReduction, block.timestamp);
    }

    // ---------------------------------------------------------
    // ADMIN FUNCTIONS
    // ---------------------------------------------------------

    /// @notice Change the ZK verifier address
    function updateVerifier(address newVerifier) external onlyAdmin {
        emit VerifierUpdated(address(verifier), newVerifier);
        verifier = IZKVerifier(newVerifier);
    }

    /// @notice Transfer admin role
    function transferAdmin(address newAdmin) external onlyAdmin {
        emit AdminChanged(admin, newAdmin);
        admin = newAdmin;
    }

    // ---------------------------------------------------------
    // VIEWS
    // ---------------------------------------------------------

    /// @notice Returns leaderboard in simple array form
    function getParticipants() external view returns (address[] memory) {
        return participants;
    }

    /// @notice Gas-efficient leaderboard sorting should be done off-chain.
    function getStudentScore(address student)
        external
        view
        returns (uint256 totalReduction, uint256 submissions)
    {
        StudentScore memory s = scores[student];
        return (s.totalReductions, s.submissions);
    }
}
