// SPDX-License-Identifier: Built by Mango
pragma solidity ^0.8.20;

import {Create3} from "./Create3.sol";
import {MockERC20} from "../Mocks/MockERC20.sol";

contract Create3Factory {

    function deploy(
        address expectedAdd1,
        address expectedAdd2,
        string memory _saltStr1,
        string memory _saltStr2,
        uint256 _value
    ) external {

        bytes32 salt1 = keccak256(abi.encodePacked(_saltStr1));
        bytes32 salt2 = keccak256(abi.encodePacked(_saltStr2));

        bytes memory bytecode = type(MockERC20).creationCode;
        bytes memory args = abi.encode("Curve", "CRV");
        bytecode = bytes.concat(bytecode, args);

        _deploy(
            expectedAdd1,
            bytecode,
            _value,
            salt1
        );

        _deploy(
            expectedAdd2,
            bytecode,
            _value,
            salt2
        );
    }

    function _deploy(
        address _checkAddress,
        bytes memory _createionCode,
        uint256 _value,
        bytes32 salt
    ) private {
        address a = Create3.create3(
            salt,
            _createionCode,
            _value
        );
        require(a == _checkAddress);
    }

    function _address3(
        bytes32 salt
    ) private view returns(address) {
        return Create3.addressOf(salt);
    }

    function address3(
        string memory _str
    ) external view returns(address){
        return _address3(keccak256(abi.encodePacked(_str)));
    }
}