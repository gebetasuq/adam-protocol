require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  paths: {
    sources: "./",
    tests: "./test",
    cache: "./.cache",
    artifacts: "./artifacts",
  },
  networks: {
    hardhat: {},
    qubic: {
      // Placeholder RPC – replace with real Qubic EVM-compatible endpoint if available
      url: "http://localhost:8545",
      chainId: 1337,
      accounts: [],
    },
  },
};
