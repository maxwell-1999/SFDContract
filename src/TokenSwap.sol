// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/forge-std/src/Test.sol";
import "./EsBFR.sol";

interface IERC20d {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function burn(uint256 amount) external;
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
        uint256 amountToSend = amount / 2;
        tokenB.transfer(msg.sender, amountToSend);
    }


    // function deposit(uint256 amount) external {
    //     require(amount > 0, "Amount must be greater than 0");

    //     // Transfer Token A from the caller to this contract
    //     tokenA.transferFrom(msg.sender, address(this), amount);

    //     // Burn Token A
    //     tokenA.burn(amount);

    //     // Send 0.5 * amount of Token B back to the caller
    //     uint256 amountToSend = amount / 2;
    //     tokenB.transfer(msg.sender, amountToSend);
    // }
}


