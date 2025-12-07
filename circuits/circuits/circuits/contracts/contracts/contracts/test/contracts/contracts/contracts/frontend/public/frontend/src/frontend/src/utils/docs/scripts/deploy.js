Commit msg: `Add API reference doc`

---

## 🔹 17–19. scripts

Create a `scripts` folder in repo root and then:

### 17. scripts/deploy.js

```js
// Deploy CampusGenesis + helpers using Hardhat

const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with:", deployer.address);

  const Verifier = await hre.ethers.getContractFactory("DummyVerifier");
  const verifier = await Verifier.deploy();
  await verifier.deployed();
  console.log("DummyVerifier:", verifier.address);

  const CampusGenesis = await hre.ethers.getContractFactory("CampusGenesis");
  const campus = await CampusGenesis.deploy(verifier.address);
  await campus.deployed();
  console.log("CampusGenesis:", campus.address);

  const BLqMinter = await hre.ethers.getContractFactory("BLqMinter");
  const minter = await BLqMinter.deploy(campus.address);
  await minter.deployed();
  console.log("BLqMinter:", minter.address);

  const RewardDistributor = await hre.ethers.getContractFactory(
    "RewardDistributor"
  );
  const rewards = await RewardDistributor.deploy();
  await rewards.deployed();
  console.log("RewardDistributor:", rewards.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
