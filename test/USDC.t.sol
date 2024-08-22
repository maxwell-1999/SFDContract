// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SFD} from "../src/SFD.sol";
import {ERC20MockToken} from "../src/MockERC20Token.sol";
import "../src/USDC.sol";
import "../src/interfaces/ISwapRouter.sol";
interface IWETH {
    function deposit() external payable;
    function withdraw(uint256) external;
}

interface IOptionsConfig {
    struct Window {
        uint8 startHour;
        uint8 startMinute;
        uint8 endHour;
        uint8 endMinute;
    }

    event UpdateMarketTime();
    event UpdateMaxPeriod(uint32 value);
    event UpdateMinPeriod(uint32 value);

    event UpdateOptionFeePerTxnLimitPercent(uint16 value);
    event UpdateOverallPoolUtilizationLimit(uint16 value);
    event UpdateSettlementFeeDisbursalContract(address value);
    event UpdatetraderNFTContract(address value);
    event UpdateAssetUtilizationLimit(uint16 value);
    event UpdateMinFee(uint256 value);

    function traderNFTContract() external view returns (address);

    function settlementFeeDisbursalContract() external view returns (address);

    function marketTimes(
        uint8
    ) external view returns (uint8, uint8, uint8, uint8);

    function assetUtilizationLimit() external view returns (uint16);

    function overallPoolUtilizationLimit() external view returns (uint16);

    function maxPeriod() external view returns (uint32);

    function minPeriod() external view returns (uint32);

    function minFee() external view returns (uint256);

    function optionFeePerTxnLimitPercent() external view returns (uint16);

    function setSettlementFeeDisbursalContract(address) external;

    function setMarketTime(Window[] memory) external;

    function setOptionFeePerTxnLimitPercent(uint16) external;

    function setOverallPoolUtilizationLimit(uint16) external;

    function setAssetUtilizationLimit(uint16) external;

    function settraderNFTContract(address) external;

    function setMinFee(uint256) external;

    function setMaxPeriod(uint32) external;

