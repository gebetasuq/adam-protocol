const { expect } = require("chai");
const { ethers } = require("hardhat");

// Dummy verifier that always accepts
describe("CampusGenesis", function () {
  let verifier, campus, owner, user;

  beforeEach(async () => {
    [owner, user] = await ethers.getSigners();

    const Verifier = await ethers.getContractFactory("DummyVerifier");
    verifier = await Verifier.deploy();
    await verifier.deployed();

    const CampusGenesis = await ethers.getContractFactory("CampusGenesis");
    campus = await CampusGenesis.deploy(verifier.address);
    await campus.deployed();
  });

  it("mints BLq on valid proof", async () => {
    const fakeProof = "0x1234";

    await campus.connect(user).submitEnergyProof(fakeProof);

    const blq = await campus.userBLq(user.address);
    expect(blq).to.be.gt(0);
  });

  it("returns metrics", async () => {
    const fakeProof = "0x1234";
    await campus.connect(user).submitEnergyProof(fakeProof);

    const [participants, totalBLq, avg] = await campus.getMetrics();
    expect(participants).to.equal(1);
    expect(totalBLq).to.be.gt(0);
    expect(avg).to.be.gt(0);
  });
});
