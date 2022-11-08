//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenPharm is ERC20 {
    // uint constant _initial_supply = 10000 * (10**18);
    address owner;
    // Example Token Symbols - 
    // i. 0x666f6f0000000000000000000000000000000000000000000000000000000000
    // ii. 0x6261720000000000000000000000000000000000000000000000000000000000
    // iii. 0x666f6f0000000000000000000000000000000000000000000000000000000000
    // iv. 0x6261720000000000000000000000000000000000000000000000000000000000
    bytes32[] tokenSymbols;
    mapping (bytes32 => uint256) tokens;
    mapping(bytes32 => uint256) public TokenPoolForDoctors;
    address[] manufacturersList;
    address[] doctorsList;
    address[] suppliersList;

    constructor() ERC20("TokenPharm", "TP") {
        owner = msg.sender;
    }

    function verifyManufacturer() public view returns (bool){
        for (uint i=0; i<manufacturersList.length; i++){
            if (manufacturersList[i] == msg.sender){
                return true;
            }
        }
        return false;
    }

    function verifyDoctor() public view returns (bool){
        for (uint i=0; i<doctorsList.length; i++){
            if (doctorsList[i] == msg.sender){
                return true;
            }
        }
        return false;
    }

    function verifySuppliers() public view returns (bool){
        for (uint i=0; i<suppliersList.length; i++){
            if (doctorsList[i] == msg.sender){
                return true;
            }
        }
        return false;
    }

    function addManufacturer(address manAdd) public {
        require (msg.sender == owner);
        manufacturersList.push(manAdd);
    }

    function addDoctor(address manAdd) public {
        require (msg.sender == owner);
        doctorsList.push(manAdd);
    }

    function addTokenSymbol(bytes32 symbol) public {
        require (msg.sender == owner);
        tokenSymbols.push(symbol);
    }

    function manufacturerMinter(uint256 tokenCount) public payable {
        require(verifyManufacturer());
        _mint(msg.sender, tokenCount);
    }

    // receive() external payable {
    //     balances[msg.sender]['TP'] += msg.value;
    // }

    function depositTokensToSupplier(uint256 amount, bytes32 symbol, address supplier) public {
        require(verifyManufacturer());
        transferFrom(msg.sender, supplier, amount);
        TokenPoolForDoctors[symbol] += amount;
    }

    function withdrawTokensDoctors(uint256 amount, bytes32 symbol) public {
        require(verifyDoctor());
        require(TokenPoolForDoctors[symbol] >= amount, "Insufficient Tokens");
        TokenPoolForDoctors[symbol] -= amount;
        transferFrom(owner, msg.sender, amount);
    }

    function getTokenBalance(bytes32 symbol) public view returns (uint256){
        return TokenPoolForDoctors[symbol];
    }

    function getOwner() public view returns (address){
        return owner;
    }

    function TokenTransferToPaient(uint256 tokenCount, address patient) public {
        transferFrom(msg.sender, patient, tokenCount);
    }
}