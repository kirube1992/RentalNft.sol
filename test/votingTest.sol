// test/Voting.t.sol
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/Voting.sol";

contract VotingTest is Test {
    Voting public votingContract;
    address public admin;
    address public voter1;
    address public voter2;

    function setUp() public {
        votingContract = new Voting();
        admin = votingContract.admin();
        voter1 = address(1);
        voter2 = address(2);
    }

    function testRegisterVoter() public {
        vm.startPrank(admin);
        votingContract.registerVoter(voter1);
        Voting.Voter memory voter = votingContract.voters(voter1);
        assertEq(voter.isRegistered, true);
        vm.stopPrank();
    }

    function testCreateProposal() public {
        vm.startPrank(admin);
        string memory proposalName = "Test Proposal";
        uint256 nftID = 0;
        uint256 expirationTime = block.timestamp + 3600; // 1 hour from now

        votingContract.createProposal(proposalName, nftID, expirationTime);
        Voting.Proposal memory proposal = votingContract.proposals(0);
        assertEq(proposal.name, proposalName);
        assertEq(proposal.nftID, nftID);
        assertEq(proposal.expiration, expirationTime);
        vm.stopPrank();
    }

    function testVoting() public {
        vm.startPrank(admin);
        votingContract.registerVoter(voter1);
        string memory proposalName = "Test Proposal";
        uint256 nftID = 0;
        uint256 expirationTime = block.timestamp + 3600;
        votingContract.createProposal(proposalName, nftID, expirationTime);
        vm.stopPrank();

        vm.startPrank(voter1);
        votingContract.vote(0);
        Voting.Proposal memory proposal = votingContract.proposals(0);
        assertEq(proposal.voteCount, 1);
        vm.stopPrank();
    }

    function testWinningProposal() public {
        vm.startPrank(admin);
        votingContract.registerVoter(voter1);
        votingContract.registerVoter(voter2);

        string memory proposalName1 = "Proposal 1";
        string memory proposalName2 = "Proposal 2";
        uint256 nftID = 0;
        uint256 expirationTime = block.timestamp + 3600;

        votingContract.createProposal(proposalName1, nftID, expirationTime);
        votingContract.createProposal(proposalName2, nftID, expirationTime);
        vm.stopPrank();

        vm.startPrank(voter1);
        votingContract.vote(0);
        vm.stopPrank();

        vm.startPrank(voter2);
        votingContract.vote(1);
        vm.stopPrank();

        uint256 winningProposalId = votingContract.winningProposal();
        assertEq(winningProposalId, 1);
    }

    function testOnlyAdminRegisterVoter() public {
        vm.expectRevert("Only the admin can perform this operation");
        vm.prank(voter1);
        votingContract.registerVoter(voter2);
    }
}