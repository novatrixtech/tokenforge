/*
SPDX-License-Identifier: no-license
*/
pragma solidity ^0.8.12;
import "./openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "./openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "./ERCGovernance.sol";


contract TokenERC20 is ERC20, ERC20Burnable, ERC20Pausable, ERC20Permit, ERCGovernance { 
    
    uint8 public decimal;

    constructor ( string memory _name, string memory _symbol, uint8 _decimal, address _owner) ERC20(_name, _symbol) ERC20Permit(_name) ERCGovernance(_owner) {
        decimal = _decimal;
    }

    //override decimal
    function decimals() public view override returns (uint8) {
        return decimal;
    }

    function addr() public view returns(address)    {
        return address(this);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mintToAdress(address mint, uint supply) external onlyOperator {
        _mint(mint,supply);
    }

    function burnFromAddress(address owner, uint amount) external onlyOperator {
        _burn(owner, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal onlyOwner override(ERC20, ERC20Pausable) {
        ERC20Pausable._beforeTokenTransfer(from, to, amount);
    }

}