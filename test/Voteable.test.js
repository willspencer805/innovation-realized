const { assert, expect } = require("chai")
const { ethers, deployments, getNamedAccounts } = require("hardhat")
// const { ethers } = require("ethers")

describe("Voteable Unit Tests", function () {
  beforeEach(async function () {
    deployer = (await getNamedAccounts()).deployer
    proposer1 = (await getNamedAccounts()).proposer1
    proposer2 = (await getNamedAccounts()).proposer2
    await deployments.fixture(["all"])
    votes = await ethers.getContract("Voteable", deployer)
  })

  describe("Voteable", function () {
    describe("create proposal", function () {
      it("allows a user to submit a proposal", async function () {
        await expect(votes.createProposal()).to.emit(votes, "ProposalCreated")
        proposal = await votes.getProposalByIndex(0)
        assert.equal(proposal.proposer, deployer)
        assert.equal(proposal.votes.toString(), "0")
      })
    })

    describe("vote", function () {
      beforeEach(async function () {
        await votes.createProposal()
      })

      it("allows a user to vote", async function () {
        await expect(votes.vote(0)).to.emit(votes, "Voted")
      })
    })

    describe("winner", function () {
      beforeEach(async function () {
        await votes.createProposal()
        await votes.vote(0)
      })

      it("picks a winner", async function () {
        winner = await votes.getWinner()
        assert.equal(winner, deployer)
      })
    })
  })
})
