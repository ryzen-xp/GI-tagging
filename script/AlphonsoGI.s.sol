// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {AlphonsoGI} from "../src/AlphonsoGI.sol";

contract CounterScript is Script {
    AlphonsoGI public alphonsoGI;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // alphonsoGI = new AlphonsoGI();

        vm.stopBroadcast();
    }
}
