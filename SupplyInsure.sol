pragma solidity ^0.4.13;

interface Oracle {
    function subscribe(string trackingNum, address receiver, address sender, uint reward) returns (bool);
    function confirm() returns (bool);
    function unsubscribe(string trackingNumber) returns (bool);
}

contract SupplyInsure {
    address receiver;
    address sender;
    Oracle oracle;
    uint value;
    uint reward;

    string trackingNumber;

    bool delivered;
    bool delayed;
    bool senderConfirmed;
    bool oracleSubscribed;
    bool oracleConfirmed;

    modifier isSender() {if(msg.sender == sender) {_;}}
    modifier validOracle() {if(msg.sender == oracle && oracleConfirmed) {_;}}

    function SupplyInsure(string _trackingNumber, address _sender, address _oracle, uint _value, uint _reward) payable {
        require(msg.value >= _value + _reward);
        trackingNumber = _trackingNumber;
        receiver = msg.sender;
        sender = _sender;
        oracle = Oracle(_oracle);
        value = _value;
        reward = _reward;
        oracleSubscribed = oracle.subscribe(trackingNumber, receiver, sender, reward); // returns true on success
    }

    function confirmTransaction(address _oracle, uint _value) //sender must also confirm address of oracle as well as the value of product
    isSender()
    {
        if (oracle == _oracle && value == _value) {
            senderConfirmed = true;
        } else {
            revert();
        }
        oracleConfirmed = oracle.confirm();

    }

    function cancelTransaction() {
        require(msg.sender == receiver && !senderConfirmed);
        oracle.unsubscribe(trackingNumber);
        selfdestruct(receiver);
    }

    function deliver() 
    validOracle()
    {
        sender.transfer(value);
        oracle.transfer(reward);
        selfdestruct(receiver);
    }

    function refund()
    validOracle()
    {
        oracle.transfer(reward);
        selfdestruct(receiver);
    }
}