//
//  EthereumKitTests.swift
//  EthereumKitTests
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh.
//

import XCTest
@testable import EthereumKit

class EthereumKitTests: XCTestCase {
    
    func testMenmonic() {
        let mnemonic = Mnemonic.create(entropy: "000102030405060708090a0b0c0d0e0f")
        XCTAssertEqual(
            mnemonic,
            "abandon amount liar amount expire adjust cage candy arch gather drum buyer"
        )
        
        let mnemonic2 = Mnemonic.create(entropy: "a26a4821e36c7f7dccaa5484c080cefa")
        XCTAssertEqual(
            mnemonic2,
            "pen false anchor short side same crawl enhance luggage advice crisp village"
        )
    }
    
    func testSeedGeneration() {
        let mnemonic = Mnemonic.create(entropy: "000102030405060708090a0b0c0d0e0f")
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        XCTAssertEqual(
            seed.toHexString(),
            "3779b041fab425e9c0fd55846b2a03e9a388fb12784067bd8ebdb464c2574a05bcc7a8eb54d7b2a2c8420ff60f630722ea5132d28605dbc996c8ca7d7a8311c0"
        )
        
        let mnemonic2 = Mnemonic.create(entropy: "a26a4821e36c7f7dccaa5484c080cefa")
        let seed2 = Mnemonic.createSeed(mnemonic: mnemonic2)
        print(seed2.toHexString())
        XCTAssertEqual(
            seed2.toHexString(),
            "2bb2ea75d2891584559506b2429426722bfa81958c824affb84b37def230fe94a7da1701d550fef6a216176de786150d0a4f2b7b3770139582c1c01a6958d91a"
        )
    }
    
    func testChildKeyDerivation() {
        let mnemonic = Mnemonic.create(entropy: "000102030405060708090a0b0c0d0e0f")
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
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
        XCTAssertEqual(
            firstPrivateKey.publicKey.address,
            "0x479c04427c15e84ffd2cbdee136c5a979a08a749"
        )
        
        XCTAssertEqual(
            firstPrivateKey.raw.toHexString(),
            "ee08ee9b92c8d4cc48f3690c55f70a9974e325a7c228b98ec58dcff8e6d14d66"
        )
    }
}
