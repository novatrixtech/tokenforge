/*
SPDX-License-Identifier: no-license
*/
pragma solidity ^0.8.11;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";


contract token1155 is ERC1155{
    address payable public owner;

    modifier onlyOwner {
        require(msg.sender == owner,"Only owner can call this function.");
    _;
  }

    constructor(string memory uri_) ERC1155(uri_){
        owner = payable(msg.sender);
    }

    function changeOwner(address _newOwner) public onlyOwner returns (bool){
        require(_newOwner != address(0), "You must inform a valid address");
        owner = payable(_newOwner);
        return true;
    }


    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data) public onlyOwner{
        _mint(account, id, amount, data);
    }

       function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public onlyOwner{
        _mintBatch(to, ids, amounts, data);
    }

}