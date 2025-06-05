// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

interface ITRC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract MyTRC20Token is ITRC20 {
    string public name = "My TRC20 Token";
    string public symbol = "MTT";
    uint8 public decimals = 6;
    uint256 private _totalSupply;
    address public owner;

    uint8 public feePercentage = 5;
    uint256 public contractStartTime;
    uint256 public constant contractLifetime = 60 days;

    mapping(address => uint256) private balances;

    constructor() {
        owner = msg.sender;
        contractStartTime = block.timestamp;

        _totalSupply = 1000 * 10**uint256(decimals);
        balances[owner] = _totalSupply;

        emit Transfer(address(0), owner, _totalSupply);
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(block.timestamp <= contractStartTime + contractLifetime, "Token expired");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(recipient != address(0), "Invalid recipient");

        uint256 fee = (amount * feePercentage) / 100;
        uint256 amountAfterFee = amount - fee;

        balances[msg.sender] -= amount;
        balances[recipient] += amountAfterFee;
        balances[owner] += fee;

        emit Transfer(msg.sender, recipient, amountAfterFee);
        return true;
    }
}
