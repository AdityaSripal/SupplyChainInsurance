pragma solidity ^0.4.13;

contract Insurance {
    function deliver();
    function refund();
}

contract Oracle {
    function subscribe(bytes32 params, address receiver, address sender, uint reward) returns (bool);
    function confirm() returns (bool);
    function unsubscribe(bytes32 params) returns (bool);
    function() payable;
}

contract SupplyInsure is Insurance {
    address receiver;
    address sender;
    address oracleAddress;
    Oracle oracle;
    uint value;
    uint reward;

    bytes32 params;

    bool delivered;
    bool delayed;
    bool senderConfirmed;
    bool oracleSubscribed;
    bool oracleConfirmed;

    modifier isSender() {if(msg.sender == sender) {_;}}
    modifier validOracle() {if(msg.sender == oracleAddress && oracleConfirmed) {_;}}

    function SupplyInsure(bytes32 _params, address _sender, address _oracle, uint _value, uint _reward) payable {
        require(msg.value >= _value + _reward);
        receiver = msg.sender;
        sender = _sender;
        oracleAddress = oracle;
        //oracle = Oracle(_oracle);
        value = _value;
        reward = _reward;
        params = _params;
        //if (!oracle.subscribe(params, receiver, sender, reward)) {
        //    revert();
        //}     // returns true on success
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
        oracle.unsubscribe(params);
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