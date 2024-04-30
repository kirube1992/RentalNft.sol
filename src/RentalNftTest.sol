// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC4907/ERC4907.sol";



contract RentalNFT is  ERC4907,Ownable{
    uint256 private lastTokenId = 1;




    constructor(string memory nftName,string memory nftSymbol, string memory tokenURI) ERC4907(nftName,nftSymbol) Ownable(msg.sender){
        _mint(msg.sender, lastTokenId);
        _setTokenURI(lastTokenId, tokenURI);
        lastTokenId++;

    }

    function mintNFT(string memory tokenURI)public onlyOwner{
        _mint(owner(),lastTokenId);
        _setTokenURI(lastTokenId,tokenURI);
        lastTokenId++;
    }


    function burnNFT(uint256 tokenId, address nftOwner)public{
        require(ownerOf(tokenId)==nftOwner,"Invalid Token");
        _burn4907(tokenId);
    }

    function transferNFT(uint256 tokenId,address from, address to)public {
        _transfer(from, to, tokenId);
    }


}



