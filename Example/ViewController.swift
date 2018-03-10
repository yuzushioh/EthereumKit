//
//  ViewController.swift
//  Example
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import UIKit
import EthereumKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            fatalError("Error: \(error.localizedDescription)")
        }
        
        // or
        
        // You can create wallet just by passing teh private key which you want to import.
        // wallet = Wallet(network: .main, privateKey: "56fa1542efa79a278bf78ba1cf11ef20d961d511d344dc1d4d527bc06eeca667")
        
        // If you want to create HD Wallet, use `HDWallet` with the same parameters.
        let hdWallet = HDWallet(seed: seed, network: .main)
        
        // Generate an address, or private key by simply calling
        let address = wallet.generateAddress()
        let privateKey = wallet.dumpPrivateKey()
        print(address, privateKey)
        
        // If you use `HDWallet`, you can specify an index
        do {
            let firstAddress = try hdWallet.generateAddress(at: 0)
            let firstPrivateKey = try hdWallet.dumpPrivateKey(at: 0)
            print(firstAddress, firstPrivateKey)
        } catch let error {
            fatalError("Error: \(error.localizedDescription)")
        }
        
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
        
        // You can get the current nonce by calling
        geth.getTransactionCount(of: address) { result in
            switch result {
            case .success(let nonce):
                let rawTransaction = RawTransaction.create(ether: "0.0001", address: address, nonce: nonce)
                let tx: String
                do {
                    tx = try wallet.signTransaction(rawTransaction)
                } catch let error {
                    fatalError("Error: \(error.localizedDescription)")
                }
                
                // It returns the transaction ID.
                geth.sendRawTransaction(rawTransaction: tx) { result in
                    print(result)
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
