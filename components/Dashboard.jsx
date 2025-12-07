import React from "react";

export default function Dashboard({ metrics }) {
  return (
    <div className="metric-grid">
      <div className="metric-card">
        <div className="metric-value">{metrics.participants.toLocaleString()}</div>
        <div className="metric-label">Participants</div>
      </div>

      <div className="metric-card">
        <div className="metric-value">{metrics.verifiedActions.toLocaleString()}</div>
        <div className="metric-label">Verified Actions</div>
      </div>

      <div className="metric-card">
        <div className="metric-value">{metrics.blqMinted.toLocaleString()}</div>
        <div className="metric-label">BLq Minted</div>
      </div>

      <div className="metric-card">
        <div className="metric-value">{metrics.energyReduction}%</div>
        <div className="metric-label">Energy Reduction</div>
      </div>
    </div>
  );
}
