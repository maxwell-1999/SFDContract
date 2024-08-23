// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {SFD} from "../src/SFD.sol";
import {ERC20MockToken} from "../src/MockERC20Token.sol";
import "../src/USDC.sol";
import "../src/interfaces/ISwapRouter.sol";
import "../src/interfaces/IRequired.sol";

contract USDCTest is Test {
    address sender = 0xB011486BdD7068c6955E2B600F75D6db1AdB3c06;
    address public deployed_usdc = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    ERC20 public deployed_usdc_instance = ERC20(deployed_usdc);
    address reciever = address(this);
    function setUp() public {
       console.log("USDC balance: ",deployed_usdc_instance.balanceOf(reciever));
       console.log("sender balance: ",deployed_usdc_instance.balanceOf(sender));

       vm.prank(reciever);
       deployed_usdc_instance.transfer(sender,1);
       console.log("USDC balance after: ",deployed_usdc_instance.balanceOf(reciever));
       vm.stopPrank();
    }
    function testUSDCBalance()view  public {
        // uint256 usdcBalanceEscrowAccount = deployed_usdc_instance.balanceOf(address(reciever));
        // console.log("usdcBalanceEscrowAccount: ",usdcBalanceEscrowAccount/10**6);
        // uint256 uBLPBalance= deployed_usdc_instance.balanceOf(address(uBLP)) -  uBLPBalanceBeforeDistribution ;
        // assertEq(uBLPBalance, 380*10**deployed_usdc_instance.decimals());
        // assertEq(usdcBalanceEscrowAccount, 2*10**deployed_usdc_instance.decimals());

    }
    // function testAssigning()  public {
    //     for(uint i = 0; i < configcontracts.length; i++) {
    //         IOptionsConfig deployedInstance = IOptionsConfig(configcontracts[i]);
    //         oldSFDs.push(deployedInstance.settlementFeeDisbursalContract());
    //         deployedInstance.setSettlementFeeDisbursalContract(address(distributor));
    //     }
    //     for(uint i = 0; i < configcontracts.length; i++) {
    //         assertEq(IOptionsConfig(configcontracts[i]).settlementFeeDisbursalContract(),address(distributor));
    //     }
    //     // drain funds

    // }
    function testARBBalance() view  public {
        // uint256 aj
    }

}
