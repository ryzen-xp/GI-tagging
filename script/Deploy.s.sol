// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {AlphonsoGI} from "../src/AlphonsoGI.sol";

contract DeployScript  is Script {
    AlphonsoGI public alphonsoGI;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

    
        address admin = vm.envAddress("ADMIN_ADDRESS");
        address lab = vm.envAddress("LAB_ADDRESS");
        address regulator = vm.envAddress("REGULATOR_ADDRESS");

        alphonsoGI = new AlphonsoGI(admin, lab, regulator);

        console.log("AlphonsoGI_deployed_at:==>", address(alphonsoGI));

        vm.stopBroadcast();
    }
}
