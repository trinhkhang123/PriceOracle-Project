
require("@nomicfoundation/hardhat-toolbox");

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const ALCHEMY_API_KEY = "ECXUX4TQD3Y1BCRT1F9DBG79ZK8DNS4CAG";

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
const GOERLI_PRIVATE_KEY = "8bf8c17b56fa75be3326c12e0b8ec0550393e36d6e77851699b9a059d4c4515a";

module.exports = {
  solidity: "0.8.0",
  networks: {
    goerli: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: [GOERLI_PRIVATE_KEY]
    }
  }
};