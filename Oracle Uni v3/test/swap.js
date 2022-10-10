const { expect } = require("chai");
const {ethers} = require("hardhat");

describe("Vote contract", function () {

  it("Check", async function() {
   const Oracle = await ethers.getContractFactory("UniswapV3Twap");
   const Deploy = await Oracle.deploy();
   const Token0="0x70997970C51812dc3A010C7d01b50e0d17dc79C8";
   await Deploy.AddToken(Token0);
   //const Price = await Deploy.estimateAmountOut('0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6',1,10);
   //console.log(Price);
  });
});