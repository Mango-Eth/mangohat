// SPDX-License-Identifier: Built by Mango
pragma solidity ^0.8.20;

import {ERC20} from "../Oz/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {

    uint8 immutable private _decimals_;

    constructor(
        string memory _name,
        string memory _symb,
        uint8 _decimals
    ) ERC20(_name, _symb) {
        _decimals_ = _decimals;
    }

    function decimals() public override view returns(uint8){
        return _decimals_;
    }

    function mint(uint256 _amount) external {
        _mint(msg.sender, _amount);
    }

}