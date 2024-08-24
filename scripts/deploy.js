async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy the AreaCalculator contract
  const AreaCalculator = await ethers.getContractFactory("AreaCalculator");
  const areaCalculator = await AreaCalculator.deploy();
  await areaCalculator.deployed();
  console.log("AreaCalculator deployed to:", areaCalculator.address);

  // Deploy the Bank contract
  const Bank = await ethers.getContractFactory("Bank");
  const bank = await Bank.deploy();
  await bank.deployed();
  console.log("Bank deployed to:", bank.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
