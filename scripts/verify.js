const hre = require("hardhat");

async function main() {
  console.log("🔍 Starting contract verification...");

  await hre.run("verify:verify", {
    address: process.env.CONTRACT_ADDRESS,
    constructorArguments: JSON.parse(process.env.ARGS || "[]"),
  });

  console.log("✔ Verification successful!");
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
