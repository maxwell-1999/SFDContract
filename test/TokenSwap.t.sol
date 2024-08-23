// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/forge-std/src/Test.sol";
import "../src/TokenSwap.sol";
pragma solidity ^0.8.0;

import "lib/forge-std/src/Test.sol";


contract MockERC20 is IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
        totalSupply = 1000000 * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        require(balanceOf[sender] >= amount, "Insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "Transfer not approved");

        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        return true;
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        return true;
    }

    function approve(address spender, uint256 amount) external  returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function burn(uint256 amount) external override {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        totalSupply -= amount;
        balanceOf[msg.sender] -= amount;
    }
}


contract TokenSwapTest is Test {
    TokenSwap public tokenSwap;
    MockERC20 public tokenA;
    MockERC20 public tokenB;
    address public user;

    function setUp() public {
        tokenA = new MockERC20("Token A", "TKA");
        tokenB = new MockERC20("Token B", "TKB");

        tokenSwap = new TokenSwap(address(tokenA), address(tokenB));
        user = address(0x1);

        // Send some tokens to the user
        tokenA.transfer(user, 1000 ether);
        tokenB.transfer(address(tokenSwap), 1000 ether);
    }

    function testDeposit() public {
        // Impersonate user and approve the token transfer
        vm.startPrank(user);
        tokenA.approve(address(tokenSwap), 100 ether);

        // Perform deposit
        tokenSwap.deposit(100 ether);

        // Check that Token B was sent correctly
        assertEq(tokenB.balanceOf(user), 50 ether);
        vm.stopPrank();
    }
}
