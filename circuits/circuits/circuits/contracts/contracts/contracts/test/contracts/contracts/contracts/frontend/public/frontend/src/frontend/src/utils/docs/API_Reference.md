ADAM API Reference (Hackathon Demo)

This document summarizes the main on-chain and off-chain entrypoints for the
**ADAM – Campus Genesis** prototype.

---

## 1. Smart Contracts

### 1.1 CampusGenesis

**Address (testnet):** `TBD`

#### submitEnergyProof

```solidity
function submitEnergyProof(bytes calldata zkProof) external;

Description: Verifies a Groth16 ZK proof generated from EnergyProof.circom and mints BLq + UIC rewards for the sender.

Events:

ProofVerified(address indexed user, uint256 blqAmount, uint256 reward)



checkTargetAchievement

function checkTargetAchievement() external view returns (bool);

Returns true when the campus-level reduction target has been reached.


getMetrics

function getMetrics()
  external
  view
  returns (uint256 participants, uint256 totalBLq, uint256 averageContribution);

Used by the dashboard to display live KPIs.



---

1.2 BLqMinter

function mintForProof(address user, uint256 amount) external;
function burn(address user, uint256 amount) external;

Admin-only helper to mirror BLq balances for off-chain accounting.


---

1.3 RewardDistributor

function assignReward(address user, uint256 amount) external;
function claim() external;

Simple reward escrow (UIC points) for BLq holders.


---

2. Circuits

2.1 EnergyProof.circom

Private inputs

previousReading

currentReading

secretSalt


Public outputs

reductionPercentage

isValid (true if reduction ≥ 15%)


2.2 TransportProof.circom

Same pattern as EnergyProof but over commute minutes with a 20% threshold.


---

3. Frontend

The React frontend exposes three main views:

/ – Campus dashboard (metrics, leaderboard)

/generate – ZK proof generator

/wallet – BLq tracker (local simulation)



---

4. Scripts

circuits/compile_circuit.js – compile and setup circuits

circuits/generate_proof.js – create demo proofs

scripts/deploy.js – deploy contracts to Qubic testnet (placeholder)

scripts/simulate_data.js – generate 30-day mesh simulation

scripts/verify_proofs.js – batch verify stored proofs (placeholder)

