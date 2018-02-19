# EthereumKit

EthereumKit is a Swift framework that enables you to create Ethereum wallet and use it in your app.

🚨 __EthereumKit is currently under development. not ready for the production use__ 🚨

## Features
- Mnemonic recovery phrease in [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
- [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)/[BIP44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki) HD wallet
- [EIP55](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md) format address encoding
- See currency balance of an address.

## How to Use

### Wallet

- BIP39: Generate seed and mnemonic sentence.

```swift
let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
let mnemonic = Mnemonic.create(entropy: entropy)
print(mnemonic)
// abandon amount liar amount expire adjust cage candy arch gather drum buyer

let seed = Mnemonic.createSeed(mnemonic: mnemonic)
print(seed.toHexString())
```

- BIP32: PrivateKey and key derivation.

```swift
// m/44'/60'/0'/0
let masterPrivateKey = PrivateKey(seed: seed, network: .main)
let purpose = masterPrivateKey.derived(at: 44, hardens: true)
let coinType = purpose.derived(at: 60, hardens: true)
let account = coinType.derived(at: 0, hardens: true)
let change = account.derived(at: 0)

// m/44'/60'/0'/0/0
let privateKey = change.derived(at: 0)
```

- Create your wallet and generate addresse.

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

- See a currenct balance of address.

```swift
let geth = Geth(network: .test)
geth.getBalance(address: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F") { result in
    // do something with `Balance`.
}
```


## Supported JSONRPC APIs

`Geth` in EthereumKit communicates with Ethereum via JSONRPC. It connects to `Ropsten` for test network and `Mainnet` for main network. (Will support localhost⚠️)

***

##### `GetBalance`

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

##### `GetAccount`

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
