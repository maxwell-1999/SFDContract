// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/forge-std/src/Test.sol";
import "../src/TokenSwap.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/EsBFR.sol";




contract TokenSwapTest is Test {
    TokenSwap public tokenSwap;
    address public user = 0xDA5f0A4DFA505dfD8391BF1a5c655295930cEcf4;
    address esBFR = 0x92914A456EbE5DB6A69905f029d6160CF51d3E6a;
    address esBFRDeployer = 0xfa1e2DD94D6665bb964192Debac09c16242f8a48;
    EsBFR deployedesbfr = EsBFR(esBFR);
    address BFR = 0x1A5B0aaF478bf1FDA7b934c76E7692D722982a6D;
    ERC20 deployedbfr = ERC20(BFR);
    address mybfrholder = 0x52bE86E343Dbb35077BfD17A41C146FfA8156688;
    function setUp() public {
        tokenSwap = new TokenSwap(esBFR, BFR);
        vm.startPrank(mybfrholder);
        console.log("deployedesbfr.balanceOf( richAccountEs): ",deployedesbfr.balanceOf( mybfrholder)/10**deployedesbfr.decimals());
        uint256 amount = deployedbfr.balanceOf(mybfrholder);
        console.log("amount: ",amount);
        deployedbfr.transfer(address(tokenSwap), amount);
        vm.stopPrank();
        vm.startPrank(esBFRDeployer);
        deployedesbfr.setHandler(address(tokenSwap), true);
        deployedesbfr.setMinter(address(tokenSwap), true);
        vm.stopPrank();
        // deployedbfr.balanceOf(address(tokenSwap));
    }

    function testDeposit() public {
        // Impersonate user and approve the token transfer
        vm.startPrank(user);
        deployedesbfr.approve(address(tokenSwap), 100 ether);
        bool dd = deployedesbfr.isHandler(address(tokenSwap));
        uint256 balance = deployedesbfr.balanceOf(user);
        console.log("balance: ",balance);
        tokenSwap.deposit(balance);
        balance = deployedbfr.balanceOf(user);
        console.log("balancear: ",balance);

        vm.stopPrank();
    }
}
