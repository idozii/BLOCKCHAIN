//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdFunding {
     error NoAvailableAmount(string message);
     error InsufficientBalance(uint256 available, uint256 required);
     error WrongOwner(string message);

     event Received(address indexed sender, uint256 amount);
     event FallBackReceived(address indexed sender, uint256 amount);

     uint256 public constant MINIMUM_FUND = 0.001 ether;
     address public immutable owner;
     mapping(address => uint256) private _balances;

     receive() external payable {
          emit Received(msg.sender, msg.value);
     }

     fallback() external payable {
          emit FallBackReceived(msg.sender, msg.value);
     }

     constructor() {
          owner = msg.sender;
     }

     modifier onlyOwner() {
          if(msg.sender != owner) {
               revert WrongOwner("Only owner can call this function");
          }
          _;
     }

     function fund() public payable {
          require(msg.value >= MINIMUM_FUND, "Minimum amount is 0.001 ether");
          _balances[msg.sender] += msg.value;
     }

     function withdraw(uint256 amount) public onlyOwner {
          uint256 balance = _balances[msg.sender];
          if(balance < amount) {
               revert InsufficientBalance(balance, amount);
          }
          _balances[msg.sender] -= amount;
          payable(msg.sender).transfer(amount);
     }

     function getBalance() public view returns(uint256) {
          return address(this).balance;
     }

     function getThisContractAddress() public view returns(address) {
          return address(this);
     }
}