pragma solidity ^0.5.0;

//settlement has to buy the token as well

// Part 3: Distributing the settlement to investors
contract TieredProfitSplitter {
   // address payable investorList; // list containing all the investor addresses
    // total_cont=add all contribution from investorList (for-loop?)
    // OR
    // total_cont is passed from prior
    
            // 1. assume list has unique address
        
        //for each amount in investor list (second column), print (each amount/total contribution) = pct
        
    
       // for i in investorList[1]: //investList should be [(add, cont), (add, cont)]
         //   pct=contr/total_contribution
        // 
        //   amounts=points * pct
        //   each_address.transfer(amount)
        
        
        
        
        
        
    //------------------------------------------------------------------------------------------    

    // Should always return 0! Use this to test your `deposit` function's logic
    function balance() public view returns(uint) {
        return address(this).balance;
    }
    
    
    // function to send settlement to investors    
    // code help: https://ethereum.stackexchange.com/questions/65200/i-am-trying-to-send-ether-to-a-list-of-addresses-from-backend    
    function payout() public payable {
        uint settlement = msg.value; //amount deposited into account split into 100
        uint stake;//percentage to send to send to each investor
        uint total;
        uint amount;
        
        amount = settlement * stake;
        total += amount;
        
        //calculation loop
        
        
        //payout loop
        for (uint i=0; i<investorList.length; i++) {
                 investorList[i].transfer(investorReturns);
        
    }
    
    
    function() external payable {
        payout();
    }
}

