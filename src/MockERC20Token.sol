// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20MockToken is ERC20 {
    uint8 private _decimals;
    constructor(string memory _name, string memory _symbol,uint8 dec) ERC20(_name, _symbol) {
        _decimals = dec;
        uint256 INITIAL_SUPPLY = 1000 * 10 ** 6 * 10 ** decimals();
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
