// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/forge-std/src/Test.sol";
import "./EsBFR.sol";

interface IERC20d {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function burn(uint256 amount) external;
    function balanceOf(address account) external view returns (uint256);
}

contract TokenSwap {
    EsBFR public tokenA;
    IERC20d public tokenB;

    constructor(address _tokenA, address _tokenB) {
        tokenA = EsBFR(_tokenA);
        tokenB = IERC20d(_tokenB);

    }
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        tokenA.burn(msg.sender, amount);
        uint256 tokenBbalance = tokenB.balanceOf(address(this));
        console.log("tokenBbalance: ",tokenBbalance);
        require(tokenBbalance >= amount/2, "Not enough funds in contract");
        uint256 amountToSend = amount / 2;
        tokenB.transfer(msg.sender, amountToSend);
    }

}


