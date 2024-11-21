//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrowdFunding {
     uint256 totalFunds;

     function fund() public payable {
          uint256 amount = msg.value;
          totalFunds += amount;
     }

     function withdraw() public {

     }
}