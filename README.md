# SupplyChainInsurance
Blockchain use case for insuring packages on the supply chain

There are two types of smart contracts that make up the insurance marketplace: the oracle contract and the client contract.
This repo houses a simple example of both types.

The client contract understands the oracle interface and can take in as an argument the address of any smart contract that implements this interface.
It also takes in a bytes32 params which will be handed to the oracle to parse and interpret as it needs. This allows for flexibility as one client smart contract can work for multiple different types of oracles.
The value parameter is how much the receiver is willing to pay the sender while the reward parameter is the fee to the oracle.

The only other methods left are deliver and refund.
