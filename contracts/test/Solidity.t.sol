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
        emit log_named_bytes(
            "SEPARATE ENCODING: ",
            bytes.concat(
                abi.encodePacked(bytes4(keccak256("someFunc(string,uint)"))),
                abi.encode("Some string"),
                abi.encode(9001)
            )
        );
        emit log_named_bytes(
            "ENCODING UINTS: ",
            bytes.concat(
                abi.encodePacked(bytes4(keccak256("someFunc(uint,uint)"))),
                abi.encode(9001, 1000)
            )
        );
        emit log_named_bytes(
            "ENCODING STRINGS: ",
            bytes.concat(
                abi.encodePacked(bytes4(keccak256("someFunc(string,string)"))),
                abi.encode("Some string", "Another string")
            )
        );

        /**
         * Bytecode:
         * 0x672ab540 <-- Fxn selector
         * 0000000000000000000000000000000000000000000000000000000000000040 <-- Arguments make up 64 bytes, 2 words (??)
         * 0000000000000000000000000000000000000000000000000000000000002329 <-- 9001
         * 000000000000000000000000000000000000000000000000000000000000000b <-- "Some string" (why does this not fit in 32 bytes?)
         * 536f6d6520737472696e67000000000000000000000000000000000000000000
         */
    }

    function testStringifyingANumber() public {
        emit log_named_bytes(
            "bytes | abi.encode('id-', 1)",
            abi.encode("id-", 1)
        );
        console2.log(
            "string | string(abi.encode('id-', 1)): ",
            string(abi.encode("id-", 1))
        );

        uint256 id = 1;
        emit log_named_bytes("encodePacked: ", abi.encodePacked("id-", id));
        console2.log(
            "stringified encodePacked: ",
            string(abi.encodePacked("id-", id))
        );

        console2.log("just id encodePacked", string(abi.encodePacked(id)));
        console2.log(
            "separate encodings: ",
            string.concat("id-", string(abi.encodePacked(id)))
        );

        console2.log("hashed: ", string(abi.encode(keccak256(abi.encode(id)))));
    }
}
