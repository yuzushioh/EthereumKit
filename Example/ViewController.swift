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
        print(seed)
        // 3779b041fab425e9c0fd55846b2a03e9a388fb12784067bd8ebdb464c2574a05bcc7a8eb54d7b2a2c8420ff60f630722ea5132d28605dbc996c8ca7d7a8311c0
        
        let wallet = Wallet(seed: seed, network: .main)
        
        // BIP44 key derivation
        // m/44'
        let purpose = wallet.privateKey.derived(at: 44, hardens: true)
        
        // m/44'/60'
        let coinType = purpose.derived(at: 60, hardens: true)
        
        // m/44'/60'/0'
        let account = coinType.derived(at: 0, hardens: true)
        
        // m/44'/60'/0'/0
        let change = account.derived(at: 0)
        
        // m/44'/60'/0'/0
        let firstPrivateKey = change.derived(at: 0)
        print(firstPrivateKey.publicKey.address, firstPrivateKey.raw.toHexString())
        
        // PrivateKey: ee08ee9b92c8d4cc48f3690c55f70a9974e325a7c228b98ec58dcff8e6d14d66
        // Address: 0x479c04427c15e84ffd2cbdee136c5a979a08a749
        // You can check at MyEtherWallet if the private key actually generates the same address.
    }
}
