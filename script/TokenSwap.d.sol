// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/forge-std/src/Test.sol";
import "../src/TokenSwap.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/EsBFR.sol";

import "forge-std/Script.sol";



contract TokenSwapDeploy is Script {
    TokenSwap public tokenSwap;
    address public myUser = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address public user = 0xDA5f0A4DFA505dfD8391BF1a5c655295930cEcf4;
    address esBFR = 0x92914A456EbE5DB6A69905f029d6160CF51d3E6a;
    address esBFRDeployer = 0xfa1e2DD94D6665bb964192Debac09c16242f8a48;
    EsBFR deployedesbfr = EsBFR(esBFR);
    address BFR = 0x1A5B0aaF478bf1FDA7b934c76E7692D722982a6D;
    ERC20 deployedbfr = ERC20(BFR);
    function run() public {
        vm.startPrank(0x46FC067E293645b578404e7b6B13a3A5C30B971d);
        deployedbfr.transfer(myUser, deployedbfr.balanceOf(0x46FC067E293645b578404e7b6B13a3A5C30B971d));
        vm.stopPrank();
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        tokenSwap = new TokenSwap(esBFR, BFR);

        vm.stopBroadcast();

    }

    
}
