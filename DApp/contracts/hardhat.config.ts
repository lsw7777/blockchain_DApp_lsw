import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const privateKey1 = '0x7nryaymhukucdhoneacmfzp7a3fvdqg05gsc1pfr4qsxuwtil8wgs9wdy17ehrzj';  
const privateKey2 = 
'0xybetuwq7vhunu49tbte3uh2gwzd7vp22pv06hhe70t4fytwmzonxrwegc2f5o3qx';  

const config: HardhatUserConfig = {  
  solidity: "0.8.20",  
  networks: {  
    ganache: {  
      url: 'HTTP://127.0.0.1:8545',  
      accounts: [  
        privateKey1,  
        privateKey2,  
      ]  
    },  
  },  
};  
  
export default config;  