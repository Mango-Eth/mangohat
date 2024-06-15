// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.20;

abstract contract PeripheryValidation {

    function _blockTimestamp() internal view returns(uint256){
        return block.timestamp;
    }

    modifier checkDeadline(uint256 deadline) {
        require(_blockTimestamp() <= deadline, 'Transaction too old');
        _;
    }
}