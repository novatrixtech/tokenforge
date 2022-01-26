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

    function addr() public view virtual returns(address){
        return thiscontract;
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


contract Tokenforge {
    event GrantOperator(address indexed account);
    event RevokeOperator(address indexed account);

    enum TokenType{
        ERC20,
        ERC721,
        ERC1155
    }

    struct DataToken{
        string symbol;
        TokenType token;
        address addrcontract;
    }

    DataToken[] public datas;

    mapping(address => bool) public operators;
    //aacount => bool
    address public owner;

    bytes32 private constant OPERATOR = keccak256(abi.encodePacked("OPERATOR"));

    modifier onlyOperator(){
        require(operators[msg.sender],"not operator");
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner,"Only owner can call this function.");
        _;
  }
    constructor(){
        owner = msg.sender;
        grantOperator(msg.sender);
    }

    function changeOwner(address _newOwner) public onlyOwner returns (bool){
      require(_newOwner != address(0), "You must inform a valid address");
      owner = payable(_newOwner);
      return true;
  }
// for the firt Operator
  function grantOperator(address _account) public onlyOwner{
      operators[_account] = true;
      emit GrantOperator(_account);
  }

  function revokeOperator(address _account) public onlyOwner{
      operators[_account] = false;
      emit RevokeOperator(_account);
  }

  function createERC20(string memory _name, string memory _symbol, uint8 _decimal) external onlyOperator{
      Token20 token20 = new Token20(_name,_symbol,_decimal);
      address _addr = token20.addr();
      datas.push(DataToken({symbol:_symbol, token: TokenType.ERC20, addrcontract: _addr}));
  }

}