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

  const fee = 3000;
  
  const factory = "0x1F98431c8aD98523631AE4a59f267346ea31F984";

  console.log("Deploying contracts with the account:", deployer.address);
  
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Deploy=await ethers.getContractFactory("UniswapV3Twap");

  const deploy=await Deploy.deploy(fee,factory);

  console.log("Token address:",deploy.address);

} 

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
