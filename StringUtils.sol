pragma solidity ^0.8.7;

/* 
 * String shenanigans
 * Author: Zac Williamson, AZTEC
 * Licensed under the Unlicense
 */
 
contract StringUtils
{
    function convertUint256ToBase10String(uint256 input) public pure returns (string memory result) {
        assembly {
            // Clear out some low bytes
            result := mload(0x40)
            if lt(result, 0x160)
            {
                result := 0x160
            }
            mstore(add(result, 0xa0), mload(0x60))
            mstore(add(result, 0xc0), mload(0x80))
            mstore(add(result, 0xe0), mload(0xa0))
            mstore(add(result, 0x100), mload(0xc0))
            mstore(add(result, 0x120), mload(0xe0))
            mstore(add(result, 0x140), mload(0x100))
            mstore(add(result, 0x160), mload(0x120))
            mstore(add(result, 0x180), mload(0x140))

            // Store lookup table that maps an integer from 0 to 99 into a 2-byte ASCII equivalent
            mstore(0x00, 0x0000000000000000000000000000000000000000000000000000000000003030)
            mstore(0x20, 0x3031303230333034303530363037303830393130313131323133313431353136)
            mstore(0x40, 0x3137313831393230323132323233323432353236323732383239333033313332)
            mstore(0x60, 0x3333333433353336333733383339343034313432343334343435343634373438)
            mstore(0x80, 0x3439353035313532353335343535353635373538353936303631363236333634)
            mstore(0xa0, 0x3635363636373638363937303731373237333734373537363737373837393830)
            mstore(0xc0, 0x3831383238333834383538363837383838393930393139323933393439353936)
            mstore(0xe0, 0x3937393839390000000000000000000000000000000000000000000000000000)

            // Convert integer into string slices
            function slice(v) -> y {
            y :=
                add(add(add(
                    add(and(mload(shl(1, mod(v, 100))), 0xffff), shl(16, and(mload(shl(1, mod(div(v, 100), 100))), 0xffff))),
                    add(shl(32, and(mload(shl(1, mod(div(v, 10000), 100))), 0xffff)), shl(48, and(mload(shl(1, mod(div(v, 1000000), 100))), 0xffff)))
                ),
                add(
                    add(shl(64, and(mload(shl(1, mod(div(v, 100000000), 100))), 0xffff)), shl(80, and(mload(shl(1, mod(div(v, 10000000000), 100))), 0xffff))),
                    add(shl(96, and(mload(shl(1, mod(div(v, 1000000000000), 100))), 0xffff)), shl(112, and(mload(shl(1, mod(div(v, 100000000000000), 100))), 0xffff)))
                )),
                add(add(
                add(shl(128, and(mload(shl(1, mod(div(v, 10000000000000000), 100))), 0xffff)), shl(144, and(mload(shl(1, mod(div(v, 1000000000000000000), 100))), 0xffff))),
                add(shl(160, and(mload(shl(1, mod(div(v, 100000000000000000000), 100))), 0xffff)), shl(176, and(mload(shl(1, mod(div(v, 10000000000000000000000), 100))), 0xffff)))
                ),
                add(
                add(shl(192, and(mload(shl(1, mod(div(v, 1000000000000000000000000), 100))), 0xffff)), shl(208, and(mload(shl(1, mod(div(v, 100000000000000000000000000), 100))), 0xffff))),
                add(shl(224, and(mload(shl(1, mod(div(v, 10000000000000000000000000000), 100))), 0xffff)), shl(240, and(mload(shl(1, mod(div(v, 1000000000000000000000000000000), 100))), 0xffff)))
                )))
            }

            mstore(0x100, 0x00)
            mstore(0x120, 0x00)
            mstore(0x140, slice(input))
            input := div(input, 100000000000000000000000000000000)
            if input
            {
                mstore(0x120, slice(input))
                input := div(input, 100000000000000000000000000000000)
                if input
                {
                    mstore(0x100, slice(input))
                }
            }
    
            function getMsbBytePosition(inp) -> y {
                inp := sub(inp, 0x3030303030303030303030303030303030303030303030303030303030303030)
                let v := and(add(inp, 0x7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f), 0x8080808080808080808080808080808080808080808080808080808080808080)
                v := or(v, shr(1, v))
                v := or(v, shr(2, v))
                v := or(v, shr(4, v))
                v := or(v, shr(8, v))
                v := or(v, shr(16, v))
                v := or(v, shr(32, v))
                v := or(v, shr(64, v))
                v := or(v, shr(128, v))
                y := mul(iszero(iszero(inp)), and(div(0x201f1e1d1c1b1a191817161514131211100f0e0d0c0b0a090807060504030201, add(shr(8, v), 1)), 0xff))
            }
            
            
            let len := getMsbBytePosition(mload(0x140))
            if mload(0x120)
            {
                len := add(getMsbBytePosition(mload(0x120)), 32)   
                if mload(0x100)
                {
                    len := add(getMsbBytePosition(mload(0x100)), 64)
                }
            }

            let offset := sub(96, len)
            mstore(result, len)
            mstore(add(result, 0x20), mload(add(0x100, offset)))
            mstore(add(result, 0x40), mload(add(0x120, offset)))
            mstore(add(result, 0x60), mload(add(0x140, offset)))
            
            mstore(0x60, mload(add(result, 0xa0)))
            mstore(0x80, mload(add(result, 0xe0)))
            mstore(0xa0, mload(add(result, 0x100)))
            mstore(0xc0, mload(add(result, 0x120)))
            mstore(0xe0, mload(add(result, 0x140)))
            mstore(0x100, mload(add(result, 0x160)))
            mstore(0x120, mload(add(result, 0x180)))
            mstore(0x140, mload(add(result, 0x1a0)))

            mstore(0x40, add(result, 0x80))
        }
    }
}
