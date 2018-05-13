# EthereumKit

EthereumKit is a Swift framework that enables you to create Ethereum wallet and use it in your app.

```swift
// BIP39: Generate seed and mnemonic sentence.

let mnemonic = Mnemonic.create()
let seed = Mnemonic.createSeed(mnemonic: mnemonic)

// BIP32: Key derivation and address generation

let wallet: Wallet
do {
    wallet = try Wallet(seed: seed, network: .main)
} catch let error {
    fatalError("Error: \(error.localizedDescription)")
}

// Send some ether
let rawTransaction = RawTransaction(ether: "0.15", to: address, gasPrice: Converter.toWei(GWei: 10), gasLimit: 21000, nonce: 0)
let tx = try wallet.signTransaction(rawTransaction)

geth.sendRawTransaction(rawTransaction: tx) { result in 
    // Do something...
}
```

## Features
- Mnemonic recovery phrease in [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
- [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)/[BIP44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki) HD wallet
- [EIP55](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md) format address encoding
- [EIP155](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md) replay attack protection
- Sign transaction

## Documentations

- [Getting Started](Documentation/GettingStarted.md)
- [JSONRPC API](Documentation/JSONRPC.md)
- [Etherscan API](Documentation/Etherscan.md)

## Requirements

- Swift 4.0 or later
- iOS 10.0 or later

## Installation
#### [Carthage](https://github.com/Carthage/Carthage)

- Insert `github "yuzushioh/EthereumKit"` to your Cartfile.
- Run `carthage update --platform ios`.

## Author

Ryo Fukuda, [@yuzushioh](https://twitter.com/yuzushioh), yuzushioh@gmail.com


## License
EthereumKit is released under the [Apache License 2.0](LICENSE.md).
