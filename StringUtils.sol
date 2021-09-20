pragma solidity ^0.8.7;

/*
 * String shenanigans
 * Author: Zac Williamson, AZTEC
 * Licensed under the Unlicense
 */

contract StringUtils {
    function toString(uint256 input) public pure returns (string memory result) {
        if (input < 10) {
            assembly {
                result := mload(0x40)
                mstore(result, 0x01)
                mstore8(add(result, 0x20), add(input, 0x30))
                mstore(0x40, add(result, 0x40))
            }
            return result;
        }
        assembly {
            result := mload(0x40)
            let mptr := add(result, 0x80)
            let table := add(result, 0xe0)

            // Store lookup table that maps an integer from 0 to 99 into a 2-byte ASCII equivalent
            mstore(table, 0x0000000000000000000000000000000000000000000000000000000000003030)
            mstore(add(table, 0x20), 0x3031303230333034303530363037303830393130313131323133313431353136)
            mstore(add(table, 0x40), 0x3137313831393230323132323233323432353236323732383239333033313332)
            mstore(add(table, 0x60), 0x3333333433353336333733383339343034313432343334343435343634373438)
            mstore(add(table, 0x80), 0x3439353035313532353335343535353635373538353936303631363236333634)
            mstore(add(table, 0xa0), 0x3635363636373638363937303731373237333734373537363737373837393830)
            mstore(add(table, 0xc0), 0x3831383238333834383538363837383838393930393139323933393439353936)
            mstore(add(table, 0xe0), 0x3937393839390000000000000000000000000000000000000000000000000000)

            /**
             * Convert `input` into ASCII.
             *
             * Slice 2 base-10  digits off of the input, use to index the ASCII lookup table.
             * 
             * We start from the least significant digits, write results into mem backwards,
             * this prevents us from overwriting memory despite the fact that each mload
             * only contains 2 byteso f useful data.
             **/
            {
                let v := input
                mstore(0x1e, mload(add(table, shl(1, mod(v, 100)))))
                mstore(0x1c, mload(add(table, shl(1, mod(div(v, 100), 100)))))
                mstore(0x1a, mload(add(table, shl(1, mod(div(v, 10000), 100)))))
                mstore(0x18, mload(add(table, shl(1, mod(div(v, 1000000), 100)))))
                mstore(0x16, mload(add(table, shl(1, mod(div(v, 100000000), 100)))))
                mstore(0x14, mload(add(table, shl(1, mod(div(v, 10000000000), 100)))))
                mstore(0x12, mload(add(table, shl(1, mod(div(v, 1000000000000), 100)))))
                mstore(0x10, mload(add(table, shl(1, mod(div(v, 100000000000000), 100)))))
                mstore(0x0e, mload(add(table, shl(1, mod(div(v, 10000000000000000), 100)))))
                mstore(0x0c, mload(add(table, shl(1, mod(div(v, 1000000000000000000), 100)))))
                mstore(0x0a, mload(add(table, shl(1, mod(div(v, 100000000000000000000), 100)))))
                mstore(0x08, mload(add(table, shl(1, mod(div(v, 10000000000000000000000), 100)))))
                mstore(0x06, mload(add(table, shl(1, mod(div(v, 1000000000000000000000000), 100)))))
                mstore(0x04, mload(add(table, shl(1, mod(div(v, 100000000000000000000000000), 100)))))
                mstore(0x02, mload(add(table, shl(1, mod(div(v, 10000000000000000000000000000), 100)))))
                mstore(0x00, mload(add(table, shl(1, mod(div(v, 1000000000000000000000000000000), 100)))))

                mstore(add(mptr, 0x40), mload(0x1e))

                v := div(v, 100000000000000000000000000000000)
                if v {
                    mstore(0x1e, mload(add(table, shl(1, mod(v, 100)))))
                    mstore(0x1c, mload(add(table, shl(1, mod(div(v, 100), 100)))))
                    mstore(0x1a, mload(add(table, shl(1, mod(div(v, 10000), 100)))))
                    mstore(0x18, mload(add(table, shl(1, mod(div(v, 1000000), 100)))))
                    mstore(0x16, mload(add(table, shl(1, mod(div(v, 100000000), 100)))))
                    mstore(0x14, mload(add(table, shl(1, mod(div(v, 10000000000), 100)))))
                    mstore(0x12, mload(add(table, shl(1, mod(div(v, 1000000000000), 100)))))
                    mstore(0x10, mload(add(table, shl(1, mod(div(v, 100000000000000), 100)))))
                    mstore(0x0e, mload(add(table, shl(1, mod(div(v, 10000000000000000), 100)))))
                    mstore(0x0c, mload(add(table, shl(1, mod(div(v, 1000000000000000000), 100)))))
                    mstore(0x0a, mload(add(table, shl(1, mod(div(v, 100000000000000000000), 100)))))
                    mstore(0x08, mload(add(table, shl(1, mod(div(v, 10000000000000000000000), 100)))))
                    mstore(0x06, mload(add(table, shl(1, mod(div(v, 1000000000000000000000000), 100)))))
                    mstore(0x04, mload(add(table, shl(1, mod(div(v, 100000000000000000000000000), 100)))))
                    mstore(0x02, mload(add(table, shl(1, mod(div(v, 10000000000000000000000000000), 100)))))
                    mstore(0x00, mload(add(table, shl(1, mod(div(v, 1000000000000000000000000000000), 100)))))

                    mstore(add(mptr, 0x20), mload(0x1e))
                }
                v := div(v, 100000000000000000000000000000000)
                if v {
                    mstore(0x1e, mload(add(table, shl(1, mod(v, 100)))))
                    mstore(0x1c, mload(add(table, shl(1, mod(div(v, 100), 100)))))
                    mstore(0x1a, mload(add(table, shl(1, mod(div(v, 10000), 100)))))
                    mstore(0x18, mload(add(table, shl(1, mod(div(v, 1000000), 100)))))
                    mstore(0x16, mload(add(table, shl(1, mod(div(v, 100000000), 100)))))
                    mstore(0x14, mload(add(table, shl(1, mod(div(v, 10000000000), 100)))))
                    mstore(0x12, mload(add(table, shl(1, mod(div(v, 1000000000000), 100)))))

                    mstore(mptr, mload(0x1e))
                }
            }

            // get the length of the input
            let len := 1
            {
                if gt(input, 999999999999999999999999999999999999999) {
                    len := add(len, 39)
                    input := div(input, 1000000000000000000000000000000000000000)
                }
                if gt(input, 99999999999999999999) {
                    len := add(len, 20)
                    input := div(input, 100000000000000000000)
                }
                if gt(input, 9999999999) {
                    len := add(len, 10)
                    input := div(input, 10000000000)
                }
                if gt(input, 99999) {
                    len := add(len, 5)
                    input := div(input, 100000)
                }
                if gt(input, 999) {
                    len := add(len, 3)
                    input := div(input, 1000)
                }
                if gt(input, 99) {
                    len := add(len, 2)
                    input := div(input, 100)
                }
                len := add(len, gt(input, 9))
            }
            
            let offset := sub(96, len)
            mstore(result, len)
            mstore(add(result, 0x20), mload(add(mptr, offset)))
            mstore(add(result, 0x40), mload(add(add(mptr, 0x20), offset)))
            mstore(add(result, 0x60), mload(add(add(mptr, 0x40), offset)))
            
            // clear the junk off at the end of the string. Probs not neccessary but might confuse some debuggers
            mstore(add(result, add(0x20, len)), 0x00)
            mstore(0x40, add(result, 0x80))
        }
    }
}
