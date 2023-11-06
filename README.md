# Voting Smart Contract

The Voting smart contract is a decentralized application written in Solidity that allows for secure and transparent voting processes on the blockchain. It ensures the integrity of the voting system by providing the following features:

## Features

1. **Candidate Management:** 
    - Enables the addition of candidates for voting.
    - Tracks candidate information such as their names and respective vote counts.

2. **Vote Casting:** 
    - Allows registered users to cast their votes for their preferred candidate.
    - Supports the option for blank voting and ensures the validity of the chosen candidate.

3. **Vote Validation:**
    - Checks the validity of the candidates to prevent manipulation or invalid votes.

4. **Voting Period Control:** 
    - Sets a specific time frame for the voting process to ensure fairness and security.

## Smart Contract Functions

The smart contract includes the following functions:

- `addCandidate`: Add a new candidate to the voting system.
- `vote`: Register a vote for a specific candidate or cast a blank/null vote.
- `isOpen`: Check if the voting period is open.
- `getVoteCount`: Retrieve the number of votes for a specific candidate.
- `getBlankVotes`: Get the count of blank votes.
- `getNullVotes`: Get the count of null votes.
- `getCandidateName`: Retrieve the name of a candidate by their ID.
- `getCandidates`: Obtain a list of candidates in JSON format.

## Getting Started

To use this smart contract:

1. Deploy the `SecureVoting.sol` contract on a compatible blockchain.
2. Interact with the deployed contract through a DApp or a client application.
