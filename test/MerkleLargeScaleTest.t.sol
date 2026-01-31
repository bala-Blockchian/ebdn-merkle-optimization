// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MerklePDFVerifier} from "../src/MerklePDFVerifier.sol";
import {Merkle} from "murky/src/Merkle.sol";
import {ScriptHelper} from "murky/script/common/ScriptHelper.sol";

contract MerkleLargeScaleTest is Test, ScriptHelper {
    MerklePDFVerifier public verifier;
    Merkle private m = new Merkle();

    address public owner = makeAddr("owner");
    uint256 constant TREE_SIZE = 100;

    bytes32[] private leafs = new bytes32[](TREE_SIZE);
    bytes32 public root;

    function setUp() public {
        vm.prank(owner);
        verifier = new MerklePDFVerifier();

        for (uint256 i = 0; i < TREE_SIZE; i++) {
            bytes32 pdfHash = keccak256(abi.encodePacked("pdf_content_", i));

            bytes32[] memory data = new bytes32[](1);
            data[0] = pdfHash;

            leafs[i] = keccak256(bytes.concat(keccak256(ltrim64(abi.encode(data)))));
        }

        root = m.getRoot(leafs);
    }

    //Gas used for verifyWithLeaf (100 items): 8650
    function testLargeScaleGas() public {
        vm.prank(owner);
        verifier.updateRoot(root);

        uint256 targetIndex = 50;
        bytes32 targetLeaf = leafs[targetIndex];
        bytes32[] memory proof = m.getProof(leafs, targetIndex);

        uint256 gasStart = gasleft();
        vm.prank(owner);
        bool success = verifier.verifyWithLeaf(targetLeaf, proof);
        uint256 gasUsed = gasStart - gasleft();

        console.log("Tree Size: 100");
        console.log("Proof Depth:", proof.length);
        console.log("Gas used for verifyWithLeaf (100 items):", gasUsed);

        assertTrue(success, "Large scale verification failed");
    }

    // Gas used for testLargeScaleGasLast (100 items): 8650
    function testLargeScaleGasLast() public {
        vm.prank(owner);
        verifier.updateRoot(root);

        uint256 targetIndex = 99;
        bytes32 targetLeaf = leafs[targetIndex];
        bytes32[] memory proof = m.getProof(leafs, targetIndex);

        uint256 gasStart = gasleft();
        vm.prank(owner);
        bool success = verifier.verifyWithLeaf(targetLeaf, proof);
        uint256 gasUsed = gasStart - gasleft();

        console.log("Tree Size: 100");
        console.log("Proof Depth:", proof.length);
        console.log("Gas used for testLargeScaleGasLast (100 items):", gasUsed);

        assertTrue(success, "Large scale verification failed");
    }
}
