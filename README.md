<p align="center">
    <img src="https://user-images.githubusercontent.com/12425729/40763856-5f14764a-64e1-11e8-8684-2f1c8497abd5.png" alt="EthereumKit" height="300px">
</p>

EthereumKit is a Swift framework that enables you to create Ethereum wallet and use it in your app.

```swift
// BIP39: Generate seed and mnemonic sentence.

let mnemonic = Mnemonic.create()
let seed = Mnemonic.createSeed(mnemonic: mnemonic)

// BIP32: Key derivation and address generation

let wallet = try! Wallet(seed: seed, network: .main)

// Send some ether

let rawTransaction = RawTransaction(
    ether: try! Converter.toWei(ether: "0.00001"), 
    to: address, 
    gasPrice: Converter.toWei(GWei: 10), 
    gasLimit: 21000, 
    nonce: 0
)

let tx = try! wallet.signTransaction(rawTransaction)
geth.sendRawTransaction(rawTransaction: tx) { result in 
    // Do something...
}
```

## Set up

- Run `make bootstrap`

## Features
- Mnemonic recovery phrease in [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
- [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)/[BIP44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki) HD wallet
- [EIP55](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md) format address encoding
- [EIP155](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md) replay attack protection
- Sign transaction
- ERC20 token transfer

## Documentations

- [Getting Started](Documentation/GettingStarted.md)
- [ERC20 Token](Documentation/ERC20.md)
- [JSONRPC API](Documentation/JSONRPC.md)
- [Etherscan API](Documentation/Etherscan.md)

## Requirements

- Swift 4.0 or later
- iOS 9.0 or later

## Installation
#### [Carthage](https://github.com/Carthage/Carthage)

- Insert `github "yuzushioh/EthereumKit"` to your Cartfile.
- Run `carthage update --platform ios`.

## Dependency

- [CryptoEthereumSwift](https://github.com/yuzushioh/CryptoEthereumSwift): Ethereum cryptography implementations for iOS framework

## Apps using EthereumKit

- [gnosis/safe-ios](https://github.com/gnosis/safe-ios): Gnosis Safe is a multi signature (2FA) wallet for personal usage.
- [popshootjapan/WeiWallet-iOS](https://github.com/popshootjapan/WeiWallet-iOS): Wei Wallet for iOS
## Author

Ryo Fukuda, [@yuzushioh](https://twitter.com/yuzushioh), yuzushioh@gmail.com


## License
EthereumKit is released under the [Apache License 2.0](LICENSE.md).
