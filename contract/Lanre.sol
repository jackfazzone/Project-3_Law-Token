pragma solidity ^0.5.0;

// Part 3: Distributing the settlement to investors
//If funding is met, send ether to lawyer
//Once judgement is rendered and contract is funded, distribute settlement to investors

contract Trial {
        
    //------------------------------------------------------------------------------------------    

    // Should always return 0! Use this to test your `deposit` function's logic
    function balance() public view returns(uint) {
        return address(this).balance;
    }
    
    //------------------------------------------------------------------------------------------   
    //calculate investment percentage and create new array   
   
    // https://www.tutorialspoint.com/solidity/solidity_arrays.htm
    // https://jeancvllr.medium.com/solidity-tutorial-all-about-array-efdff4613694
    // https://www.oluwafemialofe.com/posts/build-a-sport-betting-smart-contract-using-oraclize-api
        
    
    function investmentWeighting(uint[] storage investmentPCT) public {
        for(uint i = 0; i < investmentPCT.length; ++i) {
            investmentPCT[i] = investmentAmount[i] / fundingAmount;
    }
        
    //------------------------------------------------------------------------------------------           
    //payout loop (utilizing addresses and associated returns)        
    //https://ethereum.stackexchange.com/questions/65200/i-am-trying-to-send-ether-to-a-list-of-addresses-from-backend    
    //https://ethereum.stackexchange.com/questions/87319/how-can-i-send-ether-to-multiple-address-in-one-transaction-by-paying-one-transa
    function payout() public payable {
        for (uint i=0; i<investorList.length; i++) {
            investorList[i].transfer(settlement * investmentPCT[i]);}
                 
        msg.sender.transfer(address(this).balance);
        
        
    }
    
    function () external payable {payout();
    }
}

