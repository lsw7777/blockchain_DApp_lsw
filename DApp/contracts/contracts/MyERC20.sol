// SPDX-License-Identifier: UNLICENSED  
pragma solidity ^0.8.20;  
  
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";  
  
/**  
 * @title MyERC20  
 * @dev A custom ERC20 token contract with airdrop, transfer limit, and burn functionality.  
 */  
contract MyERC20 is ERC20 {  
  
    mapping(address => bool) claimedAirdropPlayerList;  
  
    uint256 public transferLimit;  
  
    /**  
     * @dev Initializes the contract with the provided name and symbol.  
     * @param name The name of the token.  
     * @param symbol The symbol of the token.  
     * @param limit The transfer limit for each transaction.  
     */  
    constructor(string memory name, string memory symbol, uint256 limit) ERC20(name, symbol) {  
        transferLimit = limit;  
    }  
  
    /**  
     * @dev Performs an airdrop of tokens to the calling address.  
     * Only users who haven't claimed the airdrop before are eligible.  
     * Emits a Transfer event to the caller.  
     */  
    function airdrop() external {  
        require(claimedAirdropPlayerList[msg.sender] == false, "This user has claimed airdrop already");  
        _mint(msg.sender, 10000);  
        claimedAirdropPlayerList[msg.sender] = true;  
    }  
  
    /**  
     * @dev Transfers tokens from the sender to the specified recipient.  
     * Only transfers that are within the transfer limit are allowed.  
     * @param recipient The address to transfer tokens to.  
     * @param amount The amount of tokens to transfer.  
     * @return A boolean indicating whether the transfer was successful or not.  
     */  
    function transferWithLimit(address recipient, uint256 amount) external returns (bool) {  
        require(amount <= transferLimit, "Transfer amount exceeds the limit");  
        _transfer(_msgSender(), recipient, amount);  
        return true;  
    }  
  
    /**  
     * @dev Burns a specific amount of tokens from the caller's account.  
     * The total supply of tokens will be reduced accordingly.  
     * @param amount The amount of tokens to burn.  
     */  
    function burn(uint256 amount) external {  
        _burn(_msgSender(), amount);  
    }  
}  