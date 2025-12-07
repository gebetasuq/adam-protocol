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
  });

  const [userData, setUserData] = useState({
    blqBalance: 0,
    rewards: 0,
    contributionRank: null,
  });

  useEffect(() => {
    const interval = setInterval(() => {
      setMetrics((prev) => ({
        ...prev,
        verifiedActions: prev.verifiedActions + Math.floor(Math.random() * 10),
        blqMinted: prev.blqMinted + Math.floor(Math.random() * 5),
      }));
    }, 4000);

    return () => clearInterval(interval);
  }, []);

  const handleProofSubmit = () => {
    const minted = Math.floor(Math.random() * 8) + 3;

    setUserData((prev) => ({
      ...prev,
      blqBalance: prev.blqBalance + minted,
      rewards: prev.rewards + minted * 100,
    }));

    setMetrics((prev) => ({
      ...prev,
      verifiedActions: prev.verifiedActions + 1,
      blqMinted: prev.blqMinted + minted,
    }));
  };

  return (
    <div className="celestial-container">
      <header className="celestial-header">
        <h1 className="gold-title">ADAM — CAMPUS GENESIS</h1>
        <p className="gold-subtitle">Coordinated Civilization Begins Here</p>
      </header>

      <div className="dashboard-grid">
        <Dashboard metrics={metrics} />

        <div className="right-panel">
          <ProofGenerator onSubmit={handleProofSubmit} />
          <BLqTracker userData={userData} />
        </div>

        <Leaderboard />
      </div>

      <footer className="celestial-footer">
        Built on Qubic · Zero-Knowledge · Privacy by Default
      </footer>
    </div>
  );
}

export default App;
