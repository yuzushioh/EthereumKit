import XCTest
@testable import EthereumKit

final class MnemonicTests: XCTestCase {
    
    func testMnemonicWords1() {
        let mnemonic = "abandon amount liar amount expire adjust cage candy arch gather drum buyer"
            .split(separator: " ")
            .map(String.init)
        
        let seed = try! Mnemonic.createSeed(mnemonic: mnemonic)
        XCTAssertEqual(
            seed.toHexString(),
            "3779b041fab425e9c0fd55846b2a03e9a388fb12784067bd8ebdb464c2574a05bcc7a8eb54d7b2a2c8420ff60f630722ea5132d28605dbc996c8ca7d7a8311c0"
        )
    }
    
    func testMnemonicWords2() {
        let mnemonic = "さうな そもそも ほっきょく あらし ろじうら うこん ごうまん せっこつ さいかい にんしき せぼね とっきゅう"
            .split(separator: " ")
            .map(String.init)
        
        let seed = try! Mnemonic.createSeed(mnemonic: mnemonic)
        XCTAssertEqual(
            seed.toHexString(),
            "d90a7a0659f50d81f7a3b0faf4cba84dc8a286e5b84f4f7b81ca118b024c25094f5bc52482bf25a95170d84c41ccbeb9e5d51c6905a87168200c672fcd8880b8"
        )
    }
    
    func testMnemonicWordsWhenInvalid() {
        let mnemonic = "bug amount liar amount expire adjust cage candy arch gather drum buyer"
            .split(separator: " ")
            .map(String.init)
        
        XCTAssertThrowsError(try Mnemonic.createSeed(mnemonic: mnemonic))
    }
    
    func testMnemonicWordsWhenInvalid2() {
        let mnemonic = "あ amount liar amount expire adjust cage candy arch gather drum buyer"
            .split(separator: " ")
            .map(String.init)
        
        XCTAssertThrowsError(try Mnemonic.createSeed(mnemonic: mnemonic))
    }
    
    func testMnemonicWordsWhenInvalid3() {
        let mnemonic = "あ い う え お か き く け こ さ し"
            .split(separator: " ")
            .map(String.init)
        
        XCTAssertThrowsError(try Mnemonic.createSeed(mnemonic: mnemonic))
    }
}
