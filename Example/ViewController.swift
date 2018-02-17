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
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        print(mnemonic)
        // abandon amount liar amount expire adjust cage candy arch gather drum buyer
        
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, network: .test)
        
        let firstAddress = wallet.receiveAddress(at: 0)
        print(firstAddress)
        
        let secondAddress = wallet.receiveAddress(at: 1)
        print(secondAddress)
        
        let thirdAddress = wallet.receiveAddress(at: 2)
        print(thirdAddress)
        
        // PrivateKey: df02cbea58239744a8a6ba328056309ae43f86fec6db45e5f782adcf38aacadf
        // Address: 0x83f1caAdaBeEC2945b73087F803d404F054Cc2B7
        // You can check at MyEtherWallet if the private key actually generates the same address.
        
        let geth = Geth(network: .main)
        geth.getBalance(of: firstAddress) { result in
            switch result {
            case .success(let balance):
                print(balance.wei, balance.ether)
            case .failure(let error):
                print(error)
            }
        }
    }
}
