/*
SPDX-License-Identifier: no-license
*/
pragma solidity ^0.8.12;
import "./ERCGovernance.sol";
import "./openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

contract TokenERC1155 is ERC1155Burnable, ERCGovernance {
    constructor(string memory _uri) ERC1155(_uri) {    }

    function addr() public view returns(address) {
        return address(this);
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