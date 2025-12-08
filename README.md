
# ADAM Protocol v6.0 – Civilization OS

**The Operating System for Coordinated Civilization**

ADAM is a protocol for **verified positive behavior**.  
It combines **Zero-Knowledge Proofs of Action**, **behavioral rewards (BLq)**, and a **modular mesh architecture** for cities, campuses, and enterprises.

Built on Qubic-compatible infrastructure and EVM tooling, ADAM enables:

- ✅ **ZK-verified proofs of behavior** (energy, transport, participation, etc.)
- ✅ **BLq minting** for positive externalities
- ✅ **Feeless, deterministic execution** (Qubic-style)
- ✅ **Privacy-preserving verification** – behavior is proven, not exposed

---

## 1. High-Level Overview

### Problem

Human systems suffer from a **coordination failure** across:

- Energy & climate actions  
- Transport & mobility choices  
- Campus/city participation  
- Sustainability & public goods

Current systems are either:

- Surveillance-based (privacy loss), or  
- Weakly verifiable (no cryptographic guarantees).

### ADAM’s Approach

ADAM introduces **ZK-Proof-of-Action**:

1. **User performs an action** (e.g. reduced energy usage, green commute).
2. **Local client creates a zero-knowledge proof** of that behavior.
3. **Verifiers check the proof** on-chain via `IZKVerifier`.
4. **Rewards** (BLq) are distributed through `RewardDistributor`.
5. All of this happens **without revealing raw behavior data**.


## 2. Repository Structure

```txt
adam-protocol/
├─ circuits/                 # Zero-knowledge circuits (Circom)
│  ├─ EnergyProof.circom     # Proves reduced energy consumption
│  └─ TransportProof.circom  # Proves low-carbon commute behavior
│
├─ contracts/                # Solidity smart contracts
│  ├─ BLqMinter.sol          # Mints BLq (Behavior Liquidity Units)
│  ├─ CampusGenesis.sol      # Campus/city registration & behavior registry
│  ├─ RewardDistributor.sol  # Escrow and distribution of BLq rewards
│  └─ IZKVerifier.sol        # Interface for ZK proof verifier
│
├─ abi/                      # Frontend-friendly ABIs
│  ├─ BLqMinter.json
│  ├─ CampusGenesis.json
│  ├─ RewardDistributor.json
│  └─ IZKVerifier.json
│
├─ frontend/                 # React + Vite dashboard (MVP)
│  ├─ index.html             # App entry HTML
│  ├─ Vite.config.js         # Vite configuration
│  ├─ package.json           # Frontend dependencies & scripts
│  └─ src/
│     ├─ main.jsx            # React root
│     ├─ App.jsx             # Top-level layout & routing
│     ├─ styles.css          # Basic styling
│     └─ components/
│        ├─ Dashboard.jsx    # Campus & metric dashboard
│        └─ ProofGenerator.jsx # UI to submit / simulate ZK proofs
│
├─ scripts/                  # Backend / devops scripts
│  ├─ deploy.js              # Deploys all core contracts
│  └─ verify.js              # Contract verification helper
│
├─ ADAM v6.0 – System Architecture Diagram (…)
├─ ADAM v6.0 – Repository Folder Structure (…)
├─ FRONTEND STRUCTURE
├─ LICENSE
└─ README.md                 # You are here


3. Smart Contracts

CampusGenesis.sol

Registers campuses / districts / organizations.

Links behavior events to ZK verifiers.

Acts as the coordinator for a given mesh (campus, city, enterprise).


Key responsibilities:

activateCampus(uint256 campusId) – activates a new campus.

(Future) registration of metric types (energy, transport, etc.).




BLqMinter.sol

Mints BLq (Behavior Liquidity Units), the reward asset.

Intended to be called only by trusted protocol contracts (e.g. RewardDistributor).


Key responsibilities:

mintBLQ(address recipient, uint256 amount) – mints BLq to a user after successful proof verification.




RewardDistributor.sol

Escrows and distributes BLq rewards.

Implements the reward logic that is triggered when a ZK proof is accepted.


Key responsibilities:

distribute(address recipient, uint256 reward) – sends BLq for a verified action.



---

IZKVerifier.sol

Interface for any ZK verifier contract.

Allows swapping out concrete verifier implementations (Groth16, Plonk, STARK, etc.).


Key function:

verifyProof(bytes memory proof) external view returns (bool) – returns true if proof is valid.




4. Zero-Knowledge Circuits

Located in circuits/:

EnergyProof.circom

Encodes a circuit where:

Private inputs: previous vs. current energy measurement.

Public signal: “reduction above threshold”.


Allows a user to prove verified reduction without exposing raw readings.


TransportProof.circom

Encodes a circuit for commute minutes / mode.

Lets a user prove that their commute meets a sustainability constraint (e.g. walking, cycling, public transport) without revealing the exact route or time.


> These circuits are compiled with Circom and connected to on-chain verifiers via the IZKVerifier interface.





5. Frontend – ADAM Dashboard

The frontend (in frontend/) is a minimal but complete behavior dashboard:

Dashboard.jsx

Shows campus-level reductions (energy, transport, etc.).

Displays BLq minted and rewards distributed.


ProofGenerator.jsx

UI for generating / submitting behavior proofs.

For now can also use simulated inputs for demo/testing.


App.jsx & main.jsx

Wire the components together.

Handle basic routing / state.





6. Scripts

Located in /scripts:

deploy.js

Deploys:

1. IZKVerifier


2. CampusGenesis


3. BLqMinter


4. RewardDistributor



Logs all deployed addresses for use in:

Frontend .env / config

ABI files

Verification and testing



Run via Hardhat:

npx hardhat run scripts/deploy.js --network <your-network>

verify.js

Simple helper to verify contracts on a block explorer.


CONTRACT_ADDRESS=0x... ARGS="[]" npx hardhat run scripts/verify.js --network <your-network>



7. Getting Started (Local Dev)

Prerequisites

Node.js (LTS)

Yarn or npm

Hardhat

(Optional) Circom + snarkjs for recompiling circuits


7.1 Install Dependencies

Backend / contracts:

npm install
# or
yarn install

Frontend:

cd frontend
npm install
# or
yarn install

7.2 Compile & Test Contracts

npx hardhat compile
npx hardhat test

7.3 Run the Frontend

cd frontend
npm run dev
# or
yarn dev

Open the printed localhost URL to use the dashboard.



8. Roadmap

🔐 Full integration with production-grade ZK verifier contracts.

🛰 Qubic / L2 deployment and gas-optimized reward flows.

🧩 Additional metric circuits:

Waste reduction

Mobility sharing

Digital participation


🏙 Multi-campus mesh support and cross-domain coordination.

📊 Rich analytics dashboard for city-scale metrics.





9. Team

Team Gebeta

Mohammed B. Kemal – Vision Architect of ADAM v6.0

Abimbola Otegbeye – Protocol Engineer & Co-Builder





10. License

This project is licensed under the MIT License.
See LICENSE for details.
