// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

contract Assembly {
    function add(uint256 _num) external pure returns (uint256) {
        uint256 a = _num + 1;

        return a + 3;
    }

    function addUnchecked(uint256 _num) external pure returns (uint256) {
        unchecked {
            uint256 a = _num + 1;

            return a + 3;
        }
    }

    function addAssembly(uint256 _num) external pure returns (uint256) {
        assembly {
            let a := add(_num, 1)
            mstore(0x0, add(a, 3))
            return(0x0, 32)
        }
    }
}

contract TestAssembly is Test {
    Assembly c;

    function setUp() public {
        c = new Assembly();
    }

    function testAdd() public {
        uint256 result = c.add(1);
        assertEq(result, 5);
    }

    function testAddUnchecked() public {
        uint256 result = c.addUnchecked(1);
        assertEq(result, 5);
    }

    function testAddAssembly() public {
        uint256 result = c.addAssembly(1);
        assertEq(result, 5);
    }
}
