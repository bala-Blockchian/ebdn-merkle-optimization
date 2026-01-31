// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MerklePDFVerifier} from "../src/MerklePDFVerifier.sol";
import {Merkle} from "murky/src/Merkle.sol";
import {ScriptHelper} from "murky/script/common/ScriptHelper.sol";

contract MerkleIterationTest is Test, ScriptHelper {
    MerklePDFVerifier public verifier;
    Merkle private m = new Merkle();

    address public owner = makeAddr("owner");
    uint256 constant TREE_SIZE = 100;

    bytes32[] private leafs = new bytes32[](TREE_SIZE);

    function setUp() public {
        vm.prank(owner);
        verifier = new MerklePDFVerifier();

        for (uint256 i = 0; i < TREE_SIZE; i++) {
            bytes32 pdfHash = keccak256(abi.encodePacked("pdf_content_", i));

            bytes32[] memory data = new bytes32[](1);
            data[0] = pdfHash;

            leafs[i] = keccak256(bytes.concat(keccak256(ltrim64(abi.encode(data)))));
        }
    }

    // ---------------------------------------
    //   Total Gas for 100 'verifyWithLeaf' calls: 864060
    //   Average Gas per single call: 8640
    // ---------------------------------------
    function testTotalVerificationGasOnly() public {
        bytes32 root = m.getRoot(leafs);

        vm.prank(owner);
        verifier.updateRoot(root);

        uint256 totalGasForCalls = 0;

        for (uint256 i = 0; i < TREE_SIZE; i++) {
            bytes32[] memory proof = m.getProof(leafs, i);
            bytes32 currentLeaf = leafs[i];

            uint256 gasBefore = gasleft();
            vm.prank(owner);
            verifier.verifyWithLeaf(currentLeaf, proof);
            uint256 gasAfter = gasleft();

            totalGasForCalls += (gasBefore - gasAfter);
        }

        console.log("---------------------------------------");
        console.log("Total Gas for 100 'verifyWithLeaf' calls:", totalGasForCalls);
        console.log("Average Gas per single call:", totalGasForCalls / TREE_SIZE);
        console.log("---------------------------------------");
    }
}
