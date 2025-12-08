// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title IZKVerifier
 * @notice Interface for a zk-SNARK / zk-STARK verifier contract.
 * ADAM uses this to validate ZK-Proof-of-Action proofs coming from circom circuits.
 */
interface IZKVerifier {
    /**
     * @notice Verifies a zero-knowledge proof for an energy / transport action.
     * @param proof Encoded proof bytes (Groth16 / STARK).
     * @return isValid True if the proof is valid.
     */
    function verifyProof(bytes calldata proof) external view returns (bool isValid);
}
