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

 Overview

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

---

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
└─ README.md                 