    function setMinPeriod(uint32) external;
}
contract USDCTest is Test {
    SFD distributor;
    address reciever = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    address[] configcontracts = [0x2FF9150D2c73adc0C2C30684752A844207c8a950,0x0abAe3bd704F6F8ABC469A5F5884c9BA816a3d32,0x94468D9CFf4EA34164d70fDA0c7fEbba4Bab9E10,0x9FEF5c783Df560e8b6B3Cf2C94fc60EA7bdF35f2,0xB40C4902DBf401db9e60d0E9e62b14910cE5a34d,0x40444Cf8D0fC65147BB2b958B0Bc415565Ac8423,0x3Af15495AfAaC6b35216141A6CD653B1559014C2,0xbBB3b5877654EE94d0c500E69f0dbFEA823aD398,0x7d728Df1956AB365b57588E7fb2f875Ed7E19288,0x65EB2470430538B71dF8A8828d02e192f723e1A7,0x63b22B98E7210045568Fc20C1F614478Ed7EaA59,0x45Aea6510DAC905C67107ce6217e3B54ec6112C9,0xd2B8d3754333616dd1dBf40Cf461aa82f2A0E292,0x0aad9A7a5d61Dc14216c202AAe04794954485f71,0x41FC1484b1dd31E67A4d37D47ea582CD43343aF2,0x36C41Ed842e9bCd3933ca7DDA010123FdA639DDE,0xFb47cBFcb47cea419B2013224F2B2E56EEF92ef2,0x4110e4AFc12C2C890967Dd7D8B3506618BE9cE3C,0x77274eAA55e4e18186817D25E7b833900ddC8B2E,0x7FE4077ca9bbd733780e0d024088c526134F3b67,0xA551227b335950c6d0BbB54010ad1B44Be8e0d11,0xDE0e13cC381B178084F62cC472EdbC5a1CC0cd02,0xE0953C326eD0924bfdC080AefBFC1552BAfbc265,0xBC68549Afa6D22186E5Ea475C9711106fBe80E75,0x8d93200A52CB02F09DB112374Bc8964C9AB678aB,0xb861b7489Cf2Fa043568475BA61353fbaC53F2eB,0x17ef5733befFd406c5702158502456AC31073045,0x0ca5B05b9B68315E92CCD10c3792f36bd21536f4,0xBDC513398085635C590B6d47C24848FE08260230,0x84636bA83Ad1F4e1635aC0DCAc90813e00Ff7a98,0xB4b5e63159b2BF395824A3fA99c33Bae99889D49,0xbDCd415928C98600fBFE949206528A6928B52840,0xCE0A5113cd872cC101fC72f499188CBBDD595d58,0x102d0fb4234a69E16FcB91bb425393E93207BB66,0x5DaE0651EA7480497Bc46fC2622FcbA6443b7009,0x9cDD784F0138D2B76dEb91d3E07177950EA75963,0xA45cCC88A4188B5d94a914f4A86577a338745e20,0x7fD18B8114546c36ab21345603ee5B1294ECAdBd,0x41bB221A5bB8781A91332BBFcA78Fb01228AB56F,0x812d5e077BC0EB6e85Da5eDA6d5ba05F770e0a70];
    address[] oldSFDs;
    address public uBLP = 0x9501a00d7d4BC7558196B2e4d61c0ec5D16dEfb2;
    address public aBLP = 0xaE0628C88EC6C418B3F5C005f804E905f8123833;
    ISwapRouter public uniswapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address public constant WETH9 = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1; // WETH9 on Arbitrum

    address public deployed_usdc = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    ERC20 public deployed_usdc_instance = ERC20(deployed_usdc);

    address public deployed_arb = 0x912CE59144191C1204E64559FE8253a0e49E6548;
    ERC20 public deployed_arb_instance = ERC20(deployed_arb);
    uint256 public uBLPBalanceBeforeDistribution = 0;
    uint256 public aBLPBalanceBeforeDistribution = 0;
    function setUp() public {
        IWETH(WETH9).deposit{value: 100*10**18}();
        uBLPBalanceBeforeDistribution = deployed_usdc_instance.balanceOf(address(uBLP));
        aBLPBalanceBeforeDistribution = deployed_arb_instance.balanceOf(address(aBLP));
        IERC20(WETH9).approve(address(uniswapRouter), 100*10**18);
            console.log('balance before transfer',deployed_usdc_instance.balanceOf(address(this)),deployed_arb_instance.balanceOf(address(this)));
        uniswapRouter.exactInputSingle(ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH9,
            tokenOut: address(deployed_usdc),
            fee: 500,
            recipient: address(this),
            deadline: block.timestamp + 60,
            amountIn: 10*10**18,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        }));
        uniswapRouter.exactInputSingle(ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH9,
            tokenOut: address(deployed_arb),
            fee: 500,
            recipient: address(this),
            deadline: block.timestamp + 60,
            amountIn: 10*10**18,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        }));


        distributor = new SFD();
        distributor.setEscrowAccount(reciever);
        distributor.grantRole(distributor.DISTRIBUTOR_ROLE(), address(this));
        deployed_usdc_instance.transfer(address(distributor),400 * 10 ** deployed_usdc_instance.decimals());
        deployed_arb_instance.transfer(address(distributor),400 * 10 ** deployed_arb_instance.decimals());
        distributor.distribute();
    }
    function testUSDCBalance()view  public {
        uint256 usdcBalanceEscrowAccount = deployed_usdc_instance.balanceOf(address(reciever));
        console.log("usdcBalanceEscrowAccount: ",usdcBalanceEscrowAccount/10**6);
        uint256 uBLPBalance= deployed_usdc_instance.balanceOf(address(uBLP)) -  uBLPBalanceBeforeDistribution ;
        assertEq(uBLPBalance, 380*10**deployed_usdc_instance.decimals());
        // assertEq(usdcBalanceEscrowAccount, 2*10**deployed_usdc_instance.decimals());

    }
    function testAssigning()  public {
        for(uint i = 0; i < configcontracts.length; i++) {
            IOptionsConfig deployedInstance = IOptionsConfig(configcontracts[i]);
            oldSFDs.push(deployedInstance.settlementFeeDisbursalContract());
            deployedInstance.setSettlementFeeDisbursalContract(address(distributor));
        }
        for(uint i = 0; i < configcontracts.length; i++) {
            assertEq(IOptionsConfig(configcontracts[i]).settlementFeeDisbursalContract(),address(distributor));
        }
        // drain funds

    }
    function testARBBalance() view  public {
        uint256 arbBalanceEscrowAccount = deployed_arb_instance.balanceOf(address(reciever));
        console.log("arbBalanceEscrowAccount: ",arbBalanceEscrowAccount);
        uint256 aBLPBalance = deployed_arb_instance.balanceOf(address(aBLP)) - aBLPBalanceBeforeDistribution;
        assertEq(aBLPBalance, 380*10**deployed_arb_instance.decimals());

    }

}
// contract USDCTest is Test {
//     SFD distributor;
//     ERC20MockToken usdc;
//     ERC20MockToken arb;
//     address public uBLP = 0x9501a00d7d4BC7558196B2e4d61c0ec5D16dEfb2;
//     address public aBLP = 0xaE0628C88EC6C418B3F5C005f804E905f8123833;
//     ISwapRouter public uniswapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

