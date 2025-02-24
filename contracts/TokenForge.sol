/*
SPDX-License-Identifier: no-license
*/
pragma solidity ^0.8.12;
import "./ERCGovernance.sol";
import "./TokenERC20.sol";
import "./TokenERC721.sol";

contract TokenForge is ERCGovernance {
    
    event NewERC20(string _name, string _symbol, uint8 _decimal,address indexed _addr);
    event NewERC721(string _name, string symbol, address indexed _addr);
   
    enum TokenType {
        ERC20,
        ERC721
    }

    struct TokenData {
        string name;
        string symbol;
        TokenType token;
        address addrcontract;
    }

    TokenData[] public tokenGeneratedData;
    uint public tokensGenerated;    

    constructor() ERCGovernance(msg.sender) { }

    function forgeNewTokenERC20 (string memory _name, string memory _symbol, uint8 _decimal) external onlyOperator {
        TokenERC20 token20 = new TokenERC20(_name,_symbol,_decimal, msg.sender);
        tokenGeneratedData.push(TokenData({name: _name,symbol:_symbol, token: TokenType.ERC20, addrcontract: token20.addr()}));
        tokensGenerated++;
        emit NewERC20(_name, _symbol,_decimal, token20.addr());
    }

    function forgeNewTokenERC721 (string memory _name, string memory _symbol) external onlyOperator {
        TokenERC721 token721 = new TokenERC721(_name, _symbol, msg.sender);
        tokenGeneratedData.push(TokenData({name: _name,symbol:_symbol, token: TokenType.ERC721, addrcontract: token721.addr()}));
        tokensGenerated++;
        emit NewERC721(_name, _symbol, token721.addr());
    }    
}

