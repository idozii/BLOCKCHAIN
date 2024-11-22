//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {CrowdFunding} from "SOLIDITY/CROWDFUNDING/src/crowdFunding.sol";

contract DeployCrowdFunding is Script {
     function run() external returns (CrowdFunding) {
          vm.startBroadcast();
          CrowdFunding crowdFunding = new CrowdFunding();
          vm.stopBroadcast();

          return crowdFunding;
     }
}