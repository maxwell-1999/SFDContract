// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/USDC.sol";
import "../src/interfaces/ISwapRouter.sol";

contract DeployUSDC is Script {
    ISwapRouter public uniswapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address public deployed_usdc = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;

    function run() external {
        vm.startBroadcast();
         uniswapRouter.exactInputSingle(ISwapRouter.ExactInputSingleParams({
            tokenIn: address(0),
            tokenOut: address(deployed_usdc),
            fee: 500,
            recipient: address(this),
            deadline: block.timestamp + 60,
            amountIn: 10*10**18,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        }));
        vm.stopBroadcast();
    }
}
