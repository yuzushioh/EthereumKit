//
//  EthereumKitTests.swift
//  EthereumKitTests
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh.
//

import XCTest
import CryptoSwift
@testable import EthereumKit

class EthereumKitTests: XCTestCase {
    func testMenmonic() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        XCTAssertEqual(
            mnemonic,
            "abandon amount liar amount expire adjust cage candy arch gather drum bulk"
        )
        
        let entropy2 = Data(hex: "a26a4821e36c7f7dccaa5484c080cefa")
        let mnemonic2 = Mnemonic.create(entropy: entropy2)
        XCTAssertEqual(
            mnemonic2,
            "pen false anchor short side same crawl enhance luggage advice crisp village"
        )
    }
    
    func testSeedGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        XCTAssertEqual(
            seed.toHexString(),
            "4425453cdece7f75f8c106ba123a617d6f8059fbab0deeee6f29c40f989fa249a0785261361a0768a01da79d35ef21975d94398ab5bf4b62bd2f424a8cad329a"
        )
        
        let entropy2 = Data(hex: "a26a4821e36c7f7dccaa5484c080cefa")
        let mnemonic2 = Mnemonic.create(entropy: entropy2)
        let seed2 = Mnemonic.createSeed(mnemonic: mnemonic2)
        XCTAssertEqual(
            seed2.toHexString(),
            "2bb2ea75d2891584559506b2429426722bfa81958c824affb84b37def230fe94a7da1701d550fef6a216176de786150d0a4f2b7b3770139582c1c01a6958d91a"
        )
    }
    
    func testChildKeyDerivation() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
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
            "0x9dc0062feefaf332276a2c35a8fb8f8561f038c7"
        )
        
        XCTAssertEqual(
            firstPrivateKey.raw.toHexString(),
            "b0104cb67b4f8eb19878ab878307d83afa51afb09e9ba0e099dc3e23667a3b87"
        )
    }
}
