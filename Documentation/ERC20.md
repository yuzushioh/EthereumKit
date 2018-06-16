# ERC20 Token

## Transfer

* Create an instance of an ERC20 token

```swift
let erc20Token = ERC20(contractAddress: "0xd26114cd6EE289AccF82350c8d8487fedB8A0C07", decimal: 18, symbol: "OMG")
```

* Create a data parameter which will be sent with `RawTransaction` data section

**Put contract address to `RawTransaction` `to` parameter**

```swift
let parameterData: Data
do {
    parameterData = try erc20Token.generateDataParameter(toAddress: "0x88b44BC83add758A3642130619D61682282850Df", amount: "100")
} catch let error {
    fatalError("Error: \(error.localizedDescription)")
}

let rawTransaction = RawTransaction(
    wei: "0",
    to: erc20Token.contractAddress,
    gasPrice: Converter.toWei(GWei: 10),
    gasLimit: 21000,
    nonce: 10,
    data: parameterData
)
```

* Sign tx and send a parameter data with `sendRawTransaction` RPC

```swift        

let tx: String
do {
    tx = try wallet.sign(rawTransaction: rawTransaction)
} catch let error {
    fatalError("Error: \(error.localizedDescription)")
}

geth.sendRawTransaction(rawTransaction: tx) { result in
    // do something with response
}
```