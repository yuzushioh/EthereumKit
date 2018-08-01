import XCTest
@testable import EthereumKit

class WalletTests: XCTestCase {
    func testWalletAddressGeneration() {
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        let seed = try! Mnemonic.createSeed(mnemonic: mnemonic)
        
        let wallet = try! Wallet(seed: seed, network: .ropsten, debugPrints: false)
        let hdWallet = HDWallet(seed: seed, network: .ropsten)
        
        XCTAssertEqual(wallet.address(), try! hdWallet.address(at: 0))
        XCTAssertEqual(wallet.privateKey().toHexString(), try! hdWallet.privateKey(at: 0))
    }
    
    func testWalletAddressGeneration2() {
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        let seed = try! Mnemonic.createSeed(mnemonic: mnemonic)
        
        let wallet = try! Wallet(seed: seed, network: .mainnet, debugPrints: false)
        let hdWallet = HDWallet(seed: seed, network: .mainnet)
        
        XCTAssertEqual(wallet.address(), try! hdWallet.address(at: 0))
        XCTAssertEqual(wallet.privateKey().toHexString(), try! hdWallet.privateKey(at: 0))
    }
}
