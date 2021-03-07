  // ERC 721 token to outline the details of the case itself, act as escrow during funding, deploy ERC20 Crowdsale
  // ERC 20 tokens to represent investor, attorney, and plaintiff equities
  
  
  
  
  
    function listCivilCase(address payable caseOwner,
        string caseType,
        string caseDescription,
        string eventLocation,
        string eventDate,
        string plaintiffInjury,
        string defendant) memory returns
        
            
    function submitBid(address payable caseOwner,
        string lawFirm,
        address lawFirm,                    // we need some way to have it recognize the attorney (msg.sender) as being from a group of addresses belonging to a law firm
        string attorney,
        address attorney,                   
        uint fundingAmount,                 // Lump sum bid
        uint setllementPercentageSplit,     // Equity bid
        uint estimatedSettlement,
        uint fundingDeadline
        
        string bidRUI) memory returns(uint)
        //Implement registerCivilCase
        tokenCounter.increment();
        uint caseId = tokenCounter.current(); 