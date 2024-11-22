// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
     function getPrice() internal view returns (uint256) {
          AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
          (,int price,,,) = priceFeed.latestRoundData();
          return uint256(price);
     }
     function getConversionRate(uint256 amount) internal view returns (uint256) {
          uint256 ethPrice = getPrice();
          uint256 ethAmountInUSD = (amount * ethPrice) / 1e8;
          return ethAmountInUSD;
     }
}