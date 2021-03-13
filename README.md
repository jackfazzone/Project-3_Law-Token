# Project-3_Law-Token

![introductions](Images/s1.png)

## Members
* Jexi Amaris
* Anthony "Jack" Fazzone
* Gonzalo Garcia
* Olanrewaju Ogubufunmi
<br><br>

![why](Images/s2.png)

## Description
<p>In civil litigation, when a potential plaintiff does not wish, or is not able, to foot the cost of legal services up front, many attorneys will elect to take a share of the possible judgment instead (~30% in many cases) on a contingency basis. In this way, the plaintiff is not required to pay anything if the case is not won. Law Token attempts facilitate third-party investments in these lawsuits, whereby Ether is offered to cover legal and other expenses in the case in exchange for tokenized equity in the judgment, should the case win. We hypothesize that in pooling the risk inherent to contingency payouts, Law Token would permit plaintiffs to secure funding without having to sell as much equity as 30%, a savings in the equity of the ultimate judgment which becomes especially important for cases involving high medical expenses resulting from injury, worker's compensation, and other lawsuits in which a large portion of the ultimate judgment essential to properly compensating the plaintiff.</p>

<br>
<h2> Project Pipeline</h2>

![Token](Images/s3.png)
	
![case](Images/s4.png)
* To start the process the plaintiff or the attorney need to register de civil case inputting some information about the case such as case description, area, defendant, firm, funding amount needed to proceed with the case, and funding deadline. Squire has a policy of 30 days deadline after register the civil case to complete the funding.
Registration civil case allows potential investors to decide weather or not they want to invest in a specific case.

![bidding](Images/s5.png)

![functions](Images/s6.png)
* The function funding amount has some restrictions such as the maximum amount an investor can invest is the asking funding amount or the reminder to complete the funding amount. Also, the account balance must be equal to funding amount to proceed with the case.
* Cancel civil case will be activated if the funding amount did not reach the asking amount. In that ase the LAWT will be return to investors.
* Withdraw function allows the plaintiff or attorney to used the fund to cover the case expenses. In addition, the withdraw amount must be a maximum a fifth of the account balance and each withdraw have to be five days apart otherwise the account will be block. 
  
## Minting
![minting](Images/s7.png)

Our goal is to grant equity in judgments to attorneys and investors

There are three key roles in the process
* The attorneys firm; who grants representation to the custodian 
* SQUIRE, who in his role of Custodian holds the assets and the keys to mint tokens. 
* Investors - Who are the holders of the wrapped token. 

Once the value determined for the civil case is reached we crowd sale and mint LAW-T tokens that represent equity in judgment

SQUIRE exchanges assets for wrapped tokens with investors and this is done through minting LAW-T tokens 

How to implement the system ?  
• The custodian (Squire) has the ability to mint exchangeable fungible tokens on Ethereum 
• Squire is the sole role that can mint tokens 
• The contract is built on ERC20  to meet standardization 
• To issue secured contracts, we integrate the OpenZeppelin library 
• Investors can use tokens to transfer and transact like any other token in the Ethereum ecosystem
• All These transactions are public and available in the blockchain and can be viewed transparently by anyone through a block explorer.

## Settlement
![Improvements](Images/s9.png)

III. Once judgment ETH reaches contract, distribute balance according to addresses' respective equity<br>

IV. Bundled equities in numerous cases to further diversify risk and facilitate financing<br><br>


## Conclusion & Potential Additions

![Improvements](Images/s8.png)
Conclusion 
* Squire offers to host the funding and distribution of settlements of civil cases through smarts contracts which make more efficient the process as well as reduce the cost and the risk of the investment.
* Also, since the term of the investments are written in a smart contract, the parties involve can trust the system.



