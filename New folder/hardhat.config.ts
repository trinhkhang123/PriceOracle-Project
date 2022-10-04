
require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config();

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts

module.exports = {
  solidity: "0.6.6",
  networks: {
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/jgxrmZrM8kGWeKkwR-SZIkf2w5DSDUjl",
      accounts: [process.env.PRIV_KEY]
    },
  },

  etherscan: {
    apiKey: "7TBVD4CZ11E7DF8BZ2ZYXMZM6JE9PFCCU6"
  },
};