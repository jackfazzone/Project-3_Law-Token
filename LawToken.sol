pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

contract LawToken is ERC721Full {
    
    bool public ended;
    address public investor;
    uint public amount;
    event fundingEnded(address investor, uint estimatedSettlement);

    constructor() ERC721Full("LawToken", "CLS") public { }

    using Counters for Counters.Counter;
    Counters.Counter tokenCounter;

    struct CivilCase {
      //Implement CivilCases struct
      string caseDescription;
      string attorney;
      uint caseExpenses;
      uint estimatedSettlement;
    }

    // Stores tokenCounter => CivilCase
    // Only permanent data that you would need to use in a smart contract later should be stored on-chain
    mapping(uint => CivilCase) public CivilCases;

    event caseSentenced(uint tokenId, string reportURI);

    function registerCivilCase(address payable caseOwner,
        string memory caseDescription,
        string memory eventLocation,
        string memory eventDate,
        string memory plaintiffInjury,
        string memory defendant,
        uint damageEstimatedValue,
        string memory lawFirm,
        string memory attorney,
        uint fundingAmount,
        uint fundingDeadline,
        string memory estimatedRangeSettlement,
        uint setllementPercentageSplit,
        string memory attorneyIncentiveFeeStructure, 
        
        string memory caseURI) public returns(uint) {
      //Implement registerCivilCase
      tokenCounter.increment();
      uint caseId = tokenCounter.current();
      
      fundingDeadline = now + 30 days;
      
      _mint(caseOwner, caseId);
      _setTokenURI(caseId, caseURI);
      
      CivilCases[caseId] = CivilCase(caseDescription, attorney, 0, 0);

        return caseId;
        }
    function fundingcase(address caseOwner, uint amount, address investor ) public{}
    
    function cancelCivilCasending(address investor) public view returns (uint) {
        return amount[investor];
        //In case the funding amount is not full fill
    
     }
    
    function endFunding() public{
        require(fundingAmount < caseOwner.balance, "Civil case has been funded.");
        
        ended = true;
        emit fundingEnded(fundingAmount);

        beneficiary = caseOwner;
        beneficiary.transfer(estimatedSettlement);
        investor.transfer(estimatedSettlement);
        
        caseOwner[address]=0;
        }
      
    }
      
      
      
      