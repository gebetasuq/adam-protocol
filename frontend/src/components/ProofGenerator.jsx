import React, { useState } from "react";

/**
 * This is a front-end stub.
 * In a full pipeline, you’d:
 *  1) Call a backend or WASM to run snarkjs on EnergyProof.circom
 *  2) Get the proof bytes
 *  3) Send them to the smart contract verifier
 */
export default function ProofGenerator() {
  const [previous, setPrevious] = useState("");
  const [current, setCurrent] = useState("");
  const [minReduction, setMinReduction] = useState("0");
  const [status, setStatus] = useState("");
  const [proof, setProof] = useState("");

  const handleGenerate = (e) => {
    e.preventDefault();

    if (!previous || !current) {
      setStatus("Please enter both previous and current readings.");
      return;
    }

    const prev = Number(previous);
    const curr = Number(current);
    const min = Number(minReduction || 0);

    const diff = prev - curr;
    const valid = diff >= min && diff > 0;

    // Mock proof bytes for demo only
    const mockProof = valid
      ? "0x" + Buffer.from("valid-energy-proof").toString("hex")
      : "";

    setProof(mockProof);
    setStatus(
      valid
        ? `✅ Reduction of ${diff} units meets the minimum requirement.`
        : `❌ Reduction too small. Required at least ${min}, got ${diff}.`
    );
  };

  return (
    <form className="proof-form" onSubmit={handleGenerate}>
      <div className="field">
        <label>Previous Reading (kWh)</label>
        <input
          type="number"
          value={previous}
          onChange={(e) => setPrevious(e.target.value)}
        />
      </div>

      <div className="field">
        <label>Current Reading (kWh)</label>
        <input
          type="number"
          value={current}
          onChange={(e) => setCurrent(e.target.value)}
        />
      </div>

      <div className="field">
        <label>Minimum Reduction (kWh)</label>
        <input
          type="number"
          value={minReduction}
          onChange={(e) => setMinReduction(e.target.value)}
        />
      </div>

      <button type="submit" className="btn-primary">
        Generate Demo Proof
      </button>

      {status && <p className="status">{status}</p>}

      {proof && (
        <div className="proof-output">
          <label>Mock Proof Bytes (for contract input)</label>
          <textarea readOnly value={proof} rows={3} />
        </div>
      )}
    </form>
  );
}
