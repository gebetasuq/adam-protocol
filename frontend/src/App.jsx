import React from "react";
import Dashboard from "./components/Dashboard.jsx";
import ProofGenerator from "./components/ProofGenerator.jsx";

export default function App() {
  return (
    <div className="app-root">
      <header className="app-header">
        <h1>ADAM v6.0 — Civilization OS</h1>
        <p>
          ZK-Proof-of-Action + BLq rewards for verified positive behavior
          (energy & transport).
        </p>
      </header>

      <main className="app-main">
        <section className="card">
          <h2>Campus Dashboard</h2>
          <Dashboard />
        </section>

        <section className="card">
          <h2>Proof Generator (Demo)</h2>
          <ProofGenerator />
        </section>
      </main>

      <footer className="app-footer">
        <span>ADAM Protocol v6.0 • Built by Team Gebeta</span>
      </footer>
    </div>
  );
}
