const hre = require("hardhat");

async function main() {
  const Evm1155StarterNFT = await hre.ethers.getContractFactory("Evm1155Starter");
  const Evm1155Starter = await Evm1155StarterNFT.deploy();

  await Evm1155Starter.deployed();

  console.log("Evm1155Starter deployed to:", Evm1155Starter.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
