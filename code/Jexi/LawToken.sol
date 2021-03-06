pragma solidity ^0.5.0;

import "lawTokenMintable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";


contract LawToken is ERC721Full {
    //address payable public caseOwner;
    bool public ended;
    //uint fundingAmount;
    address payable public investor;
    //uint public amount;
    uint public caseBalance;
    //uint estimatedSettlement;
    address public lastToWithdraw;
    uint public lastWithdrawBlock;
    uint public lastWithdrawAmount;
    
    
    uint unlockTime;
    
    mapping(address => uint) returnFunds;
    
    //mapping(address => uint) litigants;
    
    // Allowed withdrawals of the case funding
    mapping(address => uint) WithdrawFunds;
    
    
     // end the case 
    event fundingEnded(address investor, uint estimatedSettlement);
    
    constructor() ERC721Full("LawToken", "LAWT") public {}
    
    using Counters for Counters.Counter;
    Counters.Counter tokenCounter;
        
    struct CivilCase {
      //Implement CivilCases struct
      address payable caseOwner;
      string caseArea;
      string caseDescription;
      string defendant;
      string firm;
      uint fundingAmount;
      //uint plaintiffEquity ?              // privacy vs relevant investment information
      uint fundingDeadline;
    }

    // Stores tokenCounter => CivilCase
    // Only permanent data that you would need to use in a smart contract later should be stored on-chain
   mapping(uint => CivilCase) public CivilCases;
   
   function registerCivilCase(
      address payable newcaseOwner,
      string memory caseDescription,
      string memory caseArea,
      string memory defendant,
      //uint EstimatedSettlement,
      string memory firm,
      uint fundingAmount,
      uint fundingDeadline
      
        ) public returns(uint) {
      //Implement registerCivilCase
      tokenCounter.increment();
      uint caseId = tokenCounter.current();
      
      fundingDeadline = now + 30 days;
      
       CivilCases[caseId] = CivilCase(newcaseOwner, caseArea, caseDescription, defendant, firm, fundingAmount, fundingDeadline );
      
        return caseId;
        }
        
    // funding the civil case 
    function fundingcase(uint caseId) public payable {
        
        require(msg.value < CivilCases[caseId].fundingAmount, "The amount to invest exceeded the asking funding.");
        caseBalance = address(this).balance;
        require(CivilCases[caseId].fundingAmount == caseBalance, "The civil case has not be funded");
        
    }
    
    /// Withdraw the funding.
    function withdraw(uint caseId) public{
       
        require( msg.sender == CivilCases[caseId].caseOwner, "You do not own this account");
        require( now >= unlockTime, "Your account is currently locked");
        uint amount = WithdrawFunds[msg.sender];
        
        if (lastToWithdraw != msg.sender) {
            lastToWithdraw = msg.sender;
        }
        lastWithdrawAmount = amount;
        lastWithdrawBlock = block.number;
        
        if (amount > address(this).balance / 5){
        unlockTime = now + 5 days;
        }
    }
    
    
    //In case the funding amount is not full fill return the fundings to investors
    function cancelCivilCase() public view returns (uint) {
        return returnFunds[investor];
        }
      
    }
      
      
      