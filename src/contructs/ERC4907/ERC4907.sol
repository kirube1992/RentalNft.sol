// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./IERC4907.sol";

contract ERC4907 is ERC721URIStorage, IERC4907 {
    struct Renter 
    {
        mapping(address => uint256) approvedAmount;
        address user;   
        uint64 expires; 
    }
        

    mapping (uint256  => Renter) internal _users;
    mapping(uint256 tokenId=>uint256 value) tokenBalances;
    constructor(string memory name_, string memory symbol_)
     ERC721(name_,symbol_)
     {         
     }
    

    function setUser(uint256 tokenId, address user, uint64 expires,uint256 approvedAmount)payable public virtual{
        require(ownerOf(tokenId)==user || _getApproved(tokenId)==user,"not owner or apporved");
        require(userOf(tokenId)==address(0),"token still belogs to someone else");
        require(payable(address(this)).send(msg.value),"failed to send funds");
        Renter storage renter =  _users[tokenId];
        renter.user = user;
        renter.expires = expires;
        renter.approvedAmount[user]==approvedAmount;

        emit UpdateUser(tokenId,user,expires);
    }


    function userOf(uint256 tokenId)public view virtual returns(address){
        if( uint256(_users[tokenId].expires) >=  block.timestamp){
            return  _users[tokenId].user; 
        }
        else{
            return address(0);
        }
    }


    function userExpires(uint256 tokenId) public view virtual returns(uint256){
        return _users[tokenId].expires;
    }

    function setOrIncreaseBalance(uint256 tokenId)public payable returns (bool) {
        require(ownerOf(tokenId)==msg.sender || _getApproved(tokenId)==msg.sender,"not the owner of the token");
        require(payable(address(this)).send(msg.value),"failed to send funds");
        tokenBalances[tokenId] =  msg.value+tokenBalances[tokenId];
        return true;
    }


    function extendRentingPeriod(uint256 tokenId)public payable {
        require(_users[tokenId].user==msg.sender,"not the renter of the nft");
        require(payable(address(this)).send(msg.value),"failed to transfer funds");
        _users[tokenId].expires =  _users[tokenId].expires+uint64(msg.value);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC4907).interfaceId || super.supportsInterface(interfaceId);
    }


    function _burn4907(uint256 tokenId) internal   {
        _burn(tokenId);
        delete _users[tokenId];
        emit UpdateUser(tokenId, address(0), 0);
    }
} 