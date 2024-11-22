// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
     function getPrice() internal view returns (uint256) {
          AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
          (,int price,,,) = priceFeed.latestRoundData();
          require(price > 0, "Invalid price");
          return uint256(price) / 1e8;
     }
     function getConversionRate(uint256 amount) internal view returns (uint256) {
          uint256 ethPrice = getPrice();
          uint256 ethAmountInUSD = (amount * ethPrice) / 1e18;
          return ethAmountInUSD;
     }
}