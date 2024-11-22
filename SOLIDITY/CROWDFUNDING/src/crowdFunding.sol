//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PriceConverter} from "SOLIDITY/CROWDFUNDING/src/priceConverter.sol";

contract CrowdFunding {
     //!import library PriceConverter
     using PriceConverter for uint256;

     //!error identifier
     error NoAvailableAmount(string message);
     error InsufficientBalance(uint256 available, uint256 required);
     error WrongOwner(string message);

     //!state variables
     event Funded(address indexed funder, uint256 ethAmount, uint256 usdAmount);
     event WithDrawn(address indexed owner, uint256 amount);


     address public immutable owner;
     uint256 public constant MINIMUM_USD = 5e18;

     //!For funder
     mapping(address funder => bool isFunded) public funders;
     mapping(address funder => uint256 amount) public fundedAmount;
     address[] public funderList;

     receive() external payable {
          fund();
     }

     fallback() external payable {
          fund();
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
          fundedAmount[msg.sender] += msg.value;
          bool isFunded = funders[msg.sender];
          if(!isFunded) {
               funderList.push(msg.sender);
               funders[msg.sender] = true;
          }
          emit Funded(msg.sender, ethAmount, usdAmount);
     }

     function withdrawn() public onlyOwner {
          (bool sent, ) = payable(owner).call{value: address(this).balance}("");
          if (!sent) {
               revert InsufficientBalance(address(this).balance, 0);
          }
          emit WithDrawn(owner, address(this).balance);
     }

     function getBalance() public view returns (uint256) {
          return address(this).balance;
     }

     function getThisContractAddress() public view returns (address) {
          return address(this);
     }

     function getFunderList() public view returns (address[] memory) {
          return funderList;
     }
}
