import XCTest
@testable import EthereumKit

final class NetworkTests: XCTestCase {
    
    func testMainnet() {
        let network = Network.main
        XCTAssert(network.chainID == 1)
        XCTAssert(network.coinType == 60)
        XCTAssert(network.privateKeyPrefix == 0x0488ade4)
        XCTAssert(network.publicKeyPrefix == 0x0488b21e)
    }
    
    func testRopsten() {
        let network = Network.ropsten
        XCTAssert(network.chainID == 3)
        XCTAssert(network.coinType == 1)
        XCTAssert(network.privateKeyPrefix == 0x04358394)
        XCTAssert(network.publicKeyPrefix == 0x043587cf)
    }
    
    func testKovan() {
        let network = Network.kovan
        XCTAssert(network.chainID == 42)
        XCTAssert(network.coinType == 1)
        XCTAssert(network.privateKeyPrefix == 0x04358394)
        XCTAssert(network.publicKeyPrefix == 0x043587cf)
    }
    
    func testPrivateNetTestUse() {
        let network = Network.private(chainID: 100, testUse: true)
        XCTAssert(network.chainID == 100)
        XCTAssert(network.coinType == 1)
        XCTAssert(network.privateKeyPrefix == 0x04358394)
        XCTAssert(network.publicKeyPrefix == 0x043587cf)
    }
    
    func testPrivateNet() {
        let network = Network.private(chainID: 100, testUse: false)
        XCTAssert(network.chainID == 100)
        XCTAssert(network.coinType == 60)
        XCTAssert(network.privateKeyPrefix == 0x0488ade4)
        XCTAssert(network.publicKeyPrefix == 0x0488b21e)
    }
}
