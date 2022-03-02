/*
SPDX-License-Identifier: no-license
*/
pragma solidity ^0.8.12;

abstract contract ERCGovernance {

    event GrantOperator(address indexed account);
    event RevokeOperator(address indexed account);

    mapping(address => bool) public operators;
    bytes32 private constant OPERATOR = keccak256(abi.encodePacked("OPERATOR"));
    
    modifier onlyOperator() {
        require(operators[msg.sender], "Only operator can call this function.");
        _;
    }

    address public owner;
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

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

    constructor(address _owner)   {
        require(_owner != address(0), "You must inform a valid address");
        owner = _owner;
        operators[_owner] = true;
        emit GrantOperator(_owner);
    }

}