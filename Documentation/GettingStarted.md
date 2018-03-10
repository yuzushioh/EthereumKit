# Getting started

## Wallet
There are two types of `Wallet` in EthereumKit. One is normal `Wallet` and another is `HDWallet` defined by [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki) and [BIP44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki). Most of the web-based Ethereum wallet service like `Metamask` and `MyEtherWallet` use normal wallet and hardware wallet ike `Trezor` or `LefgerNano` use `HDWallet`. You can choose `HDWallet` for creating a multi-account wallet and `Wallet` for creating single-account wallet.

### Creating a Wallet
You can create wallet by two ways. One is by importing a private key from other wallet and another is by generating private key by seed data. `Mnemonic` class is used for generating a seed data and mnemonic sentence for the back-up.

```swift
// It generates an array of random mnemonic words. Use it for back-ups.
// You can specify which language to use for the sentence by second parameter.
let mnemonic = Mnemonic.create(strength: .normal, language: .english)

// Then generate seed data from the mnemonic sentence.
// You can set password for more secure seed data.
let seed = Mnemonic.createSeed(mnemonic: mnemonic, withPassphrase: "password")

// Create wallet by passing seed data and which network you want to connect.
// for network, EthereumKit currently supports mainnet and ropsten.
let wallet: Wallet
do {
    wallet = try Wallet(seed: seed, network: .main)
} catch let error {
    // Handle error
}

// or 
// You can create wallet just by passing private key.
wallet = Wallet(network: .main, privateKey: "56fa1542efa79a278bf78ba1cf11ef20d961d511d344dc1d4d527bc06eeca667")

// If you want to create HD Wallet, use `HDWallet` with the same parameters.
let hdWallet = HDWallet(seed: seed, network: .main)
```