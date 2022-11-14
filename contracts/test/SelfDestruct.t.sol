// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/CREATE2.sol";

import "forge-std/Test.sol";
import "forge-std/console2.sol";

/**
 * TODO Test this with 2 contracts and a local network.
 * Can't redeploy a contract to the same address in the same transaction.
 *   - source: https://twitter.com/w1nt3r_eth/status/1588035134577840129
 * And, am not sure if a single test here involves only 1 transaction.
 * I don't think it does, because can change the block number/height
 * But redeploying to the same address isn't working.
 */

/**
 * @notice Test whether or not the SELFDESTRUCT opcode destroys storage.
 * @notice Call SELFDESTRUCT on an ERC-20 contract -- is it possible, using CREATE2,
 * to access that storage?
 */
contract SelfDestructTest is Test {
    using stdStorage for StdStorage;

    PwndToken pwndToken;

    function setUp() public {
        pwndToken = _deployPwnedToken();

        pwndToken.mint(1000 ether);
    }

    function testNothing() public {}

    function testSelfDestruct() public {
        assertEq(pwndToken.balanceOf(address(this)), 1000 ether, "Incorrect balance.");

        console2.log("BLOCK AT SELFDESTRUCT %s", block.number);

        pwndToken.destroySelf();

        // skip to next block
        // can't deploy a contract to the same address
        // in the block that the given contract is calling sefldestruct.
        vm.roll(2);

        // redeploy contract
        console2.log("BLOCK AT REDEPLOY %s", block.number);
        address redeployedAddr = address(_deployPwnedToken());

        assertEq(redeployedAddr, address(pwndToken), "Addresses are not equal.");

        // log current block id
        // check balance
        console2.log("BALANCE AFTER REDEPLOY %s", pwndToken.balanceOf(address(this)));
    }

    function _deployPwnedToken() internal returns (PwndToken) {
        address contractAddr = Create2.deploy(0, bytes32("some_salt"), type(PwndToken).creationCode);

        return PwndToken(contractAddr);
    }
}

interface IPwndToken is IERC20 {
    function mint(uint256) external;

    function destroySelf() external;
}

contract PwndToken is IPwndToken, ERC20 {
    constructor() ERC20("PwndToken", "PWT") {}

    function mint(uint256 _amount) external {
        _mint(msg.sender, _amount);
    }

    function destroySelf() external {
        selfdestruct(payable(msg.sender));
    }
}
