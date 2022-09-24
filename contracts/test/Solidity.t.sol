// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Test.sol";

contract SolidityTest is Test {
    using stdStorage for StdStorage;

    function testManuallyEncodeWithSignature() public {
        bytes memory manualSig = bytes.concat(
            abi.encodePacked(bytes4(keccak256("Error(string)"))),
            abi.encode("LC:INVALID_TOKEN")
        );

        bytes memory actualSig = abi.encodeWithSignature(
            "Error(string)",
            "LC:INVALID_TOKEN"
        );

        assertEq(manualSig, actualSig, "Encodings do not match");
    }
}
