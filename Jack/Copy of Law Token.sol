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
      address payable plaintiff;
      string caseArea;
      string caseDescription;
      string defendant;
      string firm;
      uint firmEquity;
      //uint plaintiffEquity ?              // privacy vs relevant investment information
      uint fundingDeadline;
    }
    
    struct LawFirm {
        address payable lawFirm;
        string firmName;
        string practceArea;
        string state;
        string city;
        string message;
    
    }
    
    struct Bid {
        uint firmID;
        string firmName;
        uint lumpSumBid;
        uint equityBid;
        string message;
        
    
    }

    // Stores tokenCounter => CivilCase
    // Only permanent data that you would need to use in a smart contract later should be stored on-chain
    mapping(uint => CivilCase) public CivilCases;
    mapping(uint => LawFirm) public firms;
    mapping(uint => Bid) private bids;

    event bidPlaced(uint bidID, bidURI)
    event caseAssigned(uint caseID, string caseURI);
    event caseSentenced(uint tokenId, string reportURI);
  
// What if we list and mint with empty values on the attorney/ firm params and then update them after assignment with an "Attorney Assigned" emission?


    function registerCivilCase(address payable caseOwner,
        string memory caseArea,
        string memory caseDescription,
        string memory eventLocation,
        string memory eventDate,
        string memory plaintiffInjury,
        string memory defendant,
        uint totalSuitExpenses,             // given by assigned attorney
        string memory firmName,
       // address payable lawFirm,
        string memory attorney,             
        uint fundingAmount,                 // up-front cash bid of winning firm (crowdsale goal)
        uint firmEquity,                    // equity bid of winning (out of 100), will be no. of erc20s to distribute after funding
        //uint estimatedSettlement,         // 100*(totalSuitExpenses - fundingAmount)/firmEquity ... maybe instead of graduated incentive fee structure?
        //uint estimatedCoinValue,          // ^^ /100
        uint fundingDeadline,
        string memory estimatedRangeSettlement,
        uint setllementPercentageSplit,
        string memory attorneyIncentiveFeeStructure, 
        
        string memory caseURI) public returns(uint) {
        require(msg.sender == caseCounter, "You are not authorized to register this case on behalf of the plaintiff account specified.");
        require(CivilCases[caseId] == )
        //Implement registerCivilCase
        caseCounter.increment();
        uint caseId = caseCounter.current();
      
        fundingDeadline = now + 30 days;
      
        _mint(caseOwner, caseId, 0);
        _setTokenURI(caseId, caseURI);
      
        CivilCases[caseId] = CivilCase(caseOwner, caseArea, caseDescription, defendant, "No firm assigned.", 0,0,0,0,0,0, fundingDeadline);

        return caseId;
        }
        
    function registerLawFirm(
        string memory firmName,
        string memory practceArea,
        string memory state,
        string memory city,
        string memory message,
        
        string memory firmURI) public returns(uint) {
        
        firmCounter.increment();
        uint firmID = firmCounter.current();
        
        _mint(msg.sender, firmID);
        _setTokenURI(firmID, firmURI);
        
        firms[firmID] = LawFirm(msg.sender,firmName, practceArea, state, city, message, 0);
        
        return firmID;
        }
        
    function submitBid(address payable lawFirm,
        string memory firmName,
        string memory firmID,               // can probably cut one or two of these, but I'll leave them in in case we want to require that the three values match in our firms mapping
        uint lumpSumBid,
        uint equityBid,
        string memory message,
        
        string memory bidURI) private returns(uint) {
        
        require(msg.sender == lawFirm, "You are not authorized to submit this bid on based on your provided credentials.");
        
        }
    
    function selectfirm();

        emit caseAssigned
        
        
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
      
      
      
      