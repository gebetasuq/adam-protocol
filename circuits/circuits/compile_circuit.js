/* Compile ADAM Circuits (Energy + Transport)
 * Usage: node compile_circuit.js
 */

const { execSync } = require("child_process");
const path = require("path");

const CIRCUITS = ["EnergyProof", "TransportProof"];

function run(cmd) {
  console.log(`\n> ${cmd}`);
  execSync(cmd, { stdio: "inherit" });
}

function compileCircuit(name) {
  const circomFile = path.join(__dirname, `${name}.circom`);
  const buildDir = path.join(__dirname, "build", name);

  run(`mkdir -p ${buildDir}`);

  // 1. Compile
  run(`circom ${circomFile} --r1cs --wasm --sym -o ${buildDir}`);

  // 2. Setup (Groth16)
  run(`snarkjs groth16 setup ${buildDir}/${name}.r1cs pot12_final.ptau ${buildDir}/${name}_0000.zkey`);
  run(`snarkjs zkey contribute ${buildDir}/${name}_0000.zkey ${buildDir}/${name}_final.zkey -e="ADAM ${name} Ceremony"`);

  // 3. Export verification key
  run(`snarkjs zkey export verificationkey ${buildDir}/${name}_final.zkey ${buildDir}/${name}_vkey.json`);

  console.log(`\n✅ Finished circuit: ${name}`);
}

function main() {
  console.log("⛏  Compiling ADAM ZK-PoA circuits...");
  CIRCUITS.forEach(compileCircuit);
  console.log("\n✅ All circuits compiled.");
}

main();
