//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);

contract Ethereum_ERC20 {
     uint256 private _totalSupply;
     mapping(address => uint256) private _balances;
     mapping(address => mapping(address => uint256)) private _allowances;

     function totalSupply() public view returns (uint256) {
          return _totalSupply;
     }

     function balanceOf(address account) public view returns (uint256) {
          return _balances[account];
     }
     
     function transfer(address recipient, uint256 amount) public returns (bool) {
          require(_balances[msg.sender] >= amount, "ERC20: transfer amount exceeds balance");
          _balances[msg.sender] -= amount;
          _balances[recipient] += amount;
          emit Transfer(msg.sender, recipient, amount);
          return true;
     }

     function approve(address spender, uint256 amount) public returns (bool) {
          _allowances[msg.sender][spender] = amount;
          emit Approval(msg.sender, spender, amount);
          return true;
     }

     function allowance(address owner, address spender) public view returns (uint256) {
          return _allowances[owner][spender];
     }

     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
          require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
          require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
          _balances[sender] -= amount;
          _balances[recipient] += amount;
          _allowances[sender][msg.sender] -= amount;
          emit Transfer(sender, recipient, amount);
          return true;
     }
}