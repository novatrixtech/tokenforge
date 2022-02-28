/*
SPDX-License-Identifier: no-license
*/
pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract ERCGovernance {

    event GrantOperator(address indexed account);
    event RevokeOperator(address indexed account);

    function changeOwner(address _newOwner) public onlyOwner returns (bool)     {
        require(_newOwner != address(0), "You must inform a valid address");
        owner = payable(_newOwner);
        return true;
    }

    function grantOperator(address _account) public onlyOwner   {
        operators[_account] = true;
        emit GrantOperator(_account);
    }

    function revokeOperator(address _account) public onlyOwner  {
        operators[_account] = false;
        emit RevokeOperator(_account);
    }

    constructor()   {
        owner = msg.sender;
        grantOperator(msg.sender);
    }

}

abstract contract ERC721URIStorage is ERC721 {
    using Strings for uint256;

    // Optional mapping for token URIs
    mapping (uint256 => string) private _tokenURIs;

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}

contract Token721 is ERC721URIStorage{
    address payable owner;
    address public thiscontract;


    modifier onlyOwner {
        require(msg.sender == owner,"Only owner can call this function.");
    _;
  }
  
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){
      owner = payable(msg.sender);
      thiscontract = address(this);
    }

    function addr() public view virtual returns(address){
        return thiscontract;
    }

    function changeOwner(address _newOwner) public onlyOwner returns (bool){
        require(_newOwner != address(0), "You must inform a valid address");
        owner = payable(_newOwner);
        return true;
    }

    function setmintURI(address _itemOwner, uint256 _id, string memory _tokenURI) public onlyOwner returns (bool){
        _mint(_itemOwner, _id);
        _setTokenURI(_id, _tokenURI);

        return true;
  }

    function setURI(string memory _tokenURI, uint256 _id) public onlyOwner returns(bool){
    _setTokenURI(_id, _tokenURI);
    return true;
    }


}

contract Token1155 is ERC1155 {
    address payable public owner;
    address public thiscontract;

    modifier onlyOwner {
        require(msg.sender == owner,"Only owner can call this function.");
    _;
  }

    constructor(string memory uri_) ERC1155(uri_){
        owner = payable(msg.sender);
        thiscontract = address(this);
    }

    function addr() public view virtual returns(address){
        return thiscontract;
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


contract TokenERC20 is ERC20, ERC20Burnable, ERC20Pausable, ERC20Permit { 
    
    uint8 public decimal;
    address public thisContract;

    address payable public owner; 
    modifier onlyOwner {
        require(msg.sender == owner,"Only owner can call this function.");
        _;
    }

    mapping(address => bool) public operators;
    bytes32 private constant OPERATOR = keccak256(abi.encodePacked("OPERATOR"));
    
    modifier onlyOperator() {
        require(operators[msg.sender],"not operator");
        _;
    }

    constructor ( string memory _name, string memory _symbol, uint8 _decimal) ERC20(_name, _symbol) ERC20Permit(_name){
        owner = payable(msg.sender);
        decimal = _decimal;
        thisContract = address(this);
    }

    //override decimal
    function decimals() public view override returns (uint8) {
        return decimal;
    }

    function addr() public view virtual returns(address){
        return thisContract;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }


    

    
    function mintToAdress(address mint, uint supply) public onlyOperator {
        _mint(mint,supply);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal onlyOwner override(ERC20, ERC20Pausable) {
        ERC20Pausable._beforeTokenTransfer(from, to, amount);
    }

}


contract Tokenforge {
    
    event NewERC20(string _name, string _symbol, uint8 _decimal,address indexed _addr);
    event NewERC721(string _name, string symbol, address indexed _addr);
    event NewERC1155(address indexed _addr);
    enum TokenType {
        ERC20,
        ERC721,
        ERC1155
    }

    struct TokenData {
        string name;
        string symbol;
        TokenType token;
        address addrcontract;
    }

    TokenData[] public tokenGeneratedData;
    uint public tokensGenerated;

    mapping(address => bool) public operators;
    bytes32 private constant OPERATOR = keccak256(abi.encodePacked("OPERATOR"));
    
    modifier onlyOperator() {
        require(operators[msg.sender],"not operator");
        _;
    }

    address public owner;
    modifier onlyOwner {
        require(msg.sender == owner,"Only owner can call this function.");
        _;
    }

    
    

    function forgeNewTokenERC20 (string memory _name, string memory _symbol, uint8 _decimal) external onlyOperator {
        TokenERC20 token20 = new TokenERC20(_name,_symbol,_decimal);
        address _addr = token20.addr();
        tokenGeneratedData.push(TokenData({name: _name,symbol:_symbol, token: TokenType.ERC20, addrcontract: _addr}));
        tokensGenerated++;
        emit NewERC20(_name, _symbol,_decimal, _addr);
    }
}