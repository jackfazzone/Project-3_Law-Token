pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";



contract LawToken is ERC721Full {
    // for the bundled equity, should we just index the cases by a parameter (case area?) and then iterate through and bundle every 20?
     // bool public ended;
    //address payable public caseOwner;
    bool public ended;
    //uint fundingAmount;
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

    constructor() ERC721Full("LawToken", "CLS") public { }

    using Counters for Counters.Counter;
    Counters.Counter caseCounter;
    Counters.Counter firmCounter;
    Counters.Counter bidCounter;
    Counters.Counter fundingCounter;
    Counters.Counter withdrawCounter;
    

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
        uint caseId;
        address payable lawFirm;
        uint firmID;
        string firmName;
        uint lumpSumBid;                                    // probably don't want to use a struct for this 
        uint equityBid;
        uint fundingDeadline;
        string message;
        
    
    }

    // Stores tokenCounter => CivilCase
    // Only permanent data that you would need to use in a smart contract later should be stored on-chain
    mapping(uint => CivilCase) public CivilCases;
    mapping(uint => LawFirm) public firms;
    mapping(uint => Bid) private bids;

    event bidPlaced(uint caseId);
    event caseAssigned(uint caseId);
    event caseSentenced(uint tokenId, string reportURI);
  
// What if we list and mint with empty values on the attorney/ firm params and then update them after assignment with an "Attorney Assigned" emission?


    function registerCivilCase(address payable caseOwner,
        string memory caseArea,
        string memory caseDescription,
        string memory eventLocation,
        string memory eventDate,
        string memory plaintiffInjury,
        string memory defendant,
        uint totalSuitExpenses,             // given by assigned attorney or average?
        string memory firmName,
       // address payable lawFirm,
        string memory attorney,             
        uint fundingAmount,                 // up-front cash bid of winning firm (crowdsale goal)
        uint firmEquity,                    
        uint fundingDeadline,
        string memory estimatedRangeSettlement,
        uint setllementPercentageSplit,
        string memory attorneyIncentiveFeeStructure 
        
        //string memory caseURI
        ) 
        public returns(uint) {
        require(msg.sender == caseOwner, "You are not authorized to register this case on behalf of the plaintiff account specified."); // can only register case from account associated with plaintiff (maybe change?)
        //require(CivilCases[caseId].caseOwner == null || CivilCases[caseId.caseOwner == msg.sender, "You are not authorized to amend information for this case."]) // ensure case not already registered
        //Implement registerCivilCase
        caseCounter.increment();
        uint caseId = caseCounter.current();
      
        fundingDeadline = now + 30 days;
      
        ///_mint(caseOwner, caseId, 0);
              
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
        //_setTokenURI(firmID, firmURI);
        
        firms[firmID] = LawFirm(msg.sender,firmName, practceArea, state, city, message, 0);
        
        return firmID;
        }
        
    function submitBid(address payable lawFirm,
        string memory firmName,
        string memory firmID,               // can probably cut one or two of these, but I'll leave them in in case we want to require that the three values match in our firms mapping
        uint caseId,                        // maybe a list of bids isn't worth putting on-chain
        uint lumpSumBid,
        uint equityBid,
        uint fundingDeadline,
        string memory message,
        
        string memory bidURI) private returns(uint) {
        
        require(msg.sender == lawFirm, "You are not authorized to submit this bid based on your provided credentials.");
        
        bidCounter.increment();
        uint bidID = bidCounter.current();
        
        address payable _plaintiff = CivilCases[caseId].caseOwner;

        _mint(_plaintiff, bidID);
        //_setTokenURI(bidID, bidURI);
        
        // Citation: https://ethereum.stackexchange.com/questions/62824/how-can-i-build-this-list-of-addresses
        bids[caseId].push(Bid(bidID, msg.sender, firmID, firmName, lumpSumBid, equityBid, fundingDeadline, message));
        
        return bidID;
        emit bidPlaced(caseId);
        
    }

    function viewBids(uint caseId) public {
        require(CivilCases[caseId].caseOwner == msg.sender, "You are not authorized to review bids for this case.");
        
        return bids[caseId];
    }
    
    function selectBid(uint caseId, uint bidID) public {
        require(CivilCases[caseId].caseOwner == msg.sender, "You are not authorized to assign representation for this case.");
        
        // Citation: https://ethereum.stackexchange.com/questions/62824/how-can-i-build-this-list-of-addresses
        CivilCases[caseId].firmName = bids[caseId][bidID].firmName;
        CivilCases[caseId].firmEquity = bids[caseId][bidID].firmEquity;
        CivilCases[caseId].fundingDeadline = bids[caseId][bidID].fundingDeadline;
        CivilCases[caseId].fundingAmount = bids[caseId][bidID].lumpSumBid;
        
        emit caseAssigned(caseId);
        
    }    
    
// funding the civil case
    function fundingcase( uint newFundingAmount) public payable {
        fundingCounter.increment();
        uint fundingRef = fundingCounter.current();
        CivilCases[fundingRef] = CivilCase( newFundingAmount);
        require(msg.value < CivilCases[fundingRef].newFundingAmount, "The amount to invest exceeded the asking funding.");
        caseBalance = address(this).balance;
        require(CivilCases[fundingRef].newFundingAmount == caseBalance, "The civil case has not be funded");
    }
    
     /// withdraw to pay attorney and case expenses
    function withdraw(address payable newcaseOwner) public{
        withdrawCounter.increment();
        uint withdrawgRef = withdrawCounter.current();
        CivilCases[withdrawgRef] = CivilCase( newcaseOwner);
        require( msg.sender == CivilCases[withdrawgRef].newcaseOwner, "You do not own this account");
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
    function cancelCivilCase(address investor) public view returns (uint) {
        return returnFunds[investor];
        }
    }
        
///---------------------------Minting--------------------------------------------------------------------------------------
        
contract LawTokenMinting is ERC20, ERC20Detailed {
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

///---------------------------------------------------------------------------------------------

// Distribution
contract investmentRemittance is ERC721Full  {
    // Should always return 0! Use this to test your `deposit` function's logic
    function balance() public view returns(uint) {
        return address(this).balance;
    }
    //calculate investment percentage and create new array
    // function investmentWeighting(uint[] memory investmentAmount, uint[] memory investmentPCT, uint fundingAmount) private {
    //     for(uint i = 0; i < investmentPCT.length; ++i) {
    //         investmentPCT[i] = (investmentAmount[i] / fundingAmount);
    //    }}
    //payout function
    function remitSettlement (
        address payable caseOwner,
        address payable beneficiary,
        address payable[] memory investorList,
        uint[] memory investmentPCT)
        public {
        uint acctBal = (address(this).balance) / 100;
        uint total;
        uint amount;
        // Transfer lawyer equity to lawyer
        amount = acctBal * 10; //change % to variable set in lawyer equity
        total += amount;
        caseOwner.transfer(amount);
        //Transfer victim equity to victim
        amount = acctBal * 10; //change % to variable set by lawyer
        total += amount;
        beneficiary.transfer(amount);
        //Transfer investors equity to investors
        for (uint i=0; i<investorList.length; i++) {
            investorList[i].transfer(acctBal * (investmentPCT[i]));
        }
        //Transfer balance to beneficiary
        beneficiary.transfer(address(this).balance);
    }
// has to be turned on eventually
   //function() external payable {}
}
 