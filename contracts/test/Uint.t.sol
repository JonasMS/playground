// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

/**
 * From https://twitter.com/paladin_marco/status/1584538632810942464
 */
library DateTimeChallenge {
    function toHours(uint8 _days) internal pure returns (uint256) {
        return 24 * _days;
    }

    function toSeconds(uint8 _days) internal pure returns (uint256) {
        return _days * 1 days;
    }
}

contract UintTest is Test {
    using stdStorage for StdStorage;

    /**
     * @dev will fail at n > 10
     * because `24` is implicitly coerved to uint8 (before being coerced to uint256)
     * n > 10 causes an arithmetic overflow error as the product is greater than
     * uint8's max value, 255.
     *
     * @dev as is, this script will result in an error.
     */
    function testToHours() public view {
        uint256 hrs = DateTimeChallenge.toHours(11);
        console2.log("HOURS: %s", hrs);
    }

    /**
     * @dev will fail at n > 194
     * because `1 day` is cast to uint24 which has a max value of 16,777,215
     * 16,777,215 / `1 day` (86400) = 194.18
     * thus causing an arithmetic overlowflow error.
     *
     * @dev as is, this script will result in an error.
     */
    function testToSeconds() public view {
        uint256 secs = DateTimeChallenge.toSeconds(195);
        console2.log("SECONDS: %s", secs);
    }
}
