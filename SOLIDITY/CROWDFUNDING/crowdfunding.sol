//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract CrowdFunding {
     error NoAvailableAmount(string message);
     error InsufficientBalance(uint256 available, uint256 required);
     error WrongOwner(string message);

     event Received(address indexed sender, uint256 amount);
     event FallBackReceived(address indexed sender, uint256 amount);

     address public immutable owner;
     uint256 public constant MINIMUM_USD = 5e18;
     AggregatorV3Interface internal priceFeed;

     receive() external payable {
          emit Received(msg.sender, msg.value);
     }

     fallback() external payable {
          emit FallBackReceived(msg.sender, msg.value);
     }

     constructor(address _priceFeed) {
          owner = msg.sender;
          priceFeed = AggregatorV3Interface(_priceFeed);
     }

     modifier onlyOwner() {
          if(msg.sender != owner) {
               revert WrongOwner("Only owner can call this function");
          }
          _;
     }

     function fund() public payable {
          uint256 amountinUSD = msg.value * uint256(getChainlinkDataFeedLatestAnswer());
          require(amountinUSD >= MINIMUM_USD, "Minimum amount is not met");

     }

     function withdraw() public onlyOwner {
          (bool sent,) = payable(owner).call{value: address(this).balance}("");
          require(sent, "Failed to send ether");
     }

     function getBalance() public view returns(uint256) {
          return address(this).balance;
     }

     function getThisContractAddress() public view returns(address) {
          return address(this);
     }

     function getChainlinkDataFeedLatestAnswer() public view returns(int256) {
          (,int256 price,,,) = priceFeed.latestRoundData();
          int256 priceinETH = price * 1e10;
          return priceinETH;
     }
}