//SPDX-License-Identifier:MIT;

pragma solidity ^0.6.0;

contract Ticket{

    
    //we need to track the status of the seats
    //we will use a custom datastructure called enum

    enum Statuses {available, notavailable}
    //creating object of enum
    Statuses ticketStatus;

    //events communicate with a front-end website that something has happened on the blockchain
    event Occupy(address _occupant, uint _amountpayed);

    //owner is who deploys the smart contract 
    // payable is used to pay the owner
    //address data type
    // owner is state variable 
    //state variable are written to block chain
    address payable public owner;


    // msg.sender captures the adress of the smart contract interactor
    constructor() public {
        owner=msg.sender;
        //default value of ticket status
        ticketStatus=Statuses.available;
    }

    // we want to check the vacancy as well as amount payable before booking the seat
    //we use modifiers for these checks
    // with error message
    //modifier aims to change the behaviour of the function 
    modifier onlyAvailable{
        require(ticketStatus==Statuses.available, "not available");
        _;
    } 

    modifier cost(uint _amount){
        require(msg.value >= _amount);
        _;
    }

    //named function book()
    //external function be called from a third party contract
     receive()  external payable onlyAvailable cost (2 ether)  {

        //afte booking default status changes
        ticketStatus=Statuses.notavailable;

        //value == ether
        owner.transfer(msg.value);
        emit Occupy(msg.sender,msg.value);
    }
}
