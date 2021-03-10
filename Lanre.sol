pragma solidity ^0.5.0;


// Distribution
ntract investmentRemittance {
 
    // Should always return 0! Use this to test your `deposit` function's logic
    function balance() public view returns(uint) {
        return address(this).balance;
    }
    
    
    //calculate investment percentage and create new array   
    function investmentWeighting(uint[] memory investmentAmount, uint[] memory investmentPCT, uint fundingAmount) private {
        for(uint i = 0; i < investmentPCT.length; ++i) {
            investmentPCT[i] = (investmentAmount[i] / fundingAmount);
        }}
        
        
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