//     address reciever = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
//     function setUp() public {
//         usdc = new ERC20MockToken("USDC", "USDC",6);
//         arb = new ERC20MockToken("ARB", "ARB",18);
//         distributor = new SFD();
//         distributor.setToken(address(usdc),address(arb));
//         distributor.setEscrowAccount(reciever);
//         console.log('deployed to',address(usdc));
//         distributor.grantRole(distributor.DISTRIBUTOR_ROLE(), address(this));

//         usdc.transfer(address(distributor),400 * 10 ** usdc.decimals());
//         arb.transfer(address(distributor),400 * 10 ** arb.decimals());
//         uint256 balance = usdc.balanceOf(address(distributor));
//         console.log('distributor balance after funding',balance);
//         distributor.distribute();
//     }
//     function testUSDCBalance()  public {
//         // assertEq(balance, 0);
//         uint256 usdcBalanceEscrowAccount = usdc.balanceOf(address(reciever));
//         uint256 uBLPBalance= usdc.balanceOf(address(uBLP));
//         assertEq(uBLPBalance, 38*10**usdc.decimals());
//         assertEq(usdcBalanceEscrowAccount, 2*10**usdc.decimals());

//         // bool transfered = usdc.transferFrom(address(distributor),reciever,1 * 10 ** usdc.decimals());
//         // uint256 balance = usdc.balanceOf(address(distributor));
//         // console.log('deployed to',balance);

//         // assertTrue(true);
//     }
//     function testARBBalance()  public {
//         // assertEq(balance, 0);
//         uint256 arbBalanceEscrowAccount = arb.balanceOf(address(reciever));
//         console.log("arbBalanceEscrowAccount",arbBalanceEscrowAccount);
//         uint256 aBLPBalance = arb.balanceOf(address(aBLP));
//         console.log("aBLPBalance",aBLPBalance);
//         assertEq(arbBalanceEscrowAccount, 2*10**arb.decimals());
//         assertEq(aBLPBalance, 38*10**arb.decimals());

//         // bool transfered = usdc.transferFrom(address(distributor),reciever,1 * 10 ** usdc.decimals());
//         // uint256 balance = usdc.balanceOf(address(distributor));
//         // console.log('deployed to',balance);

//         // assertTrue(true);
//     }

// }
