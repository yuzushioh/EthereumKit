//
//  EthereumKitTests.swift
//  EthereumKitTests
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import XCTest
@testable import EthereumKit

class EthereumKitTests: XCTestCase {
    
    private var mnemonicManager: MnemonicManager!
    
    override func setUp() {
        super.setUp()
        mnemonicManager = MnemonicManager(wordList: .english)
    }
    
    func testMnemonicManagerCreateMnemonicSentence() {
        let resultA = check(
            mnemonic: "abandon amount liar amount expire adjust cage candy arch gather drum buyer",
            isEqualToOneCreatedFromEntropy: "000102030405060708090a0b0c0d0e0f"
        )
        XCTAssertTrue(resultA)
        
        let resultB = check(
            mnemonic: "swallow abandon ability search abandon abandon abandon able absurd abandon action bench",
            isEqualToOneCreatedFromEntropy: "DBK3hoIaE1Zdmx/kq/Yu2v1RJ8n3aLAP"
        )
        XCTAssertTrue(resultB)
    }
    
    func check(mnemonic: String, isEqualToOneCreatedFromEntropy entropy: String) -> Bool {
        return mnemonicManager.createMnemonic(fromEntropyString: entropy) == mnemonic
    }
}
