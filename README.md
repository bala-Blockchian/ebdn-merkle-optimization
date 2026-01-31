
# ZeroNorth eBDN Merkle Optimization Prototype

This repository contains a high-performance blockchain verification prototype designed to optimize the Electronic Bunker Delivery Note (eBDN) infrastructure. By transitioning from a linear hash-mapping model to a Merkle-based architecture, this solution reduces on-chain storage requirements by over 99%.

---

## Technical Innovation
Current eBDN systems anchor every individual document hash to the blockchain, creating linear growth in storage costs. This prototype introduces Merkle Root Anchoring, where thousands of documents are represented by a single 32-byte root hash on-chain.

### Key Benefits
* Massive Gas Savings: Storage costs reduced from 2.6M gas to ~25k gas for 100 documents.
* Active On-Chain Verification: Utilizing the blockchain for cryptographic verification logic rather than just a decentralized database.
* Scalability: Maintains a fixed on-chain state footprint regardless of increasing document volume.
* Security: Ensures 100% document integrity via OpenZeppelin's industry-standard cryptographic libraries.

---

## Performance Metrics (100 PDF Batch)

| Metric | Simple Mapping (Standard) | Merkle Verifier (Proposed) |
| :--- | :--- | :--- |
| On-Chain Storage Gas | 2,636,447 | 25,302 |
| Verification Gas (Per PDF) | 4,378 | 5,828 |
| Total Cost of Ownership | 3,074,247 | 608,102 |

Note: Gas is the unit of computation on the blockchain. While verification requires slightly more computation, the 99.04% reduction in storage costs makes this system 5x more cost-efficient overall.

---

## Project Structure
* src/MerklePDFVerifier.sol: Smart contract using MerkleProof for trustless validation.
* test/: Foundry-based test suite for gas profiling and storage comparison.
* script/: Automation scripts for root updates and deployments.

---

## Installation and Testing

### Prerequisites
* Foundry installed on your local machine.

### Run Gas Benchmarks
```shell
# Clone the repository
git clone https://github.com/bala-Blockchian/zeronorth-ebdn-merkle-optimization.git

# Run tests with gas reports
forge test -vvv --gas-report

```

---

## License

Distributed under the MIT License.

---

Developed by: Balamurugan Nagarajan
Role: Blockchain Developer
Date: January 31, 2026

