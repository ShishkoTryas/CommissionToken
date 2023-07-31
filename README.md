**Smart Contract Readme**

# Token Smart Contract with UniSwap Transaction Fee Distribution

This repository contains a smart contract written in Solidity for a custom token that incorporates a transaction fee distribution mechanism when buying or selling tokens using UniSwap. The contract will allocate a 4% commission on each transaction, distributing it as follows:

- 3% of the transaction fee will be sent to the project wallet.
- 1% of the transaction fee will be distributed among all token holders.

## Requirements

To interact with this smart contract, you will need:

1. An Ethereum wallet (such as MetaMask) to interact with the contract on the Ethereum network.
2. Some Ether (ETH) to pay for gas fees associated with transactions on the Ethereum network.

## Contract Details

The smart contract has the following functionalities:

1. Token Creation: The contract will deploy a custom ERC-20 token with the following properties:
    - Name: [Token Name]
    - Symbol: [Token Symbol]
    - Total Supply: [Total Supply]
    - Decimals: [Decimals]

2. Transaction Fee Distribution: The contract will charge a 4% commission on all token transactions (buying and selling) made using UniSwap. The commission will be split as follows:
    - 3% will be sent to the project wallet with the address
    - 1% will be distributed among all token holders proportionally.

3. UniSwap Integration: The smart contract will utilize the UniSwap protocol to facilitate token trading. Ensure that the contract has the necessary interface to interact with UniSwap.