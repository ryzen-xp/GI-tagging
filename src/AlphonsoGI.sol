// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract AlphonsoGI is AccessControl {

     ////////////////////////////////
    /// === Role Definitions === ///
   ////////////////////////////////  

    bytes32 public constant FARMER_ROLE = keccak256("FARMER_ROLE");
    bytes32 public constant LAB_ROLE = keccak256("LAB_ROLE");
    bytes32 public constant GI_AUTHORITY_ROLE = keccak256("GI_AUTHORITY_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

      //////////////////////////////
    /// === Constructor === //////
   ////////////////////////////// 

    constructor(address Admin, address lab_admin, address regulator) {
        _grantRole(ADMIN_ROLE, Admin);
        _grantRole(LAB_ROLE, lab_admin);
        _grantRole(GI_AUTHORITY_ROLE, regulator);
    }

     //////////////////////////////
    /// === Enums & Structs === ///
    //////////////////////////////

    enum Stage {
        Harvested,
        Packed,
        QualityChecked,
        Exported
    }

    struct Batch {
        address farmer;
        string farmIdHash;         // Hashed farmer/location ID
        string gpsCoordinates;
        uint256 harvestDate;
        Stage stage;
        bool giApproved;
    }

    //////////////////////////////
    /// === State Variables === ///
    //////////////////////////////

    mapping(bytes32 => Batch) public batches; // key = batchID

      //////////////////////////////
     /// === Events         === ///
    //////////////////////////////

    event HarvestRecorded(bytes32 batchID, string farmIdHash, uint256 date);
    event QualityChecked(bytes32 batchID, string resultHash);
    event GIApproved(bytes32 batchID, uint256 date);

    //////////////////////////////
    /// === Farmer Functions === ///
    //////////////////////////////

    function recordHarvest(bytes32 batchID, string memory farmIdHash, string memory gps, uint256 date)
        external
        onlyRole(FARMER_ROLE)
    {
        require(batches[batchID].farmer == address(0), "Batch exists");
        require(date != uint256(0), "Invalid_Date");

        batches[batchID] = Batch(msg.sender, farmIdHash, gps, date, Stage.Harvested, false);
        emit HarvestRecorded(batchID, farmIdHash, date);
    }

    //////////////////////////////
    /// === Lab Functions === ///
    //////////////////////////////

    function recordQuality(bytes32 batchID, string memory resultHash) external onlyRole(LAB_ROLE) {
        require(batches[batchID].farmer != address(0), "Batch_not_found");
        require(batches[batchID].stage != Stage.QualityChecked, "Already_Quality_checked");

        batches[batchID].stage = Stage.QualityChecked;
        emit QualityChecked(batchID, resultHash);
    }

     //////////////////////////////
    ///  Regulator Functions /////
   //////////////////////////////

    function approveGI(bytes32 batchID) external onlyRole(GI_AUTHORITY_ROLE) {
        require(batches[batchID].stage == Stage.QualityChecked, "Quality_check_needed");

        batches[batchID].giApproved = true;
        batches[batchID].stage = Stage.Exported;

        emit GIApproved(batchID, block.timestamp);
    }

    //////////////////////////////////////
   ///// === Public View Functions === //
  //////////////////////////////////////


    function verifyGI(bytes32 batchID) external view returns (bool) {
        return batches[batchID].giApproved;
    }

      //////////////////////////////
    /// === Admin Functions === ///
    //////////////////////////////


    function addFarmer(address farmer) external onlyRole(ADMIN_ROLE) {
        require(!hasRole(LAB_ROLE, farmer), "address_has_LAB_ROLE");
        require(!hasRole(GI_AUTHORITY_ROLE, farmer), "Address_has_GI_AUTHORITY_ROLE");

        _grantRole(FARMER_ROLE, farmer);
    }
    

    function removeFarmer(address farmer) external onlyRole(ADMIN_ROLE) {
        _revokeRole(FARMER_ROLE, farmer);
    }
}
