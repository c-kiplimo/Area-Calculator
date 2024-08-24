// Import the Hardhat Runtime Environment explicitly
const hre = require("hardhat");

async function main() {
  // Get the account used for deploying contracts
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy the AreaCalculator contract
  const AreaCalculator = await hre.ethers.getContractFactory("AreaCalculator");
  const areaCalculator = await AreaCalculator.deploy();
  await areaCalculator.deployed();
  console.log("AreaCalculator deployed to:", areaCalculator.address);

  // Deploy the Bank contract
  const Bank = await hre.ethers.getContractFactory("Bank");
  const bank = await Bank.deploy();
  await bank.deployed();
  console.log("Bank deployed to:", bank.address);

  // Deploy the Crowdfunding contract
  const Crowdfunding = await hre.ethers.getContractFactory("Crowdfunding");
  const crowdfunding = await Crowdfunding.deploy();
  await crowdfunding.deployed();
  console.log("Crowdfunding deployed to:", crowdfunding.address);
}

// Handle errors and exit process
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
