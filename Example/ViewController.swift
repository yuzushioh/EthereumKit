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
        let wallet = Wallet(seed: seed, network: .main)
        
        let firstAddress = wallet.generateAddress(at: 0)
        print(firstAddress)
        
        let secondAddress = wallet.generateAddress(at: 1)
        print(secondAddress)
        
        let thirdAddress = wallet.generateAddress(at: 2)
        print(thirdAddress)
    }
}
