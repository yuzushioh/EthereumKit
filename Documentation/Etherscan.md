## Etherscan Requests

#### `GetTransactions`

Return a list of transactions of specified address

##### Parameters

1. `address` - the Address you want to get a balance of.
2. `sort` - asc or des
3. `startblock` - from which block you want to search
4. `endblock` - to which block you want to search

##### Returns

List of `Transaction` of specified address.

##### Example
        
```swift
let geth = Geth(network: .test)
geth.getTransactions(address: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F", sort: .asc, startBlock: 0, endBlock: 9999999) { result in
    // do something...
}
```