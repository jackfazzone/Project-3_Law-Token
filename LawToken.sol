pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

contract LawToken is ERC721Full {

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

    function registerCivilCase(address caseOwner,
        string memory caseDescription,
        string memory eventLocation,
        string memory eventDate,
        string memory plaintiffInjury,
        string memory defendant,
        uint damageEstimatedValue,
        string memory lawFirm,
        string memory attorney,
        string memory fundingDeadline,
        string memory estimatedRangeSettlement,
        uint setllementPercentageSplit,
        string memory attorneyIncentiveFeeStructure, 
        
        string memory caseURI) public returns(uint) {
      //Implement registerCivilCase
      tokenCounter.increment();
      uint caseId = tokenCounter.current();
      
      _mint(caseOwner, caseId);
      _setTokenURI(caseId, caseURI);
      
      CivilCases[caseId] = CivilCase(caseDescription, attorney, 0, 0);

        return caseId;
      
    }
      
      