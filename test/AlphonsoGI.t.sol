// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {AlphonsoGI} from "../src/AlphonsoGI.sol";

contract AlphonsoTraceTest is Test {
    AlphonsoGI public alphonsoGI;

    address admin ;
    address lab ;
    address regulator;


    function setUp() public {
        admin = makeAddr("admin");
        lab= makeAddr("lab");
        regulator = makeAddr("regulator");

        alphonsoGI = new AlphonsoGI(admin , lab ,regulator);
    }

    function 
}
