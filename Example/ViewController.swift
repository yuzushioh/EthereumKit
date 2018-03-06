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
        let mnemonic = "abandon amount liar amount expire adjust cage candy arch gather drum buyer"
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, network: .test)
        print(wallet.generateAddress(at: 0))
        // 0x88b44BC83add758A3642130619D61682282850Df
    }
}
