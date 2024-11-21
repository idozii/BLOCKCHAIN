// SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {MinimalAccount} from "src/ethereum/MinimalAccount.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract DeployMinimalAccount is Script {
    function run() external {}
    function deployMinimalAccount() public returns (HelperConfig, MinimalAccount) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        vm.startBroadcast(config.account);
        MinimalAccount minimalAccount = new MinimalAccount(IEntryPoint(config.entryPoint));
        minimalAccount.transferOwnership(address(msg.sender));
        vm.stopBroadcast();

        return (helperConfig, minimalAccount);
    }
}
