// SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.8.0;

contract Voting {
    // Estrutura para representar um candidato
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Endereços dos eleitores
    mapping(address => bool) private voters;

    // Armazenamento dos candidatos
    mapping(uint => Candidate) private candidates;

    // IDs dos candidatos
    uint[] private candidateIds;

    // Contagem dos votos brancos e nulos
    uint private nullVotes;
    uint private blankVotes;

    // Início e fim da votação (UNIX timestamp)
    uint private startTime; // 1678158000
    uint private endTime; // 1678244340

    // [10, 11, 12]
    // ["Bob", "Alice", "John"]
    // 0x000000000000000000000000000000000000000000000000000000006406a8b0000000000000000000000000000000000000000000000000000000006407f9f4000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000b000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000003426f6200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005416c69636500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044a6f686e00000000000000000000000000000000000000000000000000000000
    // Evento para notificar quando um voto é registrado com o hash do votante
    event VoteRegistered(address voter);
    event CandidateAdded(string name, uint id);
    event IsValid(bool valid);

    // Constructor para inicializar os candidatos e intervalo de votação (UNIX timestamp)
    constructor(uint _startTime, uint _endTime, uint[] memory _candidateIds, string[] memory _candidateNames) {
        require(_candidateIds.length == _candidateNames.length);

        startTime = _startTime;
        endTime = _endTime;

        for (uint i = 0; i < _candidateIds.length; i++) {
            addCandidate(_candidateIds[i], _candidateNames[i]);
        }
    }

    // Função para adicionar candidatos
    function addCandidate (uint _id, string memory _name) private {
        candidates[_id] = Candidate(_id, _name, 0);
        candidateIds.push(_id);
        emit CandidateAdded(_name, _id);
    }

    // Função para votar
    function vote (uint _candidateId) public {

        // Verifica se a votação está aberta
        require(isOpen());

        // Verifica se o eleitor já votou
        require(!voters[msg.sender]);

        // Verifica se o voto é branco
        if (_candidateId == 0) {
            blankVotes++;
            return;
        }

        // Verifica se o voto é nulo
        if (!isValid(_candidateId)) {
            nullVotes++;
            return;
        }

        emit IsValid(true);

        // Registra o voto
        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        // Emite um evento para notificar que um voto foi registrado retornando o hash do sender
        emit VoteRegistered(msg.sender);
    }

    // Função para verificar se a votação está aberta
    function isOpen() public view returns (bool) {
        return block.timestamp >= startTime && block.timestamp <= endTime;
    }

    // Função para consultar o número de votos de um candidato
    function getVoteCount(uint _candidateId) public view returns (uint) {
        require(isValid(_candidateId));
        return candidates[_candidateId].voteCount;
    }

    // Função para consultar o número de votos brancos
    function getBlankVotes() public view returns (uint) {
        return blankVotes;
    }

    // Função para consultar o número de votos nulos
    function getNullVotes() public view returns (uint) {
        return nullVotes;
    }

    // Função para consultar o nome de um candidato
    function getCandidateName(uint _id) public view returns (string memory) {
        return candidates[_id].name;
    }

    function getCandidates() public view returns (string memory) {
        // show like: [{"id":10,"name":"Bob"},{"id":11,"name":"Alice"},{"id":12,"name":"John"}]
        string memory candidatesJson = '[';
        for (uint i = 0; i < candidateIds.length; i++) {
            candidatesJson = string(abi.encodePacked(candidatesJson, '{"id":', uint2str(candidateIds[i]), ',"name":"', candidates[candidateIds[i]].name, '"}'));
            if (i < candidateIds.length - 1) {
                candidatesJson = string(abi.encodePacked(candidatesJson, ','));
            }
        }
        candidatesJson = string(abi.encodePacked(candidatesJson, ']'));
        return candidatesJson;
    }


    // Função que verifica se um candidato é válido
    function isValid(uint _id) public view returns (bool) {
        return keccak256(abi.encodePacked(candidates[_id].name)) != keccak256(abi.encodePacked(""));
    }

    function uint2str(uint v) internal pure returns (string memory) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i); // i + 1 is inefficient
        for (uint j = 0; j < i; j++) {
            s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
        }
        string memory str = string(s);  // memory isn't implicitly convertible to storage
        return str;
    }
}
