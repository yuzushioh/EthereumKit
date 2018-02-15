# EthereumKit

EthereumKit is a Swift framework that enables you to create Ethereum wallet and use it in your app.

🚨 __EthereumKit is currently under development. not ready for the production use__ 🚨

## Features
- Mnemonic recovery phrease in [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
- [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)/[BIP44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki) HD wallet
- [EIP55](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md) format address encoding

## How to Use

- Generate seed and convert it to mnemonic sentence.

```swift
let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
let mnemonic = Mnemonic.create(entropy: entropy)
print(mnemonic)
// abandon amount liar amount expire adjust cage candy arch gather drum buyer

let seed = Mnemonic.createSeed(mnemonic: mnemonic)
print(seed.toHexString())
```

- PrivateKey and key derivation (BIP32)

```swift
let masterPrivateKey = PrivateKey(seed: seed, network: .main)

// m/44'
let purpose = masterPrivateKey.derived(at: 44, hardens: true)

// m/44'/60'
let coinType = purpose.derived(at: 60, hardens: true)

// m/44'/60'/0'
let account = coinType.derived(at: 0, hardens: true)

// m/44'/60'/0'/0
let change = account.derived(at: 0)

// m/44'/60'/0'/0
let firstPrivateKey = change.derived(at: 0)
print(firstPrivateKey.publicKey.address)
```


- Create your wallet and generate addresse

```swift
// It generates master key pair from the seed provided.
let wallet = Wallet(seed: seed, network: .main)

let firstAddress = wallet.receiveAddress(at: 0)
// 0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7

let secondAddress = wallet.receiveAddress(at: 1)
// 0xb3c3D923CFc4d551b38Db8A86BbA42B623D063cE

let thirdAddress = wallet.receiveAddress(at: 2)
// 0x82e35B34CfBEB9704E51Eb17f8263d919786E66a

```

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
