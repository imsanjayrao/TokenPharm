//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenPharm is ERC20 {
    uint constant _initial_supply = 0 * (10**18);
    address owner;
    constructor() ERC20("TokenPharm", "TP") {
        owner = msg.sender;
        _mint(msg.sender, _initial_supply);
    }
    address[] manufacturersList;

    function verifyManufacturer() public view returns (bool){
        for (uint i=0; i<manufacturersList.length; i++){
            if (manufacturersList[i] == msg.sender){
                return true;
            }
        }
        return false;
    }
    function addManufacturer(address manAdd) public {
        require (msg.sender == owner);
        manufacturersList.push(manAdd);
    }


    function manufacturerMinter() public {
        require(verifyManufacturer());
        _mint(msg.sender, 1000);
    }
}