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
        emit log_named_bytes("MANUAL SIG: ", manualSig);
    }

    function testManuallyEncodeWithSignatureMultiple() public {
        bytes memory manualSig = bytes.concat(
            abi.encodePacked(bytes4(keccak256("someFunc(string,uint)"))),
            abi.encode("Some string", 9001)
        );

        bytes memory actualSig = abi.encodeWithSignature(
            "someFunc(string,uint)",
            "Some string",
            9001
        );

        assertEq(manualSig, actualSig, "Encodings do not match");

        emit log_named_bytes("MANUAL SIG: ", manualSig);
        /**
         * Bytecode:
         * 0x672ab540 <-- Fxn selector
         * 0000000000000000000000000000000000000000000000000000000000000040 <-- 64 bytes, 2 words
         * 0000000000000000000000000000000000000000000000000000000000002329 <-- 9001
         * 000000000000000000000000000000000000000000000000000000000000000b <-- ??
         * 536f6d6520737472696e67000000000000000000000000000000000000000000 <-- "Some string"?
         */
    }
}
