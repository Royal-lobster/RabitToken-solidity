// SPDX-License-Identifier: MIT
pragma solidity ^0.5.1;

contract rabitTokenProtocol{
    uint256 public total_rabits;
    address payable master;
    mapping(address => uint256) public balences;

    //event to log the data to blockchain during purchase
    event Purchase(
        address indexed _buyer, 
        uint256 _amount, 
        uint256 _total_balence
    );

    event Sell(
        address indexed _seller,
        uint256 _amount,
        uint256 _total_balence
    );

    //constructor to set master address when initialized
    constructor() public {
        master = msg.sender;
    }

    //function to allow users to buy rabit with etherium
    function buyRabitWithEth() public payable{

        //transfer eth to master wallet from user
        master.transfer(msg.value);

        //create rabit token from thin air and add it to the user balence
        balences[msg.sender] = msg.value * 2;

        //increase total rabit tokens in circulation
        total_rabits += balences[msg.sender];

        //log the purchase to the block chain
        emit Purchase(msg.sender, msg.value, balences[msg.sender]);
    }

    //function to allow users to sell rabit with etherium
    function sellRabitForEth(uint256 _amount) public payable{
        
        //make sure the user has the amount in their account before processing
        require(balences[msg.sender] >= _amount, "NO ENOUGH RABIT TOKENS IN YOUR ACCOUNT");

        //transfer the ammount to the user
        balences[msg.sender] -= _amount;
        msg.sender.transfer(_amount/2000000000000000000);

        //reduce number of rabit token in state
        total_rabits -= _amount;

        //emit event to chain
        emit Sell(msg.sender, _amount, balences[msg.sender]);
    }
}
