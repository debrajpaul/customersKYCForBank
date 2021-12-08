pragma solidity ^0.8.10;

contract AccessModifier {
    
    address public admin;
    
    constructor() {
        admin = msg.sender;
    }
    
    modifier isAdmin() {
        require(admin != msg.sender, "Only Admin can add bank");
        _;
    }
}