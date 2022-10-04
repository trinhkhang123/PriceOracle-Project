const { expect } = require("chai");
const {ethers} = require("hardhat");

describe("Vote contract", function () {

  it("Check", async function() {
   const usdt = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6";
   const weth = "0xdc31Ee1784292379Fbb2964b3B9C4124D8F89C60";
   const factory = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f";
   const Oracle = await ethers.getContractFactory("PriceOracle");
   const Deploy = await Oracle.deploy(factory,weth,usdt);
  });
});