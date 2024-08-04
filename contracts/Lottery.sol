pragma solidity 0.5.16;
import "./MDY.sol";

contract Lottery {
    address public owner;
    uint256 public jackpot;
    uint256 public ticketPrice;
    uint256 public maxTickets;
    BEP20Token public token;
    mapping (address => uint256) public tickets;
    address[] public players;
    
    constructor(uint256 _ticketPrice, uint256 _maxTickets, address MDY) public {
        owner = msg.sender;
        ticketPrice = _ticketPrice;
        maxTickets = _maxTickets;
        token = BEP20Token(MDY);
    }
    
    function buyTicket() public payable {
        require(msg.value == ticketPrice, "Ticket price has changed. Please check and try again.");
        require(players.length < maxTickets, "The lottery has reached its maximum number of tickets sold.");
        //token.myApprove(msg.sender, owner, msg.value);
        token.transferFrom(msg.sender, owner, msg.value);
        tickets[msg.sender] += 1;
        players.push(msg.sender);
        jackpot += msg.value;
    }
    
    function pickWinner() public {
        require(msg.sender == owner, "Only the owner can pick the winner.");
        require(players.length > 0, "There are no players in the lottery.");
        
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp,  block.difficulty))) % players.length;
        address winner = players[randomIndex];
        //token.myApprove(msg.sender, winner, jackpot);
        token.transferFrom(msg.sender, winner, jackpot);
        jackpot = 0;
        for (uint i = 0; i < players.length; i++) {
            delete tickets[players[i]];
        }
        delete players;
        // delete tickets;
    }
    
    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    function getBalancePlayers() public view returns (uint256) {
        return token.balanceOf(msg.sender);
    }
}