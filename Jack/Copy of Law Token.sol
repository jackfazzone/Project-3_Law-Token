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
    Counters.Counter caseCounter;
    Counters.Counter firmCounter;
    

    struct CivilCase {
      //Implement CivilCases struct
      string caseArea;
      string caseDescription;
      string defendant;
      string firm;
      uint firmEquity;
      //uint plaintiffEquity ?              // privacy vs relevant investment information
      uint remainingFunding;
      uint outstandingEquity;
      uint estimatedEquityPrice;            // per 1 erc20, remainingFunding/outstandingEquity
      uint estimatedEquityValue;            // from estimated settlement provided when firm assigned ... these ^ should be the same
      uint estimatedSettlement;
      uint fundingDeadline;
    }

    // Stores tokenCounter => CivilCase
    // Only permanent data that you would need to use in a smart contract later should be stored on-chain
    mapping(uint => CivilCase) public CivilCases;

    event caseSentenced(uint tokenId, string reportURI);
  
  
// I just put in the function below in case we want to list the cases before a law firm is assigned so that firms can bid on rate, the client can select a firm, etc.
// If we go in that direction, where should we store this list? Seems like it does not make sense to mint erc721s for a listed case and then turn around and mint another for the registry
// What if we list and mint with empty values on the attorney/ firm params and then update them after assignment with an "Attorney Assigned" emission?

    // function listCivilCase(address payable caseOwner,
    //     string caseType,
    //     string caseDescription,
    //     string eventLocation,
    //     string eventDate,
    //     string plaintiffInjury,
    //     string defendant) public returns (uint) {
    //     listCounter.increment();
    //     uint caseId = listCounter.current();
    //     //assignmentDeadline = //maybe we want to hardcode a value here
    //     }

    function registerCivilCase(address payable caseOwner,
        string memory caseArea,
        string memory caseDescription,
        string memory eventLocation,
        string memory eventDate,
        string memory plaintiffInjury,
        string memory defendant,
        uint totalSuitExpenses,             // given by assigned attorney
        string memory lawFirm,
        string memory attorney,             
        uint fundingAmount,                 // up-front cash bid of winning firm (crowdsale goal)
        uint firmEquity,                    // equity bid of winning (out of 100), will be no. of erc20s to distribute after funding
        //uint estimatedSettlement,         // 100*(totalSuitExpenses - fundingAmount)/firmEquity ... maybe instead of graduated incentive fee structure?
        //uint estimatedCoinValue           // ^^ /100
        uint fundingDeadline,
        string memory estimatedRangeSettlement,
        uint setllementPercentageSplit,
        string memory attorneyIncentiveFeeStructure, 
        
        string memory caseURI) public returns(uint) {
      //Implement registerCivilCase
      caseCounter.increment();
      uint caseId = caseCounter.current();
      
      fundingDeadline = now + 30 days;
      
      _mint(caseOwner, caseId,0);
      _setTokenURI(caseId, caseURI);
      
      CivilCases[caseId] = CivilCase(caseArea, caseDescription, defendant, "No firm assigned.", 0,0,0,0,0,0, fundingDeadline);

        return caseId;
        }
    function fundingcase(address caseOwner, uint amount, address investor ) public{}
    
    function cancelCivilCasending(address investor) public view returns (uint) {
        return amount[investor];
        //In case the funding amount is not full fill
    
     }
    
    function endFunding() public{
        require(fundingAmount < caseOwner.balance, "Civil case has been funded.");
        require(fundingDeadline > now, "Case funded before deadline.");
        
        ended = true;
        emit fundingEnded(fundingAmount); // What if we had it emit the information we need to issue ERC20 tokens? Case URI?

        beneficiary = caseOwner;
        beneficiary.transfer(estimatedSettlement);
        investor.transfer(estimatedSettlement);
        
        caseOwner[address]=0;
        }
      
    }
      
      
      
      