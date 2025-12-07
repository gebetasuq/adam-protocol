// Placeholder batch verifier for stored proofs.

const fs = require("fs");
const path = require("path");
const snarkjs = require("snarkjs");

async function verify(circuitName) {
  const buildDir = path.join(__dirname, "..", "circuits", "build", circuitName);
  const vkeyPath = path.join(buildDir, `${circuitName}_vkey.json`);
  const proofPath = path.join(buildDir, "proof.json");
  const publicPath = path.join(buildDir, "public.json");

  const vkey = JSON.parse(fs.readFileSync(vkeyPath));
  const proof = JSON.parse(fs.readFileSync(proofPath));
  const publicSignals = JSON.parse(fs.readFileSync(publicPath));

  const res = await snarkjs.groth16.verify(vkey, publicSignals, proof);
  console.log(`${circuitName} proof valid?`, res);
}

verify("EnergyProof").catch(console.error);
