//SPDX-License-Identifier: Built by Mango
pragma solidity ^0.8.20;

import {Create3} from "../Miscellaneous/Create3.sol"; 
import {MockERC20} from "./MockERC20.sol";

contract DeterministicToken {

    address immutable internal OWNER;

    constructor() {
        OWNER = msg.sender;
    }

    // DAI < USDC < WETH

    /////////////////////////////////////////////////////
    //              External:                          //
    /////////////////////////////////////////////////////

    function deploySingle(
        string memory _token_Name,
        string memory _token_Symbol,
        uint8 _decimal,
        string memory _token_Salt
    ) external onlyOwner {
        bytes32 hash_tkn = keccak256(abi.encodePacked(_token_Salt));
        address address_tkn = _address3(hash_tkn);

        bytes memory bytecode = type(MockERC20).creationCode;
        bytes memory args = abi.encode(_token_Name, _token_Symbol, _decimal);

        bytecode = bytes.concat(bytecode, args);
        _deploy(address_tkn, bytecode, 0, hash_tkn);
    }

    function deploySingle(
        string memory _token_Name,
        string memory _token_Symbol,
        uint8 _decimal,
        bytes32 _token_Salt
    ) external onlyOwner {
        bytes32 hash_tkn = _token_Salt;
        address address_tkn = _address3(hash_tkn);

        bytes memory bytecode = type(MockERC20).creationCode;
        bytes memory args = abi.encode(_token_Name, _token_Symbol, _decimal);

        bytecode = bytes.concat(bytecode, args);
        _deploy(address_tkn, bytecode, 0, hash_tkn);
    }

    // Head start on stable coins:
    function deploy(
        string memory salt_dai,
        string memory salt_usdc,
        string memory salt_weth
    ) external onlyOwner {
        bytes32 hash_tkn = keccak256(abi.encodePacked(salt_dai));
        address address_tkn = _address3(hash_tkn);

        bytes memory bytecode = type(MockERC20).creationCode;
        bytes memory args = abi.encode("DAI", "DAI", 18);
        bytecode = bytes.concat(bytecode, args);
        _deploy(address_tkn, bytecode, 0, hash_tkn);

        {
            hash_tkn = keccak256(abi.encodePacked(salt_usdc));
            address_tkn = _address3(hash_tkn);

            bytecode = type(MockERC20).creationCode;
            args = abi.encode("USDC", "USDC", 6);
            bytecode = bytes.concat(bytecode, args);
            _deploy(address_tkn, bytecode, 0, hash_tkn);
        }
        __deploy(salt_weth);
    }

    function __deploy(string memory s) internal {
        bytes32 hash_tkn = keccak256(abi.encodePacked(s));
        address address_tkn = _address3(hash_tkn);

        bytes memory bytecode = type(MockERC20).creationCode;
        bytes memory args = abi.encode("WETH", "WETH", 18);
        bytecode = bytes.concat(bytecode, args);
        _deploy(address_tkn, bytecode, 0, hash_tkn);
    }

    function address3(
        string memory _str
    ) external view returns(address){
        return _address3(keccak256(abi.encodePacked(_str)));
    }

    // Convenience
    function address3(
        bytes32 _salt
    ) external view returns(address){
        return _address3(_salt);
    }

    /////////////////////////////////////////////////////
    //              Internal-Pure-Modifier:            //
    /////////////////////////////////////////////////////

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

    modifier onlyOwner {
        require(OWNER == msg.sender, "AD: NOPE");
        _;
    }
}