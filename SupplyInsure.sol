pragma solidity ^0.4.18;

contract Oracle {
    function subscribe(bytes32[] params, address insurance) returns (bool);
    function confirm() returns (bool);
    function unsubscribe(address insurance) returns (bool);
    function() payable;
}

contract SupplyInsure {
    address public receiver;
    address public sender;
    address public oracleAddress;
    Oracle public oracle;
    uint value;
    uint reward;
    bool public senderConfirmed;
    bool public oracleConfirmed;
    bool public withdrawn;
    bool public ended;

    bytes32 public params;

    modifier confirmed() {if(senderConfirmed && oracleConfirmed && !ended) {_;}}
    modifier isReceiver() {if(msg.sender == receiver) {_;}}
    modifier isSender() {if(msg.sender == sender) {_;}}
    modifier validOracle() {if(msg.sender == oracleAddress) {_;}}

    event SenderConfirmed(address sender);
    event OracleConfirmed(address oracle);
    event Withdrawn();
    event Delivered();
    event Refunded();

    function SupplyInsure(bytes32 _params, address _sender, address _oracle, uint _value, uint _reward) payable {
        require(msg.value >= _value + _reward);
        receiver = msg.sender;
        sender = _sender;
        oracleAddress = _oracle;
        oracle = Oracle(_oracle);
        value = _value;
        reward = _reward;
        params = _params;
        msg.sender.transfer(msg.value - _value - _reward);
    }
    
    function oracleSubscribe() {
        if (senderConfirmed) {
            Oracle o = Oracle(oracleAddress);
            o.subscribe(params, this);
        }
    }

    function senderConfirm() 
    isSender()
    {
        senderConfirmed = true;
        SenderConfirmed(msg.sender);
    }

    function oracleConfirm()
    validOracle()
    {
        oracleConfirmed = true;
        OracleConfirmed(msg.sender);
    }

    function withdraw() payable
    isReceiver()
    {
        if (!oracleConfirmed) { //cannot withdraw if oracle has also confirmed
            receiver.transfer(this.balance);
        }
        ended = true;
        Withdrawn();
    }

    function deliver() payable
    confirmed()
    validOracle()
    {
        sender.transfer(value);
        oracle.transfer(reward);
        receiver.transfer(this.balance);
        ended = true;
        Delivered();
    }

    function refund() payable
    confirmed()
    validOracle()
    {
        oracle.transfer(reward);
        receiver.transfer(this.balance);
        ended = true;
        Refunded();
    }
}