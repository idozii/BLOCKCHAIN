//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PriceConverter} from "./priceConverter.sol";

contract CrowdFunding {
     //!import library PriceConverter
     using PriceConverter for uint256;

     //!error identifier
     error NoAvailableAmount(string message);
     error InsufficientBalance(uint256 available, uint256 required);
     error WrongOwner(string message);

     //!state variables
     event Received(address indexed sender, uint256 amount);
     event FallBackReceived(address indexed sender, uint256 amount);
     address public immutable owner;
     uint256 public constant MINIMUM_USD = 5e18;

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
          if (msg.sender != owner) {
               revert WrongOwner("Only owner can call this function");
          }
          _;
     }

     function fund() public payable {
          uint256 ethAmount = msg.value;
          uint256 usdAmount = ethAmount.getConversionRate();
          if (usdAmount < MINIMUM_USD) {
               revert NoAvailableAmount("Minimum amount is 5 USD");
          }
     }

     function withdraw() public onlyOwner {
          (bool sent, ) = payable(owner).call{value: address(this).balance}("");
          if (!sent) {
               revert InsufficientBalance(address(this).balance, 0);
          }
     }

     function getBalance() public view returns (uint256) {
          return address(this).balance;
     }

     function getThisContractAddress() public view returns (address) {
          return address(this);
     }
}
