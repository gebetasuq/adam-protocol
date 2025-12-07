// Minimal placeholder for Qubic integration used in the demo UI.

export async function connectWallet() {
  // In real deployment, integrate with Qubic / EVM wallet.
  return { address: "0xDemoUser" };
}

export async function submitEnergyProofToChain(proof) {
  console.log("Submitting proof to Qubic...", proof);
  // TODO: wire to CampusGenesis contract via ethers.js
  return { txHash: "0xdeadbeef" };
}
