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
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        
        // Then generate seed data from the mnemonic sentence.
        // You can set password for more secure seed data.
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        
        // Create wallet by passing seed data and which network you want to connect.
        // for network, EthereumKit currently supports mainnet and ropsten.
        let wallet: Wallet
        do {
            wallet = try Wallet(seed: seed, network: .ropsten)
        } catch let error {
            fatalError("Error: \(error.localizedDescription)")
        }
        
        // Generate an address, or private key by simply calling
        let address = wallet.generateAddress()
        let privateKey = wallet.dumpPrivateKey()
        print(address, privateKey)
        
        // Create an instance of `Geth` with `Configuration`.
        // In configuration, specify
        // - network: network to use
        // - nodeEndpoint: url for the node you want to connect
        // - etherscanAPIKey: api key of etherscan
        
        let configuration = Configuration(
            network: .ropsten,
            nodeEndpoint: "https://ropsten.infura.io/z1sEfnzz0LLMsdYMX4PV",
            etherscanAPIKey: "XE7QVJNVMKJT75ATEPY1HPWTPYCVCKMMJ7"
        )
        
        let geth = Geth(configuration: configuration)
        
        // To get a balance of an address, call `getBalance`.
        geth.getBalance(of: address) { result in
            print(result)
        }
        
        // You can get the current nonce by calling
        geth.getTransactionCount(of: address) { result in
            print(result)
            switch result {
            case .success(let nonce):
                let rawTransaction = RawTransaction(ether: "0.0001", to: address, gasPrice: Converter.toWei(GWei: 10), gasLimit: 21000, nonce: nonce)
                let tx: String
                do {
                    tx = try wallet.sign(rawTransaction: rawTransaction)
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
        
        geth.getTransactions(address: address) { print($0) }
    }
}
