// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IZKVerifier {
    /// @notice Verifies a zero-knowledge proof for an energy reduction action
    /// @param proof Encoded ZK-SNARK / ZK-STARK proof bytes
    /// @return isValid True if the proof is valid
    function verifyProof(bytes memory proof) external returns (bool isValid);
}
