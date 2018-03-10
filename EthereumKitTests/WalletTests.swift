import XCTest
@testable import EthereumKit

class WalletTests: XCTestCase {
    func testWalletAddressGeneration() {
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        
        let wallet = try! Wallet(seed: seed, network: .ropsten)
        let hdWallet = HDWallet(seed: seed, network: .ropsten)
        
        XCTAssertEqual(wallet.generateAddress(), try! hdWallet.generateAddress(at: 0))
        XCTAssertEqual(wallet.dumpPrivateKey(), try! hdWallet.dumpPrivateKey(at: 0))
    }
    
    func testWalletAddressGeneration2() {
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        
        let wallet = try! Wallet(seed: seed, network: .main)
        let hdWallet = HDWallet(seed: seed, network: .main)
        
        XCTAssertEqual(wallet.generateAddress(), try! hdWallet.generateAddress(at: 0))
        XCTAssertEqual(wallet.dumpPrivateKey(), try! hdWallet.dumpPrivateKey(at: 0))
    }
}
