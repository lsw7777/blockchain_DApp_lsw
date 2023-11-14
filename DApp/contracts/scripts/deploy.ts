import { ethers } from "hardhat";  
  
async function main() {  
  const BorrowYourCar = await ethers.getContractFactory("BorrowYourCar");  
  const borrowYourCar = await BorrowYourCar.deploy();  
  await borrowYourCar.deployed();  
  console.log(`BorrowYourCar deployed successfully to ${borrowYourCar.address}`);  
  
  const erc20 = await borrowYourCar.myERC20();  
  console.log(`erc20 contract has been deployed successfully in ${erc20}`);  
  
  // Additional functionality  
  const owner = await borrowYourCar.owner();  
  console.log(`The owner of the BorrowYourCar contract is ${owner}`);  
  
  // Perform some operations on the contract  
  const someValue = await borrowYourCar.someFunction();  
  console.log(`The result of someFunction is ${someValue}`);  
  
  // Call a contract function that requires a specific condition  
  const conditionMet = await borrowYourCar.checkCondition();  
  if (conditionMet) {  
    const result = await borrowYourCar.performAction();  
    console.log(`Action performed successfully: ${result}`);  
  } else {  
    console.log("Condition not met. Action cannot be performed.");  
  }  
  
  // Interact with other contracts  
  const AnotherContract = await ethers.getContractFactory("AnotherContract");  
  const anotherContract = await AnotherContract.deploy();  
  await anotherContract.deployed();  
  
  const interactionResult = await borrowYourCar.interactWithAnotherContract(anotherContract.address);  
  console.log(`Interaction with AnotherContract: ${interactionResult}`);  
}  
  
// We recommend this pattern to be able to use async/await everywhere  
// and properly handle errors.  
main().catch((error) => {  
  console.error(error);  
  process.exitCode = 1;  
});  