pragma solidity ^0.4.0;

contract Election{
    //Struct for candidtates
    struct Candidate {
        string name; 
        string party;
        uint voteCount;
    }

    //Struct for voters
    struct Voter{
        bool voted;
        uint voteIndex;
        uint weight;
    }

    //contract address 
    address public owner;
    string public name;
    //mapping of address for Voters
    mapping(address => Voter) public voters;
    //array of candidates structured fromt he Candidate struct
    Candidate [] public candidates;
    uint public auctionEnd;

    event ElectionResult(string candidateName, uint voteCount);
    
    function Election(string _name, uint durationMinutes, string candidate1, string candidate2){
        owner = msg.sender;
        name = _name;
        auctionEnd = now + (durationMinutes + 1 minutes);

        candidates.push(Candidate(candidate1, 0));
        candidates.push(Candidate(candidate2,0));
    }

    function authorize(address voter){
        require(msg.sender == owner);
        require(!voters[voter].voted);

        voters[voter].weight = 1;
    }

    function vote(uint voteIndex){
        //you''re allowed to vote as long as we're within the voting time
        require(now < auctionEnd);
        //you can vote if you haven't voted
        require(!voters[msg.sender].voted);

        //marked that the voter has voted
        voters[msg.sender].voted = true;
        voters[msg.sender].voteIndex = voteIndex;

        candidates[voteIndex].voteCount += voters[msg.sender].weight;

    }


    function end(){
        require(msg.sender == owner);
        require(now >= auctionEnd);

        for(uint i=0; i< candidates.length;i++){
            emit ElectionResult(candidates[i].name, voteCount);
        }
    }
}