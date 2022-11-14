// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/CREATE2.sol";

contract PwndToken is ERC20 {
    event Deployed(address index);

    constructor() ERC20("PwndToken", "PWT") {
        emit Deployed(address(this));
    }

    function mint(uint256 _amount) external {
        _mint(msg.sender, _amount);
    }

    function destroySelf() external {
        selfdestruct(payable(msg.sender));
    }
}

contract SelfDestruct {
    function deployPwnedToken() external returns (address) {
        return
            Create2.deploy(
                0,
                bytes32("some_salt"),
                type(PwndToken).creationCode
            );
    }
}
