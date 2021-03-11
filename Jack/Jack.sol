pragma solidity ^0.5.0;
import "./lawTokenMintable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

contract LawToken is ERC721Full {
    // for the bundled equity, should we just index the cases by a parameter (case area?) and then iterate through and bundle every 20?
     
    bool public ended;
    uint public caseBalance;
    address public lastToWithdraw;
    uint public lastWithdrawBlock;
    uint public lastWithdrawAmount;
    
    
    
    uint unlockTime;
    
    mapping(address => uint) returnFunds;
        
    // Allowed withdrawals of the case funding
    mapping(address => uint) WithdrawFunds;
        
     // end the case 
    event fundingEnded(address investor, uint estimatedSettlement);

    constructor() ERC721Full("LawToken", "LAWT") public { }

    using Counters for Counters.Counter;
    Counters.Counter caseCounter;
    Counters.Counter firmCounter;
    Counters.Counter bidCounter;

// // structures 
//     struct CivilCase {
//       //Implement CivilCases struct
//       address payable plaintiff;
//       string caseArea;
//       string caseDescription;
//       string defendant;
//       string firm;
//       uint firmEquity;
//       //uint plaintiffEquity ?              // privacy vs relevant investment information
//       uint fundingDeadline;
//    }
    
    struct LawFirm {
        address payable lawFirm;
        string firmName;
        string practceArea;
        string state;
        string city;
        string message;
    
    }
    
    // struct Bid {
    //     uint caseId;
    //     address payable lawFirm;
    //     uint firmID;
    //     string firmName;
    //     uint lumpSumBid;                                    // probably don't want to use a struct for this 
    //     uint equityBid;
    //     uint fundingDeadline;
    //     string message;
        
    // }

    // Stores tokenCounter => CivilCase
    // Only permanent data that you would need to use in a smart contract later should be stored on-chain
    //mapping(uint => CivilCase) public CivilCases;
    mapping(uint => LawFirm) public firms;
    //mapping(uint => Bid) public bids;

    event bidPlaced(uint caseId);
    event caseAssigned(uint caseId);
    event caseSentenced(uint tokenId, string reportURI);
  
// What if we list and mint with empty values on the attorney/ firm params and then update them after assignment with an "Attorney Assigned" emission?


    // function registerCivilCase(
    //     address payable caseOwner,
    //     string memory caseDescription,
    //     string memory caseArea,
    //     string memory defendant,
    //     string memory firm,
    //     uint fundingAmount,
    //     uint fundingDeadline
    //     ) 
    //     public returns(uint) {
    //     require(msg.sender == caseOwner, "You are not authorized to register this case on behalf of the plaintiff account specified."); // can only register case from account associated with plaintiff (maybe change?)
    //     //require(CivilCases[caseId].caseOwner == null || CivilCases[caseId.caseOwner == msg.sender, "You are not authorized to amend information for this case."]) // ensure case not already registered
    //     //Implement registerCivilCase
    //     caseCounter.increment();
    //     uint caseId = caseCounter.current();
      
    //     fundingDeadline = now + 30 days;
      
    //     CivilCases[caseId] = CivilCase(caseOwner, caseArea, caseDescription, defendant, firm, fundingAmount, fundingDeadline);

    //     return caseId;
    //     }
//-------------------------Bidding-------------------------------------------------------------------------
    //-----------------------Law Firm Actions-------------------------------------------------------------
        
    function registerLawFirm(
        string memory firmName,
        string memory practceArea,
        string memory state,
        string memory city,
        string memory message) public returns(uint) {
        
        firmCounter.increment();
        uint firmID = firmCounter.current();
        
        //_setTokenURI(firmID, firmURI);
        
        firms[firmID] = LawFirm(msg.sender,firmName, practceArea, state, city, message);
        
        return firmID;
        }
        
    // function submitBid(address payable lawFirm,
    //     string memory firmName,
    //     uint firmID,               // can probably cut one or two of these, but I'll leave them in in case we want to require that the three values match in our firms mapping
    //     uint caseId,                        // maybe a list of bids isn't worth putting on-chain
    //     uint lumpSumBid,
    //     uint equityBid,
    //     uint fundingDeadline,
    //     string memory message) public returns(uint) {
    //     require(msg.sender == lawFirm, "You are not authorized to submit this bid based on your provided credentials.");
    //     bidCounter.increment();
    //     uint bidID = bidCounter.current();

    //     //address payable _plaintiff = CivilCases[caseId].plaintiff;
    //     //_setTokenURI(bidID, bidURI);
    //     bids[caseId] = Bid(bidID, msg.sender, firmID, firmName, lumpSumBid, equityBid, fundingDeadline, message);
    //     // Citation: https://ethereum.stackexchange.com/questions/62824/how-can-i-build-this-list-of-addresses
    //     return bidID;
    //     //emit bidPlaced(caseId);    
    //     }
     }