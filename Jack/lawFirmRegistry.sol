pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC721/ERC721Full.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/drafts/Counters.sol";

import "./LawToken.sol"

contract lawFirmRegistry is ERC721Full {
    
    address payable lawFirm;
    string public name;
    string public practiceArea  // Optional
    string public attorneys;    // Optional
    string public message;      // Optional Message
    
    // Future note: Historical outcomes
    
    constructor() ERC721Full("FirmToken", "FTKN") public { }
    
    using Counters for Counters.Counter;
    Counters.Counter token_ids;
    Counters.Counter bid_ids
    

    struct LawFirm {
        address memory payable lawFirm;
        string public firmName;
        string public cityState;
        
        
        // uint memory numberOfCases;
        // uint public casesWon;
        // uint public inCourt;
        // uint public outCourt;
        // uint medianRecovery
        // uint private medianFee;
        // uint private medianEquity;
    } 
    
    mapping(uint => Firm) public lawFirmRegistry;
    
    event Bid(uint token_id, string report_uri);
    
    event Assigned(uint token_id, string report_uri);
    
    event Result(uint token, string report_uri);

    function registerLawFirm(string public firmName, string public cityState, address memory firmAddress, string memory token_uri) public returns(uint) {
        require(firmAddress == msg.sender, "Your are not authorized to register this law firm based on your provided credentials. Please log in and try again.")
        require(msg.sender !in lawFirmRegistry.memory, "Law firm already registered. Please log in.") // figure out how to code this
        
        token_ids.increment();
        uint token_id = token_ids.current();

        _mint(name or msg.sender, token_id);      // trying to get it so that you can have your name associated with your token but someone couldn't just register their firm as the same name as yours and outbid you.
        _setTokenURI(token_id, token_uri);

        lawFirmRegistry[token_id] = Firm(name or msg.sender, 0);

        return token_id;
    }
    
    function submitBid(string civilCaseURI, string firmName, string token_id) private returns(uint) {
        require(token_id in memory, "Law firm not registered. Please register firm with the registerLawFirm function.") // figure out how to code
        require(civilCaseURI in memory, "Case URI not recognized. Please try again.")
        constructor(address memory payable lawFirm;
        string public firmName;
        string public cityState;
        
        
        // uint public cases;
        // uint public casesWon;
        // uint public inCourt;
        // uint public outCourt;
        // uint medianRecovery
        // uint private medianFee;
        // uint private medianEquity;)
        
        return bid_uri
    }
    function assignFirm(string memory name, string memory report_uri) private returns(uint) {

    function reportCaseResult(uint token_id, string memory report_uri) private returns(uint) {
        lawFirmRegistry[token_id].cases += 1;

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
