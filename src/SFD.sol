// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interfaces/ISwapRouter.sol";
import "forge-std/console.sol";
import {USDC} from './USDC.sol';
contract SFD is AccessControl{
    using SafeERC20 for ERC20;
    address public deployed_arb = 0x912CE59144191C1204E64559FE8253a0e49E6548;
    address public deployed_usdc = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;

    // address public usdctoken;
    address public escrowAccount; 
    address public uBLP = 0x9501a00d7d4BC7558196B2e4d61c0ec5D16dEfb2;
    address public aBLP = 0xaE0628C88EC6C418B3F5C005f804E905f8123833;
    ERC20 public usdctoken = ERC20(0xaf88d065e77c8cC2239327C5EDb3A432268e5831);
    ERC20 public arbtoken = ERC20(0x912CE59144191C1204E64559FE8253a0e49E6548);
    bytes32 public constant DISTRIBUTOR_ROLE = keccak256("DISTRIBUTOR_ROLE");
    ISwapRouter public uniswapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    
    function setEscrowAccount(address _reciever) public {
        escrowAccount = _reciever;
    }
    function distribute() external onlyRole(DISTRIBUTOR_ROLE)   {
        uint256 usdcBalance = usdctoken.balanceOf(address(this));
        // console.log(usdcBalance,'before transfer');
        if(usdcBalance > 10**usdctoken.decimals()) {
            usdctoken.safeTransfer(uBLP, (usdcBalance * 9500) / 10_000);
            usdcBalance = usdctoken.balanceOf(address(this));
            // console.log(usdcBalance,'after transfer');
            usdctoken.safeTransfer(escrowAccount, usdcBalance);
        }

       
        uint256 arbBalance = arbtoken.balanceOf(address(this));
        if(arbBalance > 10**arbtoken.decimals()) {
            arbtoken.safeTransfer(aBLP, (arbBalance * 9500) / 10_000);
            arbBalance = arbtoken.balanceOf(address(this));
            if(arbBalance < 10**arbtoken.decimals()) return;
            console.log("arbBalance: ",arbBalance/10**18);
            arbtoken.approve(address(uniswapRouter), arbBalance);
            uniswapRouter.exactInputSingle(ISwapRouter.ExactInputSingleParams({
                tokenIn: address(deployed_arb),
                tokenOut: address(deployed_usdc),
                fee: 500,
                recipient: escrowAccount,
                deadline: block.timestamp + 600,
                amountIn: arbBalance - 1**18,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            }));       
        }
    }
    function withdrawTokenX(
        ERC20 _tokenX,
        uint256 _amount
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _tokenX.safeTransfer(msg.sender, _amount);
    }
    // Add any necessary logic for the Distributor contract.
    // For now, it's a simple contract to hold USDC.
    // function distribute() {
    //     USDC usdc = new USDC();
    // }
}
