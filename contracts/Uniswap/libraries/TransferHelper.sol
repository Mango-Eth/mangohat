// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import {IERC20Minimal} from '../../Interfaces/IERC20Minimal.sol';
import {IERC20} from "../../Oz/token/ERC20/IERC20.sol";

/// @title TransferHelper
/// @notice Contains helper methods for interacting with ERC20 tokens that do not consistently return true/false
library TransferHelper {
    error TF();

    /// @notice Transfers tokens from msg.sender to a recipient
    /// @dev Calls transfer on token contract, errors with TF if transfer fails
    /// @param token The contract address of the token which will be transferred
    /// @param to The recipient of the transfer
    /// @param value The value of the transfer
    function safeTransfer(
        address token,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(IERC20Minimal.transfer.selector, to, value)
        );
        if (!(success && (data.length == 0 || abi.decode(data, (bool))))) revert TF();
    }

    /// @notice Transfers ETH to the recipient address
    /// @dev Fails with `STE`
    /// @param to The destination of the transfer
    /// @param value The value to be transferred
    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'STE');
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
        (bool success, bytes memory data) =
        token.call(abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');
    }
}
