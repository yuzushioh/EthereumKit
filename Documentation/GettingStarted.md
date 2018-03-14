# Getting started

## Wallet
`Wallet` is responsible for generating and storing private keys and addresses, and signing transactions with private keys. There are two types of `Wallet` in EthereumKit. One is normal `Wallet` and another is `HDWallet` defined by [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki) and [BIP44](https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki).  You can choose `HDWallet` for creating a multi-account wallet and `Wallet` for creating single-account wallet.

### Create Wallet
You can create a wallet by two ways. One is by importing a private key from the other wallet and another is by generating a private key by the seed data. `Mnemonic` class is used for generating a seed data and mnemonic sentence for the back-up.

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

// You can create wallet just by passing teh private key which you want to import.
wallet = Wallet(network: .main, privateKey: "56fa1542efa79a278bf78ba1cf11ef20d961d511d344dc1d4d527bc06eeca667")

// If you want to create HD Wallet, use `HDWallet` with the same parameters.
let hdWallet = HDWallet(seed: seed, network: .main)
```

### Generate Address
You can generate address and store private keys via `Wallet`

```swift
// Generate an address, or private key by simply calling
let address = wallet.generateAddress()
let privateKey = wallet.dumpPrivateKey()

// If you use `HDWallet`, you can specify an index
do {
    let firstAddress = try hdWallet.generateAddress(at: 0)
    let firstPrivateKey = try hdWallet.dumpPrivateKey(at: 0)
} catch let error {
    // Handle error
}
```

## Geth
`Geth` is responsible for interacting with Ethereum network. Geth interacts with network via JSONRPC. You can see the list of JSONRPC requests [here](Documentation/JSONRPC.md).
To create `Configuration` struct for `Geth`, you need 
- url for Ethereum node. you can get one at [infura.io](https://infura.io)
- Etherscan API key. you can get one at [Etherscan](https://etherscan.io)

```swift
// Create an instance of `Geth` with `Configuration`.
// In configuration, specify
// - network: network to use
// - nodeEndpoint: url for the node you want to connect
// - etherscanAPIKey: api key of etherscan

let configuration = Configuration(
    network: .main,
    nodeEndpoint: "https://mainnet.infura.io/z1sEfnzz0LLMsdYMX4PV",
    etherscanAPIKey: "XE7QVJNVMKJT75ATEPY1HPWTPYCVCKMMJ7"
)

let geth = Geth(configuration: configuration)

// To get a balance of an address, call `getBalance`.
geth.getBalance(of: address, blockParameter: .latest) { result in
    // Do something
} 

```

### Get Transactions
To get the list of transactions related to the specified address, `Geth` uses Etherscan API.

```swift
geth.getTransactions(address: address) { result in
    // Do something            
}
```

### Send Ether
You need to create `RawTransaction` with 
- value (how much ether/wei you want to send)
- to (which address you want to send to)
- nonce (currenct nonce)

and send hash by `Geth` via JSONRPC.

```swift
// You can get the current nonce by calling 
geth.getTransactionCount(of: address) { result in
    // Do something
}
```

Then

```swift
let rawTransaction = RawTransaction.create(ether: "0.125", address: address, nonce: nonce)
let tx: String
do {
    tx = try wallet.signTransaction(rawTransaction)
} catch let error {
    // Handle error
}

// It returns the transaction ID.
geth.sendRawTransaction(rawTransaction: tx) { result in
    // Do something
}
```
