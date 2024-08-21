// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/USDC.sol";

contract DeployUSDC is Script {
    function run() external {
        vm.startBroadcast();
        USDC usdc = new USDC(); // Deploy the USDC contract
        console.log('deployed to',address(usdc));
        usdc.transfer(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),40 * 10 ** usdc.decimals());
        vm.stopBroadcast();
    }
}
