//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdFunding {
     uint256 public constant MINIMUM_FUND = 0.001 ether;

     function fund() public payable {
          uint256 amount = msg.value;
          require(amount>= MINIMUM_FUND, "Minimum amount is 0.001 ether");
     }

     function withdraw() public {

     }
}