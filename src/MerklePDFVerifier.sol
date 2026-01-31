// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerklePDFVerifier is Ownable {
    error PDFVerifier__InvalidProof();

    bytes32 private i_merkleRoot;

    event RootUpdated(bytes32 newRoot);
    event MerkleVerified(bytes32 indexed leaf, bool success);

    constructor() Ownable(msg.sender) {}

    function updateRoot(bytes32 _newRoot) external onlyOwner {
        i_merkleRoot = _newRoot;
        emit RootUpdated(_newRoot);
    }

    function verify(bytes32 pdfHash, bytes32[] calldata merkleProof) external returns (bool) {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(pdfHash))));

        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert PDFVerifier__InvalidProof();
        }

        emit MerkleVerified(leaf, true);
        return true;
    }

    function verifyWithLeaf(bytes32 leaf, bytes32[] calldata merkleProof) external returns (bool) {
        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert PDFVerifier__InvalidProof();
        }

        emit MerkleVerified(leaf, true);
        return true;
    }

    function getRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }
}
