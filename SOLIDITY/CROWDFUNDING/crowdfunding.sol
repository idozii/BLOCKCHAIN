//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdFunding {
     event Received(address indexed sender, uint256 amount);
     event FallBackReceived(address indexed sender, uint256 amount);

     uint256 public constant MINIMUM_FUND = 0.001 ether;
     address public immutable owner;

     receive() external payable {
          
          emit Received(msg.sender, msg.value);
     }

     fallback() external payable {
          emit FallBackReceived(msg.sender, msg.value);
     }

     constructor() {
          owner = msg.sender;
     }

     function fund() public payable {
          uint256 amount = msg.value;
          require(amount>= MINIMUM_FUND, "Minimum amount is 0.001 ether");
     }

     function withdraw() public {
          if(owner != msg.sender) {
               revert("Only owner can withdraw");
          }
          (bool sent,) = payable(owner).call{value: address(this).balance}("");
          require(sent, "Failed to send ether");
     }

     function getBalance() public view returns(uint256) {
          return address(this).balance;
     }
}