// SPDX-License-Identifier: Built by Mango
pragma solidity ^0.8.20;

import {SafeCast} from "../Oz/utils/math/SafeCast.sol";
import {FullMath} from "../Math/FullMath.sol";
import {TickMath} from "../Math/TickMath.sol";

library SqrtMath {

    using FullMath for uint256;

    uint256 public constant q96 = 2**96;

    function _tickToQ96(int24 tick) internal pure returns(uint160){
        return TickMath.getSqrtRatioAtTick(tick);
    }

    function _sqrtPriceToTick(uint160 sqrtP) internal pure returns(int24){
        return TickMath.getTickAtSqrtRatio(sqrtP);
    }

    function _getInverseQ96(uint160 sqrtP, uint256 d0, uint256 d1) internal pure returns(uint160){
        uint256 erInBase18 = _getErInBase18(sqrtP, d0, d1);  
        uint256 inverse = 1e36 / erInBase18; 
        if(d0 == d1){
            uint256 _q96_ = q96.mulDiv(sqrtu(inverse), sqrtu(1e18));
            return SafeCast.toUint160(_q96_);
        }
        // Inversing decimals:
        inverse = d0 > d1 ? inverse * 10**(d0 - d1) : inverse / 10**(d1 - d0);
        uint256 _q96 = q96.mulDiv(sqrtu(inverse), sqrtu(1e18));
        return SafeCast.toUint160(_q96);
    }

    function _getErInBase18(uint160 sqrtPrice, uint256 d0, uint256 d1) internal pure returns(uint256 price){
        uint8 flag = d1 < d0 ? 0 : 1;
        if(flag == 0){
            uint256 numerator1 =uint256(sqrtPrice) *uint256(sqrtPrice);  
            uint256 numerator2 = 1e18 * 10**(d0-d1); 
            price = FullMath.mulDiv(numerator1, numerator2, 1 << 192);
        } else {
            uint256 numerator1 =uint256(sqrtPrice) *uint256(sqrtPrice);  
            uint256 numerator2 = 1e18 / 10**(d1 -d0);
            uint256 _price = FullMath.mulDiv(numerator1, numerator2, 1 << 192);
            price = _price;
        }
    } 

    function _getQ96(uint256 erInBase18, uint256 d0, uint256 d1) internal pure returns(uint160){
        if(d0 == d1){
            return _x96(erInBase18);
        }else {
            uint8 dir = d1 > d0 ? 1 : 0;
            uint256 sf = dir == 1 ? 10**(d1 - d0) : 10**(d0 - d1);
            uint256 scaledExchangeRate = dir == 1 ? erInBase18 * sf : erInBase18 / sf;
            return _x96(scaledExchangeRate);
        }
    }


    function _x96(uint256 er) internal pure returns(uint160){
        return SafeCast.toUint160(q96.mulDiv(sqrtu(er), sqrtu(1e18)));
    }

    ///@notice Price must be represented in 18 decimals.
    function _tknToDollar(uint256 price, uint256 tknAmount) internal pure returns(uint256) {
        return (price * tknAmount) / 1e18;
    }

    ///@notice Price must be represented in 18 decimals.
    function _dollarToTkn(uint256 price, uint256 dollarAmount) internal pure returns(uint256){
        return (dollarAmount * 1e18) / price;
    }

    function sqrtu (uint256 x) internal pure returns (uint128) {
        unchecked {
          if (x == 0) return 0;
          else {
            uint256 xx = x;
            uint256 r = 1;
            if (xx >= 0x100000000000000000000000000000000) { xx >>= 128; r <<= 64; }
            if (xx >= 0x10000000000000000) { xx >>= 64; r <<= 32; }
            if (xx >= 0x100000000) { xx >>= 32; r <<= 16; }
            if (xx >= 0x10000) { xx >>= 16; r <<= 8; }
            if (xx >= 0x100) { xx >>= 8; r <<= 4; }
            if (xx >= 0x10) { xx >>= 4; r <<= 2; }
            if (xx >= 0x8) { r <<= 1; }
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1;
            r = (r + x / r) >> 1; 
            uint256 r1 = x / r;
            return uint128 (r < r1 ? r : r1);
          }
        }
      }
}