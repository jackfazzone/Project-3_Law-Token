pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

import "./LawToken.sol"

/**

    ERC721 Token URI JSON Schema

    {
        "title": "A Law Firm Bid",
        "type": "object",
        "properties": {
            "CaseURI": {
                "type": "string",
                "description": thecasesuri  // Which we will receive from the emission when the CivilCase is listed
            "Law Firm": {
                "type": "string",
                "description": "A Law Firm"
            },
            "Attorney": {
                "type": "string",
                "description": "Anne Attorney"
            },
            "Date": {
                "type": "uint",
                "description": 03062021
            },
            "Lump Sum Bid": {
                "type": "uint",
                "description": 2500         // This, minus any funding the plaintiff puts in, will ultimately be the crowdsale goal, should the bid be accepted
            },
            "Equity Bid": {
                "type": "uint",
                "description": 10           // This will ultimately be the number of the 100 minted that are distributed to the attorney, should the bid be accepted
            },
            "Optional Message": {
                "type": "string",
                "description" : "Hello, I am Anne Attorney from A Law Firm, and I have been representing..." // Introduction stuff, and if they they want to give an estimate on the settlement, they can 
                
            // Pople could add to the public register? Not sure.
        }
    }

**/

contract ALawFirm {
    
    address payable lawFirm;
    address payable attorney;
    uint private lumpSumBid;
    uint private equityBid;
    string private fundingDeadline;
    string private message;      // Optional Message
    
    constructor ERC721Full("ALawFirmBid", "ABID") public { }
    
    using Counters for Counters.Counter;
    Counters.Counter token_ids;

    struct Law Firm {
        address payable lawFirm;
        uint cases;
        uint casesWon;
        // uint inCourt;
        // uint outCourt;
        // uint medianFee;
        // uint medianEquity;
    } 
    
    mapping(uint => Firm) public firms;
    
    event Accident(uint token_id, string report_uri);

    function registerLawFirm(address lawFirm, string memory msg.sender, string memory token_uri) public returns(uint) {
        require(msg.sender !in )
        token_ids.increment();
        uint token_id = token_ids.current();

        _mint(lawFirm, token_id);
        _setTokenURI(token_id, token_uri);

        firms[token_id] = Firm(msg.sender, 0);

        return token_id;
    }

    function reportCaseResult(uint token_id, string memory report_uri) private returns(uint) {
        firms[token_id].cases += 1;

        // Permanently associates the report_uri with the token_id on-chain via Events for a lower gas-cost than storing directly in the contract's storage.
        emit Result(token_id, report_uri);

        return cars[token_id].accidents;
        
        
        
        //address payable _lawFirm, address payable _attorney, uint _lumpSumBid, uint _equityBid, string fundingDeadline string _message) private {
        lawFirm = _lawFirm;
        attorney = _attorney;
        lumpSumBid = _lumpSumBid;
        equityBid = _equityBid;
        message = _message;
    }
    
    function sumbitBid()
        require(msg.sender == lawFirm || msg.sender == attorney, "You are not authorized to submit this bid on based on your provided credentials. Please re-enter your firm and attorney addresses and try again.");
}

// Art Auction
