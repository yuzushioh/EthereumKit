import XCTest
@testable import EthereumKit

final class BalanceTests: XCTestCase {
    
    func testBalanceModel() {
        let balance = Balance(wei: Wei(100))
        XCTAssertEqual(balance.wei, Wei(100))
        XCTAssertNoThrow(try balance.ether(), "Convert will success")
    }
}
