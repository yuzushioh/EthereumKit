import XCTest
import CryptoSwift
@testable import EthereumKit

final class MessageSigningTests: XCTestCase {
    
    private let wallet = Wallet(network: .ropsten, privateKey: "d0d3ae306602070917c456b61d88bee9dc74edb5853bb87b1c13e5bfa2c3d0d9")
    
    func testMessageSigning() {
        XCTAssertEqual(
            try! wallet.sign(message: "Ethereum"),
            "0x0ec487cc67649c87f6ef059d21079c6e3023cd6b31b1e9b6ac82d1bff53f67e63a811b3e70f52459897b0bc03e5cdb3d482c982b2d4a4f68f17fd35c973473521c"
        )
        
        XCTAssertEqual(
            try! wallet.sign(message: "Bitcoin"),
            "0xe3f0a3588aae404b6096e91b412387b7d9c775482fa5f980cc0f96cc11d37a00259f44bb4c38193b01b5179cd5a5a032be9a0143df9bd070f12416f09b05bab21c"
        )
        
        XCTAssertEqual(
            try! wallet.sign(message: "hello world!"),
            "0xbf573bdc43a9d0f19e9035896609527cd0c8bf753b139c3f25c72751e5e0476243258d1945b952a2b7282d4e09ebe90ae1c0948325f1262262e4ee31bb5cd6851c"
        )
        
        XCTAssertEqual(
            try! wallet.sign(message: "LLVM Profile Error Failed to write file default profraw Permission denie"),
            "0xf6d4779fe9cfd6217c65d8f65b583004f38787fc3faa3eb8f2683fe8d8c555844c83ddaaa82e09f23c822e6927d4987d140cfa3c8a4bb230007daaf438efe8401b"
        )
        
        XCTAssertEqual(
            try! wallet.sign(hex: "0x57656c636f6d6520746f205765692077616c6c657421"),
            "0x1cdd3bc8ac888bb608d1951e803d6b255a8500dd857a2dee2b02dfd98df3a0df2db1c3199a86be6bfdd60a8c2182b70df76026dc1278f9dab3268bbc04fa660a1c"
        )
        
        XCTAssertEqual(
            try! wallet.sign(hex: "0x4d6573736167655369676e696e675465737473"),
            "0xeb2cd3bc3d704d4206f84e604b7c8fc20f7ed54eb5784c79d70e99993c7b6e6251d36e95b764a65f64a1f992e75e79f6fc750743a17fa6d508ac5d5f0b1e3df81c"
        )
    }
}
