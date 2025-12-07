import React from "react";

export default function ProofGenerator({ onSubmit }) {
  return (
    <div className="proof-generator">
      <h3 className="panel-title">Generate ZK Proof of Action</h3>

      <button className="generate-button" onClick={onSubmit}>
        Generate Proof + Mint BLq
      </button>

      <p className="panel-note">
        Your actual energy/transport data is never uploaded — ZK protects your privacy.
      </p>
    </div>
  );
}
