// Simple helper to compile ADAM circuits with circom + snarkjs
const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const CIRCUITS = ["EnergyProof", "TransportProof"];

function run(cmd) {
  console.log(`\n> ${cmd}`);
  execSync(cmd, { stdio: "inherit" });
}

function compileCircuit(name) {
  const circomFile = `${name}.circom`;
  const buildDir = path.join(__dirname, "build", name);

  if (!fs.existsSync(buildDir)) {
    fs.mkdirSync(buildDir, { recursive: true });
  }

  // 1. Compile circom → r1cs, wasm, sym
  run(
    `circom ${circomFile} --r1cs --wasm --sym -o ${buildDir}`
  );

  // 2. Setup (Groth16)
  run(
    `npx snarkjs groth16 setup ${buildDir}/${name}.r1cs pot12_final.ptau ${buildDir}/${name}_zk_key.zkey`
  );

  console.log(`\n✅ Compiled circuit: ${name}`);
}

(function main() {
  console.log("⛏  Compiling ADAM circuits...");
  CIRCUITS.forEach(compileCircuit);
  console.log("\n✅ All circuits compiled.");
})();
