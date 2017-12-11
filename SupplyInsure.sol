pragma solidity ^0.4.13;

contract SupplierOracle {
    function subscribe(bytes32 params, address receiver, address sender, uint reward) returns (bool);
    function confirm() returns (bool);
    function unsubscribe(bytes32 params) returns (bool);
    function() payable;
}

contract SupplyInsure {
    address receiver;
    address sender;
    address oracleAddress;
    SupplierOracle oracle;
    uint value;
    uint reward;
    bool senderConfirmed;
    bool oracleConfirmed;
    bool withdrawn;

    bytes32 params;

    modifier confirmed() {if(senderConfirmed && oracleConfirmed) {_;}}
    modifier isReceiver() {if(msg.sender == receiver) {_;}}
    modifier isSender() {if(msg.sender == sender) {_;}}
    modifier validOracle() {if(msg.sender == oracleAddress) {_;}}

    function SupplyInsure(bytes32 _params, address _sender, address _oracle, uint _value, uint _reward) payable {
        require(msg.value >= _value + _reward);
        receiver = msg.sender;
        sender = _sender;
        oracleAddress = _oracle;
        oracle = SupplierOracle(_oracle);
        value = _value;
        reward = _reward;
        params = _params;
        oracle.subscribe(params, this);
    }

    function senderConfirm() 
    isSender()
    {
        senderConfirmed = true;
    }

    function oracleConfirm()
    validOracle()
    {
        if (senderConfirmed) { //sender must confirm first
            oracleConfirmed = true;
        }
    }

    function withdraw() payable
    isReceiver()
    {
        if (!oracleConfirmed) { //cannot withdraw if oracle has also confirmed
            receiver.transfer(this.balance);
        }
    }

    function deliver() payable
    confirmed()
    validOracle()
    {
        sender.transfer(value);
        oracle.transfer(reward);
        receiver.transfer(this.balance);
    }

    function refund() payable
    confirmed()
    validOracle()
    {
        oracle.transfer(reward);
        receiver.transfer(this.balance);
    }
}