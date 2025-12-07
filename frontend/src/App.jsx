import React from "react";
import Dashboard from "./components/Dashboard.jsx";
import ProofGenerator from "./components/ProofGenerator.jsx";

export default function App() {
  return (
    <div
      style={{
        minHeight: "100vh",
        padding: "24px",
        background: "#050816",
        color: "#f5f5f5",
        fontFamily: "system-ui, -apple-system, BlinkMacSystemFont, sans-serif",
      }}
    >
      <header style={{ marginBottom: "24px" }}>
        <h1 style={{ fontSize: "28px", marginBottom: "8px" }}>
          ADAM v6.0 – Behavior Verification Console
        </h1>
        <p style={{ maxWidth: "720px", opacity: 0.85 }}>
          Submit off-chain behavior proofs, verify them on Qubic, and mint BLq for positive actions.
        </p>
      </header>

      <main
        style={{
          display: "grid",
          gridTemplateColumns: "minmax(0, 1.4fr) minmax(0, 1fr)",
          gap: "20px",
        }}
      >
        <section
          style={{
            background: "#0b1020",
            borderRadius: "16px",
            padding: "20px",
            border: "1px solid rgba(255,255,255,0.06)",
          }}
        >
          <h2 style={{ fontSize: "18px", marginBottom: "12px" }}>
            1. Generate a ZK-Proof
          </h2>
          <ProofGenerator />
        </section>

        <section
          style={{
            background: "#0b1020",
            borderRadius: "16px",
            padding: "20px",
            border: "1px solid rgba(255,255,255,0.06)",
          }}
        >
          <h2 style={{ fontSize: "18px", marginBottom: "12px" }}>
            2. Campus / City Dashboard
          </h2>
          <Dashboard />
        </section>
      </main>
    </div>
  );
}
