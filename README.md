# SupplyChainInsurance
Blockchain use case for insuring packages on the supply chain

There are two types of smart contracts that make up the insurance marketplace: the oracle contract and the client contract.
This repo houses a simple example of both types.

The client contract understands the oracle interface and can take in as an argument the address of any smart contract that implements this interface.
It also takes in a bytes32 params which will be handed to the oracle to parse and interpret as it needs. This allows for flexibility as one client smart contract can work for multiple different types of oracles.

## SupplyInsure
function SupplyInsure(bytes32 _params, address _sender, address _oracle, uint _value, uint _reward):
_params: any information the oracle might need to function
_sender: address of the sender
_oracle: address of oracle
_value: value to be paid to sender
_reward: reward to be paid to oracle regardless of outcome

The confirm methods can only be called by sender and oracle respectively.

withdraw(): Withdraw can be called by receiver to withdraw their funds if the insurance terms are not confirmed by the oracle or sender.

deliver() and refund(): Can only be called by the oracle. This determines who gets paid.

## SupplierOracle
The Oracle contract will be deployed by an oracle which is also running a server that talks to a logistics API. It can subscribe to multiple clients and call their deliver and refund methods once it has enough information to determine what should happen.

function subscribe(bytes32 params, address insurance):
params: The Oracle is responsible for parsing this for any params it needs to function. If it is not in the format it expects, the oracle reverts any changes and raises exception.
insurance: This is the address of the client

function unsubscribe(bytes32 params): This causes the oracle to unsubscribe from a client's insurance contract. It can use params as it needs to accomplish this.

delivered(address insurance) and refunded(address insurance): Once the oracle subscribes to a particular client, the oracle server will continually poll the logistics database through an API for relevant information about the client's package. Once it gets some new, actionable information it can call either delivered or refunded with the appropriate client address and get paid its fee.

The way the Oracle would accomplish this is by running a geth node on the server. When the server wants to call a method on its Oracle contract it will make a bash shell call to call that method in its contract through its own geth node.

## Future Work:
Allow insurance contracts to employ multiple oracles and have them vote on given outcome, thus reducing trust. This also opens the door for more complex insurance structures (i.e. Delivery time oracle from delivery company, temperature oracle from IOT device, both of which can be involved in the insurance terms).
Rather than having oracle decide on payment, have oracle simply send data to contract and then have the smart contract make the appropriate action. This would make payment process more transparent and trustless.
Allow insurance contracts to have more granular, precise outcomes than just delivered or refunded.
