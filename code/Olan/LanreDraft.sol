pragma solidity ^0.5.0;


// Distribution

//Questions: Will it execute in this order? If not how to create sequence (put it in main contract)
// Sequencing and lists

// figure out inheritance
//4th function (call other functions)
//require in deposit function

contract settlementDistribution  {
    
     // Should always return 0! Use this to test your `deposit` function's logic 
    function balance() public view returns(uint) {
        return address(this).balance;
    }
    
    
    address payable depositorAccount = 0xc3879B456DAA348a16B6524CBC558d2CC984722c;
    
    // depositing settlement in contract (tailor to depositing)
    function deposit(uint SettlementAmount, address payable depositor) public payable {
    require(depositor == depositorAccount, "You are not authorized to deposit to this contract");
    require(balance() == 0);
    
    SettlementAmount = address(this).balance;
  }    
// https://www.tutorialspoint.com/solidity/solidity_arrays.htm
// https://jeancvllr.medium.com/solidity-tutorial-all-about-array-efdff4613694
// https://www.oluwafemialofe.com/posts/build-a-sport-betting-smart-contract-using-oraclize-api  
 

  //calculate investment percentage and create new array
    function investmentWeighting(uint[] memory investmentAmount, uint[] memory investmentPCT, uint fundingAmount) private {
         for(uint i = 0; i < investmentPCT.length; ++i) {
            investmentPCT[i] = (investmentAmount[i] / fundingAmount);
        }}
  
  
//payout loop (utilizing addresses and associated returns)        
//https://ethereum.stackexchange.com/questions/65200/i-am-trying-to-send-ether-to-a-list-of-addresses-from-backend    
//https://ethereum.stackexchange.com/questions/87319/how-can-i-send-ether-to-multiple-address-in-one-transaction-by-paying-one-transa
   
    //payout function
    function remitSettlement (
        address payable caseOwner,
        address payable beneficiary,
        address payable[] memory recipient,
        uint[] memory investmentX,
        uint SettlementAmount)
        public {
        uint acctBal = SettlementAmount / 100;
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
        for (uint i=0; i<recipient.length; i++) {
            recipient[i].transfer(acctBal * (investmentX[i]));
        }
        
        
        //Transfer balance to beneficiary
        beneficiary.transfer(address(this).balance);
    }
    

    
// has to be turned on eventually
   function() external payable {}
}
 