// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {AlphonsoGI} from "../src/AlphonsoGI.sol";

contract AlphonsoTraceTest is Test {
    AlphonsoGI public alphonsoGI;

    address admin;
    address lab;
    address regulator;
    address new_farmer = makeAddr("farmer");

    function setUp() public {
        admin = makeAddr("admin");
        lab = makeAddr("lab");
        regulator = makeAddr("regulator");

        alphonsoGI = new AlphonsoGI(admin, lab, regulator);
    }

    function test_add_remove_farmers() public {
        // adding farmer
        vm.prank(admin);
        alphonsoGI.addFarmer(new_farmer);
        console.log("Farmer added!");

        // remove farmer
        vm.prank(admin);
        alphonsoGI.removeFarmer(new_farmer);
        console.log("Farmer removed!");

        // fake admin call

        address fake_admin = makeAddr("fake");

        // try to add farmer
        vm.prank(fake_admin);
        vm.expectRevert();
        alphonsoGI.addFarmer(new_farmer);

        //try to remove farmer
        vm.prank(fake_admin);
        vm.expectRevert();
        alphonsoGI.removeFarmer(new_farmer);
        vm.stopPrank();

        // lab_admin register as farmer
        vm.prank(admin);
        vm.expectRevert("address_has_LAB_ROLE");
        alphonsoGI.addFarmer(lab);
        vm.stopPrank();

        // regulator add as farmer failed
        vm.prank(admin);
        vm.expectRevert("Address_has_GI_AUTHORITY_ROLE");
        alphonsoGI.addFarmer(regulator);
        vm.stopPrank();
    }

    function test_recordHarvest_fake_farmer_call() public {
        bytes32 batchID = keccak256("1234");
        string memory farmIdHash = "124324";
        string memory gps = "999999";
        uint256 date = block.timestamp;
        address fake_farmer = makeAddr("fake");

        vm.prank(fake_farmer);
        vm.expectRevert();
        alphonsoGI.recordHarvest(batchID, farmIdHash, gps, date);
        vm.stopPrank();
    }

    function test_recordHarvest() public {
        bytes32 batchID = keccak256("1234");
        string memory farmIdHash = "124324";
        string memory gps = "999999";
        uint256 date = block.timestamp;

        vm.prank(admin);
        alphonsoGI.addFarmer(new_farmer);

        vm.prank(new_farmer);
        alphonsoGI.recordHarvest(batchID, farmIdHash, gps, date);
        vm.stopPrank();

        (
            address batchFarmer,
            ,
            string memory gpsCoordinates,
            uint256 harvestDate,
            AlphonsoGI.Stage stage,
            bool giApproved
        ) = alphonsoGI.batches(batchID);
        assertEq(batchFarmer, new_farmer);
        assertEq(gpsCoordinates, gps);
        assertEq(uint256(stage), uint256(AlphonsoGI.Stage.Harvested));
        assertEq(harvestDate, date);
        assertEq(giApproved, false);
    }

    function test_recordQuality_fake_lab_admin() public {
        bytes32 batchID = keccak256("1234");
        string memory resultHash = "fake";
        address fake_lab = makeAddr("fake_lab");

        vm.prank(fake_lab);
        vm.expectRevert();
        alphonsoGI.recordQuality(batchID, resultHash);
    }

    function test_recordQuality() public {
        bytes32 batchID = keccak256("1234");
        string memory resultHash = "result_hash";
        string memory farmIdHash = "farmHash";
        string memory gps = "99.99";
        uint256 date = block.timestamp;

        // admin add farmer
        vm.prank(admin);
        alphonsoGI.addFarmer(new_farmer);

        // farmer records harvest
        vm.prank(new_farmer);
        alphonsoGI.recordHarvest(batchID, farmIdHash, gps, date);

        // lab records quality
        vm.prank(lab);
        alphonsoGI.recordQuality(batchID, resultHash);

        (,,,, AlphonsoGI.Stage stage,) = alphonsoGI.batches(batchID);

        assertEq(uint256(stage), uint256(AlphonsoGI.Stage.QualityChecked));
    }

    function test_approveGI_fake_regulator() public {
        bytes32 batchID = keccak256("1234");

        address fake_regulator = makeAddr("fake_regulator");

        vm.prank(fake_regulator);
        vm.expectRevert();
        alphonsoGI.approveGI(batchID);
    }

    function test_approveGI_success() public {
        bytes32 batchID = keccak256("1234");
        string memory farmIdHash = "farm";
        string memory gps = "gps";
        uint256 date = block.timestamp;
        string memory resultHash = "res";

  
        vm.prank(admin);
        alphonsoGI.addFarmer(new_farmer);

        vm.prank(new_farmer);
        alphonsoGI.recordHarvest(batchID, farmIdHash, gps, date);

        vm.prank(lab);
        alphonsoGI.recordQuality(batchID, resultHash);

        vm.prank(regulator);
        alphonsoGI.approveGI(batchID);

        (,,,, AlphonsoGI.Stage stage, bool giApproved) = alphonsoGI.batches(batchID);

        assertEq(giApproved, true);
        assertEq(uint256(stage), uint256(AlphonsoGI.Stage.Exported));
    }

    function test_verifyGI() public {
        bytes32 batchID = keccak256("1234");
        string memory farmIdHash = "farm";
        string memory gps = "gps";
        uint256 date = block.timestamp;
        string memory resultHash = "res";

        vm.prank(admin);
        alphonsoGI.addFarmer(new_farmer);

        vm.prank(new_farmer);
        alphonsoGI.recordHarvest(batchID, farmIdHash, gps, date);

        vm.prank(lab);
        alphonsoGI.recordQuality(batchID, resultHash);

        vm.prank(regulator);
        alphonsoGI.approveGI(batchID);

        bool verified = alphonsoGI.verifyGI(batchID);
        assertTrue(verified);
    }
}
