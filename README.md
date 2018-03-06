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

- BIP39: Generate seed and mnemonic sentence.

```swift
let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
let mnemonic = Mnemonic.create(entropy: entropy)
let seed = Mnemonic.createSeed(mnemonic: mnemonic)
```

- BIP32: Key derivation and address generation

```swift
// It generates master key pair from the seed provided.
let wallet = Wallet(seed: seed, network: .main)

let firstAddress = wallet.generateAddress(at: 0)
// 0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7

let secondAddress = wallet.generateAddress(at: 1)
// 0xb3c3D923CFc4d551b38Db8A86BbA42B623D063cE

let thirdAddress = wallet.generateAddress(at: 2)
// 0x82e35B34CfBEB9704E51Eb17f8263d919786E66a

```

## Supported JSONRPC APIs

`Geth` in EthereumKit communicates with Ethereum via JSONRPC. It connects to `Ropsten` for test network and `Mainnet` for main network. (Will support localhost soon⚠️)


## Etherscan APIs


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
