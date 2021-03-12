pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";

contract LawToken is ERC20, ERC20Detailed {
    address payable owner;
    mapping(address => uint) balances;
    // address payable owner = msg.sender;

    modifier onlyOwner {
        require(msg.sender == owner, "You do not have permission to mint these tokens!");
        _;
    }

    constructor(uint initial_supply) ERC20Detailed("LawToken", "LAWT", 18) public {
        owner = msg.sender;
        _mint(owner, initial_supply);
    }
    
    //calculate investment percentage and create new array   
    function investmentDistribution(address[] memory recipient, uint[] memory investmentAmount, uint[] memory investmentX, uint fundingAmount) public {
        for(uint i = 0; i < investmentX.length; ++i) {
            investmentX[i] = (investmentAmount[i] / fundingAmount);
            mint(recipient[i], investmentX[i] * fundingAmount);
            }
        
    }
    

    function mint(address recipient, uint amount) public onlyOwner {
        balances[recipient] = balances[recipient].add(amount);
        _mint(recipient, amount);
    }
}
 