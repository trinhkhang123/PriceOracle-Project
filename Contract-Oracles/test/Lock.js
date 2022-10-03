const { expect } = require("chai");
const {ethers} = require("hardhat");

describe("Vote contract", function () {

  it("Check", async function() {
   const Oracle = await ethers.getContractFactory("TestChainlink");
   const Deploy = await Oracle.deploy();

   const oracle = await Deploy.getLatestPrice();
   
   console.log(oracle);
  });
});