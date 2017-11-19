pragma solidity ^0.4.13;

contract SupplyInsure {
    address receiver;
    address sender;
    address oracle;
    uint value;

    string trackingNumber;

    bool delivered;
    bool delayed;
    bool confirmed;

    modifier isSender() {if(msg.sender == sender) {_;}}
    modifier validOracle() {if(msg.sender == oracle && confirmed) {_;}}

    function SupplyInsure(string _trackingNumber, address _sender, address _oracle, uint _value) payable {
        require(msg.value >= value);
        trackingNumber = _trackingNumber;
        receiver = msg.sender;
        sender = _sender;
        oracle = _oracle;
        value = _value
    }

    function confirmTransaction(address _oracle, uint value) //sender must also confirm address of oracle 
    isSender()
    {
        if (oracle == _oracle) {
            confirmed = true;
        }
    }

    function deliver() 
    validOracle()
    {
        msg.sender.transfer(value);
        suicide(reciever);
    }

    function refund()
    validOracle()
    {
        suicide(receiver);
    }


}