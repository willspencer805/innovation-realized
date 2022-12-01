// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voteable is Ownable {
    struct Proposal {
        address proposer;
        uint64 votes;
    }

    uint8 constant MAX_VOTES = 1;
    uint8 constant MAX_PROPOSALS = 1;

    event ProposalCreated(address indexed creator);
    event Voted(address indexed voter, uint256 totalVotes);

    Proposal[] proposals; // better way to store all proposals?

    // Tracks number of proposals submitted and number of votes per address
    mapping(address => uint8) addressToProposal;
    mapping(address => uint8) addressToVote;

    function createProposal() public {
        require(
            addressToProposal[msg.sender] < MAX_PROPOSALS,
            "Proposal already created."
        );
        addressToProposal[msg.sender] += 1;
        proposals.push(Proposal(msg.sender, 0));
        emit ProposalCreated(msg.sender);
    }

    function vote(uint256 _index) public {
        require(addressToVote[msg.sender] < MAX_VOTES, "Already voted.");
        addressToVote[msg.sender] += 1;
        proposals[_index].votes += 1;
        emit Voted(msg.sender, proposals[_index].votes);
    }

    // Notes:
    // Can definitely make this more efficient
    // Might want to add check so that this can only be called once
    function getWinner() public view onlyOwner returns (address) {
        uint64 i;
        uint64 maxVotes = 0;
        uint256 length = proposals.length;
        Proposal[] memory _proposals = proposals;
        address winner;
        for (i = 0; i < length; i++) {
            if (_proposals[i].votes > maxVotes) {
                winner = _proposals[i].proposer;
                maxVotes = _proposals[i].votes;
            }
        }
        // do something with winner address here
        return winner;
    }

    function getProposalByIndex(uint256 _index)
        public
        view
        returns (Proposal memory)
    {
        return proposals[_index];
    }
}
