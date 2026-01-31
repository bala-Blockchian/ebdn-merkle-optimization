// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {MerklePDFVerifier} from "../src/MerklePDFVerifier.sol";
import {SimplePDFVerifier} from "../src/SimplePDFVerifier.sol";
import {Merkle} from "murky/src/Merkle.sol";
import {ScriptHelper} from "murky/script/common/ScriptHelper.sol";

contract StorageComparisonTest is Test, ScriptHelper {
    MerklePDFVerifier merkleVerifier;
    SimplePDFVerifier simpleVerifier;
    Merkle m = new Merkle();

    address owner = makeAddr("owner");
    uint256 constant BATCH_SIZE = 100;
    bytes32[] leafs = new bytes32[](BATCH_SIZE);

    function setUp() public {
        for (uint256 i = 0; i < BATCH_SIZE; i++) {
            leafs[i] = keccak256(abi.encodePacked("pdf_", i));
        }
    }

    // Logs:
    //   === STORAGE COST (Writing 100 PDFs) ===
    //   Merkle Storage Gas: 882884
    //   Simple Mapping Storage Gas: 3027984
    //   Merkle saved you: 2145100 gas in storage!

    // === TOTAL COST OF OWNERSHIP (Storage + 100 Verifications) ===
    //   Merkle Total: 1465684
    //   Simple Total: 3465784
    //   Merkle saved you: 2000100 gas in storage and verification!

    function testGasComparison() public {
        uint256 gasStartMerkle = gasleft();

        vm.prank(owner);
        merkleVerifier = new MerklePDFVerifier();
        bytes32 root = m.getRoot(leafs);

        vm.prank(owner);
        merkleVerifier.updateRoot(root);

        uint256 totalMerkleStorageGas = gasStartMerkle - gasleft();

        uint256 gasStartSimple = gasleft();

        vm.prank(owner);
        simpleVerifier = new SimplePDFVerifier();

        for (uint256 i = 0; i < BATCH_SIZE; i++) {
            vm.prank(owner);
            simpleVerifier.setPdfHash(i, leafs[i]);
        }
        uint256 totalSimpleStorageGas = gasStartSimple - gasleft();

        console.log("=== STORAGE COST (Writing 100 PDFs) ===");
        console.log("Merkle Storage Gas:", totalMerkleStorageGas);
        console.log("Simple Mapping Storage Gas:", totalSimpleStorageGas);

        uint256 savings = totalSimpleStorageGas - totalMerkleStorageGas;
        console.log("Merkle saved you:", savings, "gas in storage!");

        uint256 merkleVerifTotal = 5828 * BATCH_SIZE;
        uint256 simpleVerifTotal = 4378 * BATCH_SIZE;

        console.log("\n=== TOTAL COST OF OWNERSHIP (Storage + 100 Verifications) ===");
        console.log("Merkle Total:", totalMerkleStorageGas + merkleVerifTotal);
        console.log("Simple Total:", totalSimpleStorageGas + simpleVerifTotal);

        uint256 savingsForVerification =
            (totalSimpleStorageGas + simpleVerifTotal) - (totalMerkleStorageGas + merkleVerifTotal);
        console.log("Merkle saved you:", savingsForVerification, "gas in storage and verification!");
    }

    // Logs:
    //   === STORAGE COST (Writing 100 PDFs) ===
    //   Merkle Storage Gas: 25302
    //   Simple Mapping Storage Gas: 2636447
    //   Merkle saved you: 2611145 gas in storage!

    // === TOTAL COST OF OWNERSHIP (Storage + 100 Verifications) ===
    //   Merkle Total: 608102
    //   Simple Total: 3074247
    //   Merkle saved you: 2466145 gas in storage and verification!

    function testGasComparisonOnlyUpdates() public {
        vm.prank(owner);
        merkleVerifier = new MerklePDFVerifier();
        bytes32 root = m.getRoot(leafs);

        uint256 gasStartMerkle = gasleft();
        vm.prank(owner);
        merkleVerifier.updateRoot(root);
        uint256 totalMerkleStorageGas = gasStartMerkle - gasleft();

        vm.prank(owner);
        simpleVerifier = new SimplePDFVerifier();

        uint256 gasStartSimple = gasleft();
        for (uint256 i = 0; i < BATCH_SIZE; i++) {
            vm.prank(owner);
            simpleVerifier.setPdfHash(i, leafs[i]);
        }
        uint256 totalSimpleStorageGas = gasStartSimple - gasleft();

        console.log("=== STORAGE COST (Writing 100 PDFs) ===");
        console.log("Merkle Storage Gas:", totalMerkleStorageGas);
        console.log("Simple Mapping Storage Gas:", totalSimpleStorageGas);

        uint256 savings = totalSimpleStorageGas - totalMerkleStorageGas;
        console.log("Merkle saved you:", savings, "gas in storage!");

        uint256 merkleVerifTotal = 5828 * BATCH_SIZE;
        uint256 simpleVerifTotal = 4378 * BATCH_SIZE;

        console.log("\n=== TOTAL COST OF OWNERSHIP (Storage + 100 Verifications) ===");
        console.log("Merkle Total:", totalMerkleStorageGas + merkleVerifTotal);
        console.log("Simple Total:", totalSimpleStorageGas + simpleVerifTotal);

        uint256 savingsForVerification =
            (totalSimpleStorageGas + simpleVerifTotal) - (totalMerkleStorageGas + merkleVerifTotal);
        console.log("Merkle saved you:", savingsForVerification, "gas in storage and verification!");
    }
}
