// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

contract BitsTest is Test {
    uint32 lastId; // inits to 0

    function testBitsShifting() public {
        console2.log("1 << 224: %s", uint256(++lastId) << 224);
        console2.log("1 >> 32: %s", uint256(lastId) >> 32);
    }
}
