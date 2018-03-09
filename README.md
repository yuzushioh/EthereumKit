# EthereumKit

EthereumKit is a Swift framework that enables you to create Ethereum wallet and use it in your app.

## Features
- Mnemonic recovery phrease in [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
- [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)/[BIP44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki) HD wallet
- [EIP55](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md) format address encoding
- [EIP155](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md) replay attack protection
- Sign transaction

## How to Use

### Wallet

```swift
// BIP39: Generate seed and mnemonic sentence.
let mnemonic = Mnemonic.create()
let seed = Mnemonic.createSeed(mnemonic: mnemonic)

// BIP32: Key derivation and address generation
let wallet = Wallet(seed: seed, network: .main)
let address = wallet.generateAddress(at: 0)
```

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

## Made possible by
- [BitcoinKit](https://github.com/kishikawakatsumi/BitcoinKit)
- [BitcoinCore](https://github.com/oleganza/CoreBitcoin)
- [openssl](https://github.com/openssl/openssl)

## License
EthereumKit is released under the [MIT License](LICENSE.md).
