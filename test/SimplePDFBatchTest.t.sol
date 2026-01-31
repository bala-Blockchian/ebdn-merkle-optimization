// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {SimplePDFVerifier} from "../src/SimplePDFVerifier.sol";

contract SimplePDFBatchTest is Test {
    SimplePDFVerifier public verifier;
    address public owner = address(1);
    uint256 constant BATCH_SIZE = 100;

    function setUp() public {
        vm.prank(owner);
        verifier = new SimplePDFVerifier();
    }

    // ---------------------------------------
    //   Renamed Script: SimplePDFBatchTest
    //   Total Verification Gas (100 calls): 437800
    // ---------------------------------------
    function testSimpleVerificationBatchGas() public {
        uint256 totalVerificationGas = 0;

        for (uint256 i = 0; i < BATCH_SIZE; i++) {
            uint256 pdfId = i;
            bytes32 pdfHash = keccak256(abi.encodePacked("pdf_content_", i));

            vm.prank(owner);
            verifier.setPdfHash(pdfId, pdfHash);

            uint256 gasStart = gasleft();
            vm.prank(owner);
            bool result = verifier.verifyPdf(pdfId, pdfHash);
            uint256 gasEnd = gasleft();

            totalVerificationGas += (gasStart - gasEnd);
            assertTrue(result);
        }

        console.log("---------------------------------------");
        console.log("Renamed Script: SimplePDFBatchTest");
        console.log("Total Verification Gas (100 calls):", totalVerificationGas);
        console.log("---------------------------------------");
    }
}
