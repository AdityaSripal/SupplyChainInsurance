pragma solidity^0.4.13;

contract Insurance {
    function deliver();
    function refund();
}

contract SupplierOracle {
    mapping(address => bool) public clients;
    
    modifier confirmed(address insurance) {if(clients[insurance]) {_;}} 

    event Subscribed(address insurance);
    event Unsubscribed(address insurance);
    event Voted(address insurance);

    function subscribe(bytes32 params, address insurance) returns (bool) {
        clients[insurance] = true;
        SupplyInsure s  = SupplyInsure(insurance);
        s.oracleConfirm();
        Subscribed(insurance);
        return true;
    }

    function unsubscribe(address insurance) returns (bool) {
        delete clients[msg.sender];
        Unsubscribed(insurance);
        return true;
    }

    function confirm() returns (bool) {
        clients[msg.sender] = true;
        return true;
    }

    function delivered(address insurance) 
    confirmed(insurance)
    {
        SupplyInsure s  = SupplyInsure(insurance);
        Voted(insurance);
        s.deliver();
    }

    function refunded(address insurance)
    confirmed(insurance)
    {
        SupplyInsure s  = SupplyInsure(insurance);
        Voted(insurance);
        s.refund();
    }
    
    function() payable {
        return;
    }

    
}