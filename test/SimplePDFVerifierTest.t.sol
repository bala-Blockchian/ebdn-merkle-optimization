// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {SimplePDFVerifier} from "../src/SimplePDFVerifier.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SimplePDFVerifierTest is Test {
    SimplePDFVerifier public verifier;
    address public owner = address(1);
    address public user = address(2);

    uint256 constant PDF_ID = 101;
    bytes32 constant PDF_HASH = keccak256("sample pdf content");

    function setUp() public {
        vm.prank(owner);
        verifier = new SimplePDFVerifier();
    }

    function testSetPdfHashAsOwner() public {
        vm.prank(owner);

        vm.expectEmit(true, false, false, true);
        emit SimplePDFVerifier.HashUpdated(PDF_ID, PDF_HASH);

        verifier.setPdfHash(PDF_ID, PDF_HASH);
        assertEq(verifier.getPdfHash(PDF_ID), PDF_HASH);
    }

    function testSetPdfHashAsNonOwner() public {
        vm.prank(user);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, user));
        verifier.setPdfHash(PDF_ID, PDF_HASH);
    }

    // Gas used for simple verification: 4378
    function testVerifyCorrectHash() public {
        vm.prank(owner);
        verifier.setPdfHash(PDF_ID, PDF_HASH);

        vm.expectEmit(true, false, false, true);
        emit SimplePDFVerifier.HashVerified(PDF_ID, true);

        uint256 gasStart = gasleft();
        vm.prank(owner);
        bool result = verifier.verifyPdf(PDF_ID, PDF_HASH);
        uint256 gasEnd = gasleft();

        uint256 gasUsed = gasStart - gasEnd;
        console.log("Gas used for simple verification:", gasUsed);

        assertTrue(result);
    }

    function testGetHash() public {
        vm.prank(owner);
        verifier.setPdfHash(PDF_ID, PDF_HASH);

        bytes32 storedHash = verifier.getPdfHash(PDF_ID);
        assertEq(storedHash, PDF_HASH);
    }
}
