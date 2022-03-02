/*
SPDX-License-Identifier: no-license
*/
pragma solidity ^0.8.12;
import "./ERCGovernance.sol";
import "./TokenERC20.sol";
import "./TokenERC1155.sol";
import "./TokenERC721.sol";

contract TokenForgeLong is ERCGovernance {
    
    event NewERC20(string _name, string _symbol, uint8 _decimal,address indexed _addr);
    event NewERC721(string _name, string symbol, address indexed _addr);
    event NewERC1155(string _name, string symbol, address indexed _addr);
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

    constructor() { }

    function forgeNewTokenERC20 (string memory _name, string memory _symbol, uint8 _decimal) external onlyOperator {
        TokenERC20 token20 = new TokenERC20(_name,_symbol,_decimal);
        tokenGeneratedData.push(TokenData({name: _name,symbol:_symbol, token: TokenType.ERC20, addrcontract: token20.addr()}));
        tokensGenerated++;
        emit NewERC20(_name, _symbol,_decimal, token20.addr());
    }

    function forgeNewTokenERC721 (string memory _name, string memory _symbol) external onlyOperator {
        TokenERC721 token721 = new TokenERC721(_name,_symbol);
        tokenGeneratedData.push(TokenData({name: _name,symbol:_symbol, token: TokenType.ERC721, addrcontract: token721.addr()}));
        tokensGenerated++;
        emit NewERC721(_name, _symbol, token721.addr());
    }

    function forgeNewTokenERC1155 (string memory _name, string memory _symbol, string memory _uri) external onlyOperator {
        TokenERC1155 token1155 = new TokenERC1155(_uri);
        tokenGeneratedData.push(TokenData({name: _name, symbol:_symbol, token: TokenType.ERC1155, addrcontract: token1155.addr()}));
        tokensGenerated++;
        emit NewERC1155(_name, _symbol, token1155.addr());
    }
}

