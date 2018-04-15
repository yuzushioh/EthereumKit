## JSONRPC Requests

`Geth` in EthereumKit communicates with Ethereum via JSONRPC. It connects to `Ropsten` for test network and `Mainnet` for main network. (Will support localhost soon⚠️)

#### `GetGasPrice`

Returns the current price per gas in wei.

##### Parameters

none

##### Returns

`QUANTITY` - integer of the current gas price in wei.

##### Example
        
```swift
let geth = Geth(network: .test)
geth.getGasPrice() { result in 
    // do something...
}
```

***

#### `GetBalance`

Return a balance of specified address based on the `BlockParameter`.

##### Parameters

1. `address` - the Address you want to get a balance of.
2. `blockParameter`: based on what block parameter you want to see a balance. default is `latest`. see the [default block parameter](#the-default-block-parameter).

##### Returns

`Balance` of specified address.

##### Example
        
```swift
let geth = Geth(network: .test)
geth.getAccount(address: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F") { result in
    // do something...
}
```

***

#### `GetAccount`

Returns a balance of specified address and map it to `Account` model.

##### Parameters

1. `address` - the Address you want to get a balance of.
2. `blockParameter`: based on what block parameter you want to see a balance. default is `latest`. see the [default block parameter](#the-default-block-parameter).

##### Returns

`Account` of specified address.

##### Example
        
```swift
let geth = Geth(network: .test)
geth.getAccount(address: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F") { result in
    // do something...
}
```

***

#### `GetTransactionCount`

Returns a number of transactions that a specified address has.

##### Parameters

1. `address` - the Address you want to get a balance of.
2. `blockParameter`: based on what block parameter you want to see a balance. default is `latest`. see the [default block parameter](#the-default-block-parameter).

##### Returns

A number of transactions the specified address has.

##### Example
        
```swift
let geth = Geth(network: .test)
geth.getTransactionCount(address: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F") { result in
    // do something...
}
```

***

#### `SendRawTransaction`

Creates new message call transaction or a contract creation for signed transactions.

##### Parameters

1. `data` - The signed transaction data.

##### Returns


DATA, 32 Bytes - the transaction hash, or the zero hash if the transaction is not yet available.
Use `GetTransactionReceipt` to get the contract address, after the transaction was mined, when you created a contract.

***

#### `Call`

Executes a new message call immediately without creating a transaction on the block chain.

##### Parameters

1. `from` - (Optional) the Address the transaction is sent from.
2. `to` - the address the transaction is directed to.
3. `gas` - (Optional) integer of the gas provided for the transaction execution.
4. `gasPrice` - (Optional) integer of the gasPrice used for each paid gas.
5. `value` - (Optional) integer of the value send with this transaction.
6. `data` - (Optional) hash of the method signature and encoded parameters.
7. `blockParameter` - integer block number, or the specific string. default is `latest`. see the [default block parameter](#the-default-block-parameter).

##### Returns

`data` - the return value of executed contract.

##### Example
        
```swift
let geth = Geth(network: .test)
geth.call(to: "0xf204a4ef082f5c04bb89f7d5e6568b796096735a", data: "0x70a0823100000000000000000000000091c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F", blockParameter: .latest) { result in
    // do something...
}
```

***

#### `GetEstimatGas`

Generates and returns an estimate of how much gas is necessary to allow the transaction to complete. The transaction will not be added to the blockchain. Note that the estimate may be significantly more than the amount of gas actually used by the transaction, for a variety of reasons including EVM mechanics and node performance.

##### Parameters

1. `from` - (Optional) the Address the transaction is sent from.
2. `to` - the address the transaction is directed to.
3. `gas` - (Optional) integer of the gas provided for the transaction execution.
4. `gasPrice` - (Optional) integer of the gasPrice used for each paid gas.
5. `value` - (Optional) integer of the value send with this transaction.
6. `data` - (Optional) hash of the method signature and encoded parameters.

##### Returns

QUANTITY - the amount of gas used.

##### Example
        
```swift
let geth = Geth(network: .test)
geth.getEstimateGas(to: address) { result in
    // Do something
}
```

***

#### `GetBlockNumber`

Returns the number of most recent block.

##### Parameters

none

##### Returns

QUANTITY - integer of the current block number the client is on.

##### Example

```swift
let geth = Geth(configuration: configuration)
geth.getBlockNumber { result in
// Do something
}
```
