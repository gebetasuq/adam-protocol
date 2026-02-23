const hre = require("hardhat");

async function main() {
  console.log(" Deploying ADAM Protocol smart contracts...\n");

  const BLqMinter = await hre.ethers.getContractFactory("BLqMinter");
  const CampusGenesis = await hre.ethers.getContractFactory("CampusGenesis");
  const RewardDistributor = await hre.ethers.getContractFactory("RewardDistributor");
  const IZKVerifier = await hre.ethers.getContractFactory("IZKVerifier");

  // 🔧 Deploy Verifier
  const verifier = await IZKVerifier.deploy();
  await verifier.deployed();
  console.log("✔ IZKVerifier deployed at:", verifier.address);

  // 🔧 Deploy CampusGenesis
  const campus = await CampusGenesis.deploy(verifier.address);
  await campus.deployed();
  console.log("✔ CampusGenesis deployed at:", campus.address);

  // 🔧 Deploy BLqMinter
  const minter = await BLqMinter.deploy(campus.address);
  await minter.deployed();
  console.log("✔ BLqMinter deployed at:", minter.address);

  //  Deploy RewardDistributor
  const distributor = await RewardDistributor.deploy(minter.address);
  await distributor.deployed();
  console.log("✔ RewardDistributor deployed at:", distributor.address);

  console.log("\n Deployment complete!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
