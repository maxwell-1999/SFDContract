// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SFD} from "../src/SFD.sol";
import {ERC20MockToken} from "../src/MockERC20Token.sol";
import "../src/USDC.sol";
contract USDCTest is Test {
    SFD distributor;
    ERC20MockToken usdc;
    ERC20MockToken arb;
    address public uBLP = 0x9501a00d7d4BC7558196B2e4d61c0ec5D16dEfb2;
    address public aBLP = 0xaE0628C88EC6C418B3F5C005f804E905f8123833;

    address reciever = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    function setUp() public {
        usdc = new ERC20MockToken("USDC", "USDC",6);
        arb = new ERC20MockToken("ARB", "ARB",18);
        distributor = new SFD();
        distributor.setToken(address(usdc),address(arb));
        distributor.setEscrowAccount(reciever);
        console.log('deployed to',address(usdc));
        distributor.grantRole(distributor.DISTRIBUTOR_ROLE(), address(this));

        usdc.transfer(address(distributor),40 * 10 ** usdc.decimals());
        arb.transfer(address(distributor),40 * 10 ** arb.decimals());
        uint256 balance = usdc.balanceOf(address(distributor));
        console.log('distributor balance after funding',balance);
        distributor.distribute();
    }
    function testUSDCBalance()  public {
        // assertEq(balance, 0);
        uint256 usdcBalanceEscrowAccount = usdc.balanceOf(address(reciever));
        uint256 uBLPBalance= usdc.balanceOf(address(uBLP));
        assertEq(uBLPBalance, 38*10**usdc.decimals());
        assertEq(usdcBalanceEscrowAccount, 2*10**usdc.decimals());

        // bool transfered = usdc.transferFrom(address(distributor),reciever,1 * 10 ** usdc.decimals());
        // uint256 balance = usdc.balanceOf(address(distributor));
        // console.log('deployed to',balance);

        // assertTrue(true);
    }
    function testARBBalance()  public {
        // assertEq(balance, 0);
        uint256 arbBalanceEscrowAccount = arb.balanceOf(address(reciever));
        console.log("arbBalanceEscrowAccount",arbBalanceEscrowAccount);
        uint256 aBLPBalance = arb.balanceOf(address(aBLP));
        console.log("aBLPBalance",aBLPBalance);
        assertEq(arbBalanceEscrowAccount, 2*10**arb.decimals());
        assertEq(aBLPBalance, 38*10**arb.decimals());

        // bool transfered = usdc.transferFrom(address(distributor),reciever,1 * 10 ** usdc.decimals());
        // uint256 balance = usdc.balanceOf(address(distributor));
        // console.log('deployed to',balance);

        // assertTrue(true);
    }

}
