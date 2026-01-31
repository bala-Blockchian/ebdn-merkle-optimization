// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";

contract GenerateInput is Script {
    string[] types = new string[](1);
    uint256 count;
    bytes32[] whitelist = new bytes32[](4);
    string private constant INPUT_PATH = "/script/target/input.json";

    function run() public {
        types[0] = "bytes32";

        whitelist[0] = keccak256("pdf_content_1");
        whitelist[1] = keccak256("pdf_content_2");
        whitelist[2] = keccak256("pdf_content_3");
        whitelist[3] = keccak256("pdf_content_4");

        count = whitelist.length;
        string memory input = _createJSON();

        vm.writeFile(string.concat(vm.projectRoot(), INPUT_PATH), input);

        console.log("DONE: The output is found at %s", INPUT_PATH);
    }

    function _createJSON() internal view returns (string memory) {
        string memory countString = vm.toString(count);
        string memory json = string.concat('{ "types": ["bytes32"], "count":', countString, ',"values": {');

        for (uint256 i = 0; i < whitelist.length; i++) {
            string memory hashStr = vm.toString(whitelist[i]);

            if (i == whitelist.length - 1) {
                json = string.concat(json, '"', vm.toString(i), '"', ': { "0":', '"', hashStr, '"', " }");
            } else {
                json = string.concat(json, '"', vm.toString(i), '"', ': { "0":', '"', hashStr, '"', " },");
            }
        }
        json = string.concat(json, "} }");

        return json;
    }
}
