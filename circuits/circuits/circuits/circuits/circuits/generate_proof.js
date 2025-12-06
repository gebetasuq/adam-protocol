// Demo-only proof generator for ADAM circuits
const { execSync } = require("child_process");
const path = require("path");

function run(cmd) {
  console.log(`\n> ${cmd}`);
  execSync(cmd, { stdio: "inherit" });
}

// example: node generate_proof.js EnergyProof
const circuitName = process.argv[2] || "EnergyProof";

const buildDir = path.join(__dirname, "build", circuitName);

async function main() {
  console.log(`🔐 Generating demo proof for ${circuitName}...`);

  // 1. Create dummy input
  const input = {
    previousReading: "1000",
    currentReading: "800",
    secretSalt: "123456789"
  };

  require("fs").writeFileSync(
    path.join(buildDir, "input.json"),
    JSON.stringify(input, null, 2)
  );

  // 2. Generate proof
  run(
    `node ${buildDir}/${circuitName}_js/generate_witness.js ` +
      `${buildDir}/${circuitName}_js/${circuitName}.wasm ` +
      `${buildDir}/input.json ${buildDir}/witness.wtns`
  );

  run(
    `npx snarkjs groth16 prove ` +
      `${buildDir}/${circuitName}_zk_key.zkey ` +
      `${buildDir}/witness.wtns ` +
      `${buildDir}/proof.json ${buildDir}/public.json`
  );

  console.log(`\n✅ Demo proof generated at ${buildDir}/proof.json`);
}

main().catch(console.error);
