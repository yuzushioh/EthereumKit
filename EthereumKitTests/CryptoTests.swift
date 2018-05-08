import XCTest
@testable import EthereumKit

class CryptoTests: XCTestCase {
    func testValidatesSignature() {
        assertValidatesSignature(compressed: true)
        assertValidatesSignature(compressed: false)
    }
}

extension CryptoTests {
    private func privateKey() -> HDPrivateKey {
        let words = Mnemonic.create()
        let seed = Mnemonic.createSeed(mnemonic: words)
        return HDPrivateKey(seed: seed, network: .main)
    }

    private func assertValidatesSignature(compressed: Bool, line: UInt = #line) {
        let hash = Crypto.hashSHA3_256("Secret".data(using: .utf8)!)
        let otherHash = Crypto.hashSHA3_256("0123456789".data(using: .utf8)!)

        let privateKey = self.privateKey().raw
        let publicKey = Crypto.generatePublicKey(data: privateKey, compressed: compressed)

        let otherKey = self.privateKey().raw
        let otherPublicKey = Crypto.generatePublicKey(data: otherKey, compressed: compressed)

        do {
            let signature = try Crypto.sign(hash, privateKey: privateKey)
            let otherSignature = try Crypto.sign(hash, privateKey: otherKey)

            XCTAssertEqual(publicKey, Crypto.publicKey(signature: signature, of: hash, compressed: compressed), line: line)
            XCTAssertTrue(Crypto.isValid(signature: signature, of: hash, publicKey: publicKey, compressed: compressed), line: line)
            XCTAssertFalse(Crypto.isValid(signature: signature, of: hash, publicKey: otherPublicKey, compressed: compressed), line: line)
            XCTAssertFalse(Crypto.isValid(signature: otherSignature, of: hash, publicKey: publicKey, compressed: compressed), line: line)
            XCTAssertFalse(Crypto.isValid(signature: signature, of: otherHash, publicKey: publicKey, compressed: compressed), line: line)
        } catch let e {
            XCTFail("Error signing data: \(e)")
        }
    }
}
