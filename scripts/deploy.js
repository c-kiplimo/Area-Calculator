async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
  
    const AreaCalculator = await ethers.getContractFactory("AreaCalculator");
    const areaCalculator = await AreaCalculator.deploy();
  
    console.log("AreaCalculator deployed to:", areaCalculator.address);
  }
  
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  