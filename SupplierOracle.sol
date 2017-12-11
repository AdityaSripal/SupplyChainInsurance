pragma solidity^0.4.13;

contract SupplyInsure {
    function deliver();
    function refund();
}

contract Oracle {
    function subscribe(bytes32 params, address receiver, address sender, uint reward) returns (bool);
    function confirm() returns (bool);
    function unsubscribe(bytes32 params) returns (bool);
    function() payable;
}

contract SupplierOracle {
    struct Client {
        bytes32 params;
        SupplyInsure terms;
        bool confirmed;
    }

    mapping(address => Client) clients;

    function subscribe(bytes32 params, address insurance) returns (bool) {
        clients[insurance] = Client(params, SupplyInsure(insurance), false);
        return true;
    }

    function unsubscribe(bytes32 params) returns (bool) {
        delete clients[msg.sender]; //not sure how to remove key-val pair?
        return true;
    }

    function confirm() returns (bool) {
        clients[msg.sender].confirmed = true;
        return true;
    }

    function delivered(address insurance) {
        clients[insurance].terms.deliver();
    }

    function refunded(address insurance) {
        clients[insurance].terms.refund();
    }
    
    function() payable {
        return;
    }

    
}