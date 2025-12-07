/* Generate demo proofs for ADAM circuits
 * Usage:
 *  node generate_proof.js EnergyProof
 *  node generate_proof.js TransportProof
 */

const fs = require("fs");
const path = require("path");
const snarkjs = require("snarkjs");

async function generate(circuitName) {
  const buildDir = path.join(__dirname, "build", circuitName);

  const wasmPath = path.join(buildDir, `${circuitName}.wasm`);
  const zkeyPath = path.join(buildDir, `${circuitName}_final.zkey`);
  const inputPath = path.join(buildDir, "input.json");

  if (!fs.existsSync(inputPath)) {
    // simple demo input
    const input =
      circuitName === "EnergyProof"
        ? { previousReading: "1000", currentReading: "800", secretSalt: "42" }
        : { previousCommuteMinutes: "60", currentCommuteMinutes: "40", secretSalt: "7" };

    fs.writeFileSync(inputPath, JSON.stringify(input, null, 2));
  }

  const input = JSON.parse(fs.readFileSync(inputPath));

  console.log(`\n⛓  Generating proof for ${circuitName}...`);

  const { proof, publicSignals } = await snarkjs.groth16.fullProve(
    input,
    wasmPath,
    zkeyPath
  );

  fs.writeFileSync(
    path.join(buildDir, "proof.json"),
    JSON.stringify(proof, null, 2)
  );
  fs.writeFileSync(
    path.join(buildDir, "public.json"),
    JSON.stringify(publicSignals, null, 2)
  );

  console.log("✅ Proof and public signals written to build directory.");
}

const circuitName = process.argv[2] || "EnergyProof";
generate(circuitName).catch(console.error);
