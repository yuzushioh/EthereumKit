## JSONRPC Requests

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