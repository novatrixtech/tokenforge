/*
SPDX-License-Identifier: no-license
(c) Developed by Beatriz Siqueira
*/
pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

//ERC20Pausable - ERC20 token with pausable token transfers, minting and burning.

//ERCPermit -Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in EIP-2612.

//ERC20Burnable -Extension of ERC20 that allows token holders to destroy both their 
//own tokens and those that they have an allowance for, in a way that can be recognized off-chain (via event analysis).


contract Token20 is ERC20, ERC20Burnable,ERC20Pausable, ERC20Permit { 
    address payable public owner; 
    uint8 public decimal;
    address public thiscontract;


    modifier onlyOwner {
        require(msg.sender == owner,"Only owner can call this function.");
    _;
  }
    constructor ( string memory _name, string memory _symbol, uint8 _decimal) ERC20(_name, _symbol) ERC20Permit(_name){
        owner = payable(msg.sender);
        decimal = _decimal;
        thiscontract = address(this);

    }
//override decimal
    function decimals() public view override returns (uint8) {
        return decimal;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }


  function changeOwner(address _newOwner) public onlyOwner returns (bool){
      require(_newOwner != address(0), "You must inform a valid address");
      owner = payable(_newOwner);
      return true;
  }

  function mintToAdress(address mint, uint supply) public onlyOwner{
      _mint(mint,supply);
  }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal onlyOwner override(ERC20, ERC20Pausable) {
        ERC20Pausable._beforeTokenTransfer(from, to, amount);
    }

}
