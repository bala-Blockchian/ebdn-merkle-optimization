// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MerklePDFVerifier} from "../src/MerklePDFVerifier.sol";

contract MerklePDFVerifierTest is Test {
    MerklePDFVerifier public verifier;
    address public owner = address(1);

    bytes32 public constant ROOT = 0x62939273af88ed6a362123ff854afd5593e38db9b6144c4796f9376031999931;
    bytes32 public constant INPUT = 0x7e656e210b93f28e7663dc29ecdbcb2bbab4f08782c9df6bf6dfab04ba59d15e;

    function setUp() public {
        vm.prank(owner);
        verifier = new MerklePDFVerifier();
    }

    function testMerkleVerification() public {
        vm.prank(owner);
        verifier.updateRoot(ROOT);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0xd0b60af5bc5a686e060a0b01e3d4a7ff18285651dfa0a99434d1222db6bf6e12;
        proof[1] = 0x1562f05cea34e25f2d505fbcba8d7d6b72e1164764e0755223735e1c7bff98e0;

        vm.prank(owner);
        bool success = verifier.verify(INPUT, proof);
        assertTrue(success, "Merkle verification failed");
    }

    //done
    //Gas used for Merkle verification: 6391
    function testMerkleVerificationGas() public {
        vm.prank(owner);
        verifier.updateRoot(ROOT);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0xd0b60af5bc5a686e060a0b01e3d4a7ff18285651dfa0a99434d1222db6bf6e12;
        proof[1] = 0x1562f05cea34e25f2d505fbcba8d7d6b72e1164764e0755223735e1c7bff98e0;

        uint256 gasStart = gasleft();

        vm.prank(owner);
        bool success = verifier.verify(INPUT, proof);

        uint256 gasEnd = gasleft();

        uint256 gasUsed = gasStart - gasEnd;
        console.log("Gas used for Merkle verification:", gasUsed);

        assertTrue(success, "Merkle verification failed");
    }

    //Gas used for verifyWithLeaf: 5828
    function testMerkleWithLeafGas() public {
        bytes32 leaf = 0x6e11c7a9471e548547475c4ae94258bc30cc1594e215e5cf869f702036c4204c;

        vm.prank(owner);
        verifier.updateRoot(ROOT);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = 0xd0b60af5bc5a686e060a0b01e3d4a7ff18285651dfa0a99434d1222db6bf6e12;
        proof[1] = 0x1562f05cea34e25f2d505fbcba8d7d6b72e1164764e0755223735e1c7bff98e0;

        uint256 gasStart = gasleft();
        vm.prank(owner);
        bool success = verifier.verifyWithLeaf(leaf, proof);
        uint256 gasEnd = gasleft();

        uint256 gasUsed = gasStart - gasEnd;
        console.log("Gas used for verifyWithLeaf:", gasUsed);

        assertTrue(success, "Merkle verification with leaf failed");
    }
}
