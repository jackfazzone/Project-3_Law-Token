function balance() public view returns(uint) {
        return address(this).balance;
    }
    
    
    // depositing settlement in contract (tailor to depositing)
    function deposit(uint SettlementAmount, uint caseId) public payable {
    require(msg.sender == CivilCases[caseId].caseOwner, "You are not authorized to deposit to this contract");
    require(balance() == 0);
    
    SettlementAmount = balance();
  }
  

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
        beneficiary.transfer(balance());
    }
    

    
// has to be turned on eventually
   function() external payable {}

   
    }
    