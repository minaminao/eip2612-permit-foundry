// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import
    "openzeppelin-contracts/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract Token is ERC20, ERC20Permit {
    constructor() ERC20("token", "T") ERC20Permit("token") {
        _mint(msg.sender, 1);
    }
}
