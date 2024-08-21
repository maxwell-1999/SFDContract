// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {USDC} from './USDC.sol';
contract SFD {
    using SafeERC20 for ERC20;

    // address public usdctoken;
    address public escrowAccount; 
    address public uBLP = 0x9501a00d7d4BC7558196B2e4d61c0ec5D16dEfb2;
    address public aBLP = 0xaE0628C88EC6C418B3F5C005f804E905f8123833;
    ERC20 public usdctoken;
    ERC20 public arbtoken;
    function setToken(address _token1,address _token2) public {
        usdctoken = ERC20(_token1);
        arbtoken = ERC20(_token2);
    }
    function setEscrowAccount(address _reciever) public {
        escrowAccount = _reciever;
    }
    function distribute() public   {
        uint256 usdcBalance = usdctoken.balanceOf(address(this));
        if(usdcBalance > 10**usdctoken.decimals()) {
            usdctoken.safeTransfer(uBLP, (usdcBalance * 9500) / 10_000);
        }
        usdcBalance = usdctoken.balanceOf(address(this));
        usdctoken.safeTransfer(escrowAccount, usdcBalance);
       
        uint256 arbBalance = arbtoken.balanceOf(address(this));
        if(arbBalance > 10**arbtoken.decimals()) {
            arbtoken.safeTransfer(aBLP, (arbBalance * 9500) / 10_000);
        }
        arbBalance = arbtoken.balanceOf(address(this));
        arbtoken.safeTransfer(escrowAccount, arbBalance);
       
    }
    // Add any necessary logic for the Distributor contract.
    // For now, it's a simple contract to hold USDC.
    // function distribute() {
    //     USDC usdc = new USDC();
    // }
}
