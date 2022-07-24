// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract Events{
    struct Event {
        address admin;
        uint256 id;
        string name;
        uint256 date;
        uint256 ticketCount;
        uint256 amount;
        uint256 ticketRemaining;
    }
    mapping (uint=>Event) public events; 
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint256 eventId;

    function createEvent(string memory name,uint256 date,uint256 ticketCount, uint256 amount) external{
        require(date>block.timestamp,"Date should be in future");
        require(ticketCount>0,"Need atleast one ticket");
        events[eventId]=Event(msg.sender,eventId,name,date,ticketCount,amount,ticketCount);
        eventId++;
    }

    function buyTickets(uint256 id,uint256 amount) payable external eventExists(id) eventActive(id){
        Event storage eventUser = events[id];
        
        require(eventUser.ticketRemaining>0,"No tickets remaining");
        require(amount<=eventUser.ticketRemaining,"dont have enough tickets remaining");
        require(msg.value==(amount*eventUser.amount),"The amount sent should be equal");
        tickets[msg.sender][id]+=amount;
        eventUser.ticketRemaining-=amount;
    }

    function trnasferTicket(uint id,uint amount,address to) external eventExists(id) eventActive(id) {
        require(tickets[msg.sender][0]>=amount,"You don't have enough tickets");
        tickets[msg.sender][0]-=amount;
        tickets[to][0]+=amount;
    }

    modifier eventExists(uint256 id){
        require(events[id].date!=0,"Event does not exist");
        _;
    }

    modifier eventActive(uint256 id){
        require(events[id].date>block.timestamp,"Event has already happened");
        _;
    }

}