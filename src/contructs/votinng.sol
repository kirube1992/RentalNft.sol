// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
        uint256 weight;
    }

    struct Proposal {
        string name;
        uint256 voteCount;
        uint256 nftID;
        uint256 expiration;
        address currentUser;
    }

    struct NFT {
        uint256 id;
        address[] businessUnits;
        address owner;
    }

    mapping(address => Voter) public voters;
    Proposal[] public proposals;
    NFT[] public nfts;
    address public admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this operation");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerVoter(address voterAddress) public onlyAdmin {
        require(!voters[voterAddress].isRegistered, "Voter is already registered");
        voters[voterAddress] = Voter(true, false, 0, 1);
    }

    function createProposal(string memory proposalName, uint256 nftID, uint256 expirationTime) public onlyAdmin {
        proposals.push(Proposal({
            name: proposalName,
            voteCount: 0,
            nftID: nftID,
            expiration: expirationTime,
            currentUser: msg.sender
        }));
    }

    function createProposalForNFT(uint256 id, string memory proposalCategory) public onlyAdmin {
        require(nfts.length > id, "Invalid NFT ID");
        proposals.push(Proposal({
            name: proposalCategory,
            voteCount: 0,
            nftID: id,
            expiration: 0, 
            currentUser: msg.sender
        }));
    }

    function createNewRentalNFT() public onlyAdmin {
        nfts.push(NFT({
            id: nfts.length,
            businessUnits: new address[](0),
            owner: msg.sender
        }));
    }

    function vote(uint256 proposalId) public {
        require(voters[msg.sender].isRegistered, "You are not registered to vote");
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(proposals[proposalId].expiration > block.timestamp, "Proposal has expired");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = proposalId;
        proposals[proposalId].voteCount++;
    }

    function winningProposal() public view returns (uint256 winningProposalId) {
        uint256 maxVotes = 0;
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > maxVotes) {
                maxVotes = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
    }
}