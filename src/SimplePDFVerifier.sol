// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SimplePDFVerifier is Ownable {
    mapping(uint256 => bytes32) private s_pdfHashes;

    event HashUpdated(uint256 indexed pdfId, bytes32 hash);
    event HashVerified(uint256 indexed pdfId, bool success);

    constructor() Ownable(msg.sender) {}

    function setPdfHash(uint256 _pdfId, bytes32 _hash) external onlyOwner {
        s_pdfHashes[_pdfId] = _hash;
        emit HashUpdated(_pdfId, _hash);
    }

    function verifyPdf(uint256 _pdfId, bytes32 _hash) external onlyOwner returns (bool) {
        bool isValid = s_pdfHashes[_pdfId] == _hash;
        emit HashVerified(_pdfId, isValid);
        return isValid;
    }

    function getPdfHash(uint256 _pdfId) external view returns (bytes32) {
        return s_pdfHashes[_pdfId];
    }
}

