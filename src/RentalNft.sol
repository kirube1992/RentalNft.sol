interface IRentalNFT is IERC721 {
struct UserInfo {
address user;
uint64 expires;
}
event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);
function setUser(uint256 tokenId, address user, uint64 expires) external;
function userOf(uint256 tokenId) external view returns (address);
function userExpires(uint256 tokenId) external view returns (uint256);
}
