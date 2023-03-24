// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Evm1155Starter is ERC1155, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    event Mint(uint256 tokenId);

    Counters.Counter internal nextId;

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public price = 0.001 ether;
    string public baseUri = "https://bafkreifyb5jetemu2qf2pbid7246kvsumzsqim5z3jabr5zrb3fukh35ki.ipfs.nftstorage.link";

    constructor() payable ERC1155("") {
        
    }

    // MODIFIERS

    modifier isCorrectPayment(uint256 _quantity) {
        require(msg.value >= (price * _quantity), "Incorrect Payment Sent");
        _;
    }

    modifier isAvailable(uint256 _quantity) {
        require(nextId.current() + _quantity <= MAX_SUPPLY, "Not enough tokens left for quantity");
        _;
    }

    // PUBLIC

    function mint(address _to, uint256 _id, uint256 _quantity) 
        external  
        payable
        isCorrectPayment(_quantity)
        isAvailable(_quantity) 
    {
        mintInternal(_to, _id, _quantity);
    }


    // INTERNAL

    function mintInternal(address _to, uint256 _id, uint256 _quantity) internal {
        for (uint256 i = 0; i < _quantity; i++) {

            _mint(_to, _id, _quantity, "");
        }
    }   

    // ADMIN

    function airdrop(address _to, uint256 _id, uint256 _quantity)
        external 
        onlyOwner
    {
        mintInternal(_to, _id, _quantity);
    }

    /**
     * uint256 _newPrice - this price must include 6 decimal points
     * for example: 10 USDC == 10_000_000
     */
    function setPrice(uint256 _newPrice) external onlyOwner {
        price = _newPrice;
    }

    function setUri(string calldata _newUri) external onlyOwner {
        baseUri = _newUri;
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    // VIEW

    function uri(uint256 /*id*/)
        public
        view
        override
        returns (string memory)
    {
        return baseUri;
    }
}