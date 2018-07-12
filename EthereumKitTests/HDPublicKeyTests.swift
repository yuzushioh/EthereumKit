import XCTest
@testable import EthereumKit

final class HDPublicKeyTests: XCTestCase {
    
    private var testnetMasterPrivateKey: HDPrivateKey = {
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        let seed = try! Mnemonic.createSeed(mnemonic: mnemonic)
        return HDPrivateKey(seed: seed, network: .ropsten)
    }()
    
    private var mainnetMasterPrivateKey: HDPrivateKey = {
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        let seed = try! Mnemonic.createSeed(mnemonic: mnemonic)
        return HDPrivateKey(seed: seed, network: .mainnet)
    }()
    
    // BIP32 path m/44'/1'/0'/0
    func testHDExtendedPublicKey() {
        let firstTestnetPrivateKey = try! testnetMasterPrivateKey
            .derived(at: 44, hardens: true)
            .derived(at: 1, hardens: true)
            .derived(at: 0, hardens: true)
            .derived(at: 0)
        
        XCTAssertEqual(
            firstTestnetPrivateKey.hdPublicKey().extended(),
            "tpubDDzu8jH1jdLrqX6gm5JcLhM8ejbLSL5nAEu44Uh9HFCLU1t6V5mwro6NxAXCfR2jUJ9vkYkUazKXQSU7WAaA9cbEkxdWmbLxHQnWqLyQ6uR"
        )
        
        let firstMainnetPrivateKey = try! mainnetMasterPrivateKey
            .derived(at: 44, hardens: true)
            .derived(at: 60, hardens: true)
            .derived(at: 0, hardens: true)
            .derived(at: 0)
        
        XCTAssertEqual(
            firstMainnetPrivateKey.hdPublicKey().extended(),
            "xpub6DYRboj7N9BhmRLri5G3QdMGiRYeFNgD6gXx1XuYKV3zZ15YG3sgeqVumtWjhemR3P7x9vmLe9CBKtbVkGH5LK4VxUyaQcuLNJrvdEx5MsU"
        )
    }
}
