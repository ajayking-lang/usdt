// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Token {
    mapping(address => uint256) public balanceOf;

    uint8 public feePercentage = 5;
    uint256 public contractStartTime;
    uint256 public constant contractLifetime = 60 days;
    address public owner;

    string public name = "My Token";
    string public symbol = "MTK";
    uint8 public decimals = 6;

    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor() {
        owner = msg.sender;
        contractStartTime = block.timestamp;
        uint256 initialSupply = 1000 * 10**uint256(decimals);
        balanceOf[owner] = initialSupply;
        emit Transfer(address(0), owner, initialSupply);
    }

    function transfer(address recipient, uint256 amount) public returns (bool success) {
        require(block.timestamp <= contractStartTime + contractLifetime, "Token expired");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        uint256 fee = (amount * feePercentage) / 100;
        uint256 amountAfterFee = amount - fee;

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amountAfterFee;
        balanceOf[owner] += fee;

        emit Transfer(msg.sender, recipient, amountAfterFee);
        return true;
    }
}
