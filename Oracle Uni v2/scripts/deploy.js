const { expect } = require("chai");
const {ethers} = require("hardhat");
// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.

async function main() { 
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Deploy=await ethers.getContractFactory("PriceOracle");

  const Factory = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f" ;

  const deploy=await Deploy.deploy(Factory);

  console.log("Token address:",deploy.address);

} 

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
