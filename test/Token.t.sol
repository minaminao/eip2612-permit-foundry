// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Token.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract TokenTest is Test {
    Token token;
    address constant ownerAddress = 0xdea1a666799e538DeceB3258439f8343C87Faa68;
    uint256 constant ownerPrivateKey =
        0xef9641d4ce9f2367d701b58404e77f68a781d0d168f0924acd0781cca207d6c2;
    address constant spenderAddress = address(10);
    uint256 constant value = 1;

    function setUp() public {
        token = new Token();
        token.transfer(ownerAddress, value);
    }

    function testPermitAndTransferFrom() public {
        vm.startPrank(spenderAddress, spenderAddress);

        bytes32 _PERMIT_TYPEHASH = keccak256(
            "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
        );
        uint256 nonce = token.nonces(ownerAddress);
        uint256 deadline = type(uint256).max;
        bytes32 structHash = keccak256(
            abi.encode(
                _PERMIT_TYPEHASH, ownerAddress, spenderAddress, value, nonce, deadline
            )
        );

        bytes32 DOMAIN_SEPARATOR = token.DOMAIN_SEPARATOR();
        bytes32 digest = ECDSA.toTypedDataHash(DOMAIN_SEPARATOR, structHash);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        assertTrue(token.balanceOf(ownerAddress) == value);
        assertTrue(token.balanceOf(spenderAddress) == 0);

        token.permit(ownerAddress, spenderAddress, value, deadline, v, r, s);
        token.transferFrom(ownerAddress, spenderAddress, value);

        assertTrue(token.balanceOf(ownerAddress) == 0);
        assertTrue(token.balanceOf(spenderAddress) == value);

        vm.stopPrank();
    }
}
