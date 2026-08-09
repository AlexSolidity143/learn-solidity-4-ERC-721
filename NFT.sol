// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.7.0
pragma solidity ^0.8.27;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract EducationToken is ERC721, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    uint256 private _priceInWei;
    uint256 private _maxSupply;

    constructor(address initialOwner, uint256 _price, uint256 _supply)
        ERC721("EducationToken", "ETK")
        Ownable(initialOwner)
    {
        _priceInWei = _price;
        _maxSupply = _supply;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmPMc4tcBsMqLRuCQtPmPe84bpSjrC3Ky7t3JWuHXYB4aS/";
    }

    function safeMint(address to) public onlyOwner {
        require(_nextTokenId < _maxSupply, "Max supply");
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }

    function buy() public payable {
        require(_nextTokenId < _maxSupply, "Max supply");
        //require(msg.value >= _priceInWei, "Not enought money");

        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Nothing to withdraw");
        payable(owner()).transfer(balance);
    }
}