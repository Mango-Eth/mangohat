require("@nomicfoundation/hardhat-toolbox");
const fs = require("fs");

const defaultNetwork = "ftm";

function mnemonic() {
  try {
    return fs.readFileSync("./mnemonic.txt").toString().trim();
  } catch (e) {
    if (defaultNetwork !== "localhost") {
      console.log(
        "add mnemonic"
      );
    }
  }
  return "";
}

const LOWEST_OPTIMIZER_COMPILER_SETTINGS = {
  version: '0.7.6',
  settings: {
    evmVersion: 'istanbul',
    optimizer: {
      enabled: true,
      runs: 1_000,
    },
    metadata: {
      bytecodeHash: 'none',
    },
  },
}

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork,


  networks: {
    bsc: {
      url: "https:data-seed-prebsc-2-s3.binance.org:8545",
      chainId: 97,
      gasPrice: 20000000000,
      gasLimit: 21000,
      accounts: {
        mnemonic: mnemonic(),
      }
    },
    ftm: {
      url: "https://rpc.testnet.fantom.network",
      chainId: 4002,
      Symbol: "FTM",
      gasPrice: 20000000000,
      gasLimit: 21000,
      accounts: {
        mnemonic: mnemonic(),
      }
    }
  },
  etherscan: {
    apiKey: "...",
  },



  solidity: {
    compilers: [
      // { version: "0.7.6", settings: { optimizer: { enabled: true, runs: 100 } } },
       { version: "0.8.24", settings: { optimizer: { enabled: true, runs: 100 } } },
      //  { version: "0.5.0", settings: { optimizer: { enabled: true, runs: 100 } } },
    ],
    overrides: {
      "contracts/Uniswap": LOWEST_OPTIMIZER_COMPILER_SETTINGS
  },
}

}