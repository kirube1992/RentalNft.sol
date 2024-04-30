// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "forge-std/Test.sol";
import "../RentalNft.sol";

contract RentalNftTest is Test {
    RentalNft public rentalNft;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = msg.sender;
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
    }

    function testMintNFT() public {
        uint256 initialBalance = rentalNft.balanceOf(owner);
        uint256 finalBalance = rentalNft.balanceOf(owner);
        assertEq(finalBalance, initialBalance + 1, "NFT minting failed");
    }

    function testBurnNFT() public {
        uint256 tokenId = 1;
        uint256 initialBalance = rentalNft.balanceOf(owner);
        rentalNft.burnNFT(tokenId, owner);
        uint256 finalBalance = rentalNft.balanceOf(owner);
        assertEq(finalBalance, initialBalance, "NFT burning failed");
    }

    function testTransferNFT() public {
        uint256 tokenId = 1;
        rentalNft.transferNFT(tokenId, owner, user1);
        assertEq(rentalNft.ownerOf(tokenId), user1, "NFT transfer failed");
    }

    function testSetTokenURI() public {
        uint256 tokenId = 1;
        rentalNft.setTokenURI(tokenId, newURI);
        string memory actualURI = rentalNft.tokenURI(tokenId);
        assertEq(actualURI, newURI, "Token URI update failed");
    }

    function testRentNFT() public {
        uint256 tokenId = 1;
        uint64 rentDuration = 3600; 
        rentalNft.setUser(tokenId, user1, rentDuration);
        assertEq(rentalNft.getUserExpiration(tokenId), block.timestamp + rentDuration, "NFT rent failed");
    }
}