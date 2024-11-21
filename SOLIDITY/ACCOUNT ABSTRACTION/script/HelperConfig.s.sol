// SPDX-License-Identifier: UNLICENSED 
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script{
     error HelperConfig_InvalidChainId();

     struct NetworkConfig {
          address account;
          address entryPoint;
     }

     uint256 constant ETH_SEPOLIA_CHAIN_ID = 11155111;
     uint256 constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
     uint256 constant LOCAL_CHAIN_ID = 31337;
     address constant BURNER_WALLET = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
     address constant FOUNDRY_DEFAULT_SENDER = address(uint160(uint256(keccak256("foundry default sender"))));

     NetworkConfig public localNetworkConfig;

     mapping(uint256 chainId => NetworkConfig) public networkConfigs;

     constructor(){
          networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getETHSepoliaConfig();
          networkConfigs[ZKSYNC_SEPOLIA_CHAIN_ID] = getZkSyncSepoliaConfig();
     }

     function getETHSepoliaConfig() public pure returns (NetworkConfig memory){
          return NetworkConfig({
               account: BURNER_WALLET,
               entryPoint: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
          });
     }

     function getZkSyncSepoliaConfig() public pure returns (NetworkConfig memory){
          return NetworkConfig({
               account: BURNER_WALLET,
               entryPoint: address(0)
          });
     }

     function getConfig() public view returns (NetworkConfig memory){
          return getConfigByChainId(block.chainid);
     }

     function getConfigByChainId(uint256 chainId) public view returns (NetworkConfig memory){
          if(chainId == LOCAL_CHAIN_ID){
               return getOrCreateAnvilEthConfig();
          } else if(networkConfigs[chainId].account != address(0)){
               return networkConfigs[chainId];
          } else {
               revert HelperConfig_InvalidChainId();
          }
     }

     function getOrCreateAnvilEthConfig() public view returns (NetworkConfig memory){
          if(localNetworkConfig.account != address(0)){
               return localNetworkConfig;
          }
          return NetworkConfig({
               account: FOUNDRY_DEFAULT_SENDER,
               entryPoint: address(0)
          });
     }
}