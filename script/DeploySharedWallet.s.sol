// SPDX-License-Identifier:MIT
pragma solidity ^0.8.25;

import "forge-std/Script.sol";
import {SharedWallet} from "../src/SharedWallet.sol";

contract DeploySharedWallet is Script {
    function run() external {
        vm.startBroadcast();
        // Define the addresses and allowances for the spenders
        address[] memory spenderAddresses = new address[](2);
        spenderAddresses[0] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        spenderAddresses[1] = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;

        uint256[] memory spenderAllowances = new uint256[](2);
        spenderAllowances[0] = 1 ether;
        spenderAllowances[1] = 2 ether;

        // SharedWallet sharedWallet=new SharedWallet(spenderAddresses,spenderAllowances);
        SharedWallet sdWallet = new SharedWallet{value:10 ether}(
            spenderAddresses,
            spenderAllowances
        );
        console.log("SharedWallet deployed to:", address(sdWallet));
        console.log("SharedWallet owner:", sdWallet.owner());

        vm.stopBroadcast();
    }
}
