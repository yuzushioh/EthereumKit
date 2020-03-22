import XCTest
@testable import EthereumKit

final class NetworkTests: XCTestCase {
    
    func testMainnet() {
        let network = Network.mainnet
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
    
    func testRinkeby() {
        let network = Network.rinkeby
        XCTAssert(network.chainID == 4)
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
    
    func testNetworkInitializer() {
        let mainNetwork = Network(name: "main")
        XCTAssertNotNil(mainNetwork)
        XCTAssertEqual(mainNetwork, Network.mainnet)
        
        let ropstenNetwork = Network(name: "ropsten")
        XCTAssertNotNil(ropstenNetwork)
        XCTAssertEqual(ropstenNetwork, Network.ropsten)
        
        let kovanNetwork = Network(name: "kovan")
        XCTAssertNotNil(kovanNetwork)
        XCTAssertEqual(kovanNetwork, Network.kovan)
        
        let rinkebyNetwork = Network(name: "rinkeby")
        XCTAssertNotNil(rinkebyNetwork)
        XCTAssertEqual(rinkebyNetwork, Network.rinkeby)
        
        let privateNetwork = Network(name: "private", chainID: 1, testUse: false)
        XCTAssertNotNil(privateNetwork)
        XCTAssertEqual(privateNetwork, Network.private(chainID: 1, testUse: false))
    }
}
