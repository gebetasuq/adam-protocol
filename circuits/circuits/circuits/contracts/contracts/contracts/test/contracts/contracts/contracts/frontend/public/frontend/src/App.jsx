import React, { useState, useEffect } from "react";
import Dashboard from "./components/Dashboard";
import ProofGenerator from "./components/ProofGenerator";
import BLqTracker from "./components/BLqTracker";
import Leaderboard from "./components/Leaderboard";
import "./styles/celestial.css";

function App() {
  const [metrics, setMetrics] = useState({
    participants: 2147,
    verifiedActions: 42891,
    blqMinted: 12864,
    energyReduction: 18.3,
    bondPerformance: 37.2,
  });

  const [userData, setUserData] = useState({
    blqBalance: 0,
    rewards: 0,
    contributionRank: 42,
  });

  useEffect(() => {
    const interval = setInterval(() => {
      setMetrics((prev) => ({
        ...prev,
        verifiedActions: prev.verifiedActions + Math.floor(Math.random() * 10),
        blqMinted: prev.blqMinted + Math.floor(Math.random() * 5),
      }));
    }, 5000);

    return () => clearInterval(interval);
  }, []);

  const handleProofSubmit = () => {
    const newBLq = Math.floor(Math.random() * 10) + 5;

    setUserData((prev) => ({
      ...prev,
      blqBalance: prev.blqBalance + newBLq,
      rewards: prev.rewards + newBLq * 100,
    }));

    setMetrics((prev) => ({
      ...prev,
      verifiedActions: prev.verifiedActions + 1,
      blqMinted: prev.blqMinted + newBLq,
    }));
  };

  return (
    <div className="celestial-container">
      <header className="celestial-header">
        <h1 className="gold-title">ADAM · CAMPUS GENESIS</h1>
        <p className="gold-subtitle">Proof-of-Action Mesh · Qubic Testnet</p>
      </header>

      <div className="dashboard-grid">
        <div className="main-dashboard">
          <Dashboard metrics={metrics} />
        </div>
        <div className="control-panel">
          <ProofGenerator onSubmit={handleProofSubmit} />
          <BLqTracker userData={userData} />
        </div>
        <div className="leaderboard-section">
          <Leaderboard />
        </div>
      </div>

      <footer className="celestial-footer">
        <p>Built on Qubic · Zero-Knowledge Proofs · Privacy by Design</p>
        <p className="footer-note">
          Simulation · {metrics.participants.toLocaleString()} participants ·
          {metrics.energyReduction}% energy reduction
        </p>
      </footer>
    </div>
  );
}

export default App;
