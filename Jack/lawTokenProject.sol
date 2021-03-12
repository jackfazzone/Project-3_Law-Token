pragma solidity ^0.5.0;

import "lawTokenMintable.sol";
import "equityCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";


contract LawToken is Crowdsale, MintedCrowdsale {
    // for the bundled equity, should we just index the cases by a parameter (case area?) and then iterate through and bundle every 20?
    
    //address payable newCaseOwner = 0x8D25F051DDb033DA5424c3af471961298E2C7Abd;
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

    using Counters for Counters.Counter;
    Counters.Counter caseCounter;
    Counters.Counter firmCounter;
    Counters.Counter bidCounter;

// structures 
    struct CivilCase {
      //Implement CivilCases struct
      address payable plaintiff;
      string caseArea;
      string caseDescription;
      string defendant;
      string firm;
      uint firmEquity;
      uint fundingAmount;
      //uint plaintiffEquity ?              
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
        uint bidID;
        uint caseId;
        address payable lawFirm;
        uint firmID;
        string firmName;
        uint lumpSumBid;                                    
        uint equityBid;
        uint fundingDeadline;
        string message;
        
    }

    // Stores tokenCounter => CivilCase
    // Only permanent data that you would need to use in a smart contract later should be stored on-chain
    mapping(uint => CivilCase) public CivilCases;
    mapping(uint => LawFirm) public firms;
    mapping(uint => Bid) private bids;

    event bidPlaced(uint caseId, uint bidID);
    event caseAssigned(uint caseId);
    event caseSentenced(uint tokenId, string reportURI);
    
    constructor(uint rate,
        address payable wallet,
        LawTokenMinting token )  Crowdsale(rate, wallet, token) public { }
  
// What if we list and mint with empty values on the attorney/ firm params and then update them after assignment with an "Attorney Assigned" emission?


    function registerCivilCase(
        address payable caseOwner,
        string memory caseDescription,
        string memory caseArea,
        string memory defendant,
        string memory firm,
        uint firmEquity,
        uint fundingAmount,
        uint fundingDeadline
        ) 
        public returns(uint) {
        require(msg.sender == caseOwner, "You are not authorized to register this case on behalf of the plaintiff account specified."); // can only register case from account associated with plaintiff (maybe change?)
        //require(CivilCases[caseId].caseOwner == null || CivilCases[caseId.caseOwner == msg.sender, "You are not authorized to amend information for this case."]) // ensure case not already registered
        //Implement registerCivilCase
        caseCounter.increment();
        uint caseId = caseCounter.current();
      
        fundingDeadline = now + 30 days;
      
        CivilCases[caseId] = CivilCase(caseOwner, caseArea, caseDescription, defendant, firm, firmEquity, fundingAmount, fundingDeadline);

        return caseId;
        }
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
        
    function submitBid(address payable lawFirm,
        string memory firmName,
        uint firmID,               
        uint caseId,                        
        uint lumpSumBid,
        uint equityBid,
        uint fundingDeadline,
        string memory message) private returns(uint) {
        require(msg.sender == lawFirm, "You are not authorized to submit this bid based on your provided credentials.");
        bidCounter.increment();
        uint bidID = bidCounter.current();
        bids[bidID] = Bid(bidID,caseId, msg.sender, firmID, firmName, lumpSumBid, equityBid, fundingDeadline, message);
        
        emit bidPlaced(caseId,bidID);
        return bidID;
    }
    //------------------------Plaintiff Actions-----------------------------------------------------------------------

    function viewBids(uint caseId, uint bidID) public view returns(uint) {
        require(CivilCases[caseId].plaintiff == msg.sender, "You are not authorized to review bids for this case.");
        
        // Citation:https://ethereum.stackexchange.com/questions/3609/returning-a-struct-and-reading-via-web3/3614#3614
        return bidID;
        // bids[bidID].lawFirm, 
        // bids[bidID].firmID, 
        // bids[bidID].firmName, 
        // bids[bidID].lumpSumBid, 
        // bids[bidID].equityBid, 
        // bids[bidID].fundingDeadline, 
        // bids[bidID].message);
        
    }
    
    function selectBid(uint caseId, uint bidID) public {
        require(CivilCases[caseId].plaintiff == msg.sender, "You are not authorized to assign representation for this case.");
        
        // Citation: https://ethereum.stackexchange.com/questions/62824/how-can-i-build-this-list-of-addresses
        CivilCases[caseId].firm = bids[bidID].firmName;
        CivilCases[caseId].firmEquity = bids[bidID].equityBid;
        CivilCases[caseId].fundingDeadline = bids[bidID].fundingDeadline;
        CivilCases[caseId].fundingAmount = bids[bidID].lumpSumBid;
        
        emit caseAssigned(caseId);
        
    }    

//In case the funding amount is not full fill return the fundings to investors
    function cancelCivilCase(address investor) public view returns (uint) {
        return returnFunds[investor];
        }
    

// funding the civil case
    function fundingcase(uint caseId) public payable {
        require(msg.value < CivilCases[caseId].fundingAmount, "The amount to invest exceeded the asking funding.");
        caseBalance = address(this).balance;
        require(CivilCases[caseId].fundingAmount == caseBalance, "The civil case has not be funded");
    }
    
    /// withdraw to pay attorney and case expenses
    function withdraw(uint caseId) public{
        require( msg.sender == CivilCases[caseId].plaintiff, "You do not own this account");
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

//-----------------------------Distribution----------------------------------------------------------------------------

    function balance() public view returns(uint) {
        return address(this).balance;
    }
    
    
    // depositing settlement in contract (tailor to depositing)
    function deposit(uint SettlementAmount, uint caseId) public payable {
    require(msg.sender == CivilCases[caseId].plaintiff, "You are not authorized to deposit to this contract");
    require(balance() == 0);
    
    SettlementAmount = balance();
  }
  

    //payout function
    function remitSettlement (
        address payable caseOwner,
        address payable beneficiary,
        address payable[] memory recipient,
        uint[] memory investmentX,
        uint SettlementAmount,
        uint firmEquity,
        uint plaintiffEquity)
        public {
        uint acctBal = SettlementAmount / 100;
        uint total;
        uint amount;
        
        // Transfer lawyer equity to lawyer
        amount = acctBal * firmEquity; //change % to variable set in lawyer equity
        total += amount;
        caseOwner.transfer(amount);
        
        //Transfer victim equity to victim
        amount = acctBal * plaintiffEquity; //change % to variable set by lawyer
        total += amount;
        beneficiary.transfer(amount);
        
        //Transfer investors equity to investors
        for (uint i=0; i<recipient.length; i++) {
            recipient[i].transfer(acctBal * (investmentX[i]));
        }
        
        
        //Transfer balance to beneficiary
        beneficiary.transfer(balance());
    }
    

    
// has to be turned on eventually
   function() external payable {}

   
    }