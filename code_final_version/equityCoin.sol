pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";



// Funding secured on 721 -> mint erc20s -> transfer respective equities of erc20s (integers) -> transfer attorney ether -> case won -> 
//   settlement converted to ether -> erc20s / ether rate -> deposit of erc20s to 721 address triggers ether transfer to msg.sender at conversion rate?


contract equityCoin is ERC20, ERC20Detailed, ERC20Mintable {
    constructor(
        string memory name,
        string memory symbol,
        uint initial_supply
    )
        ERC20Detailed(name, symbol, 100) // or we can do it with the decimals to get better investment gradients
        public
    {
        // constructor can stay empty
    }
}
