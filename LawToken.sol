pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

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
    
    constructor() ERC721Full("LawToken", "CLS") public {}
    
    using Counters for Counters.Counter;
    Counters.Counter tokenCounter;

    struct CivilCase {
      //Implement CivilCases struct
      address caseOwner;
      string caseDescription;
      string eventLocation;
      string eventDate;
      string plaintiffInjury;
      string defendant;
      uint damageEstimatedValue;
      uint EstimatedSettlement;
      string lawFirm;
      string attorney;
      uint fundingAmount;
      uint fundingDeadline;
      uint setllementPercentageSplit;
      string attorneyIncentiveFeeStructure;
    }

    // Stores tokenCounter => CivilCase
    // Only permanent data that you would need to use in a smart contract later should be stored on-chain
    mapping(uint => CivilCase) public CivilCases;
    
   function registerCivilCase(
      address payable caseOwner,
      string memory caseDescription,
      string memory eventLocation,
      string memory eventDate,
      string memory plaintiffInjury,
      string memory defendant,
      uint damageEstimatedValue,
      uint EstimatedSettlement,
      string memory lawFirm,
      string memory attorney,
      uint fundingAmount,
      uint fundingDeadline,
      uint setllementPercentageSplit,
      string memory attorneyIncentiveFeeStructure
        ) public returns(uint) {
      //Implement registerCivilCase
      tokenCounter.increment();
      uint caseId = tokenCounter.current();
      
      fundingDeadline = now + 30 days;
      
      _mint(caseOwner, caseId);
      
      CivilCases[caseId] = CivilCase(caseOwner, caseDescription, eventLocation, eventDate, plaintiffInjury,
        defendant, damageEstimatedValue, EstimatedSettlement, lawFirm, attorney, fundingAmount, fundingDeadline, setllementPercentageSplit,
        attorneyIncentiveFeeStructure);

        return caseId;
        }
        
    // funding the civil case 
    function fundingcase() public payable {
        require(msg.value < CivilCases[caseId].fundingAmount, "The amount to invest exceeded the asking funding.");
        caseBalance = address(this).balance;
        require(CivilCases[caseId].fundingAmount == caseBalance, "The civil case has not be funded");
        
    }
    
    /// Withdraw the funding.
    function withdraw() public{
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
    
    function endFunding() public{
        require(CivilCases.fundingAmount < address(this).balance, "Civil case has been funded.");
        require(msg.sender == CivilCases[caseId].caseOwner, "You are not the case owner!");
        
        ended = true;
        emit fundingEnded(investor, CivilCases[caseId].estimatedSettlement);

        //beneficiary = caseOwner;
        //beneficiary.transfer(estimatedSettlement);
        investor.transfer(CivilCases[caseId].estimatedSettlement);
        
        CivilCases.caseOwner =address(0);
        }
        
    //In case the funding amount is not full fill return the fundings to investors
    function cancelCivilCase() public view returns (uint) {
        return returnFunds[investor];
        }
      
    }
      