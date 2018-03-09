import XCTest
@testable import EthereumKit

class GasTests: XCTestCase {
    func testGas() {
        XCTAssertEqual(Gas.limit.value, Gas.GasLimit.normal.value)
        XCTAssertEqual(Gas.price.value, Gas.GasPrice.normal.value)
        
        Gas.setGasLimit(.high)
        Gas.setGasPirce(.high)
        
        XCTAssertEqual(Gas.limit.value, Gas.GasLimit.high.value)
        XCTAssertEqual(Gas.price.value, Gas.GasPrice.high.value)
        
        Gas.setGasLimit(.low)
        Gas.setGasPirce(.custom(GWei: 9))
        
        XCTAssertEqual(Gas.limit.value, Gas.GasLimit.low.value)
        XCTAssertEqual(Gas.price.value, 9)
    }
}
