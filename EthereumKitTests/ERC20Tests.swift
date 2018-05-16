import XCTest
@testable import EthereumKit

final class ERC20Tests: XCTestCase {
    func testGenerateTransactionData() {
        let address = "0x88b44BC83add758A3642130619D61682282850Df"
        let data1 = ERC20.generateData(with: address, amount: 3)
        XCTAssertEqual(
            data1.toHexString().addHexPrefix(),
            "0xa9059cbb00000000000000000000000088b44bc83add758a3642130619d61682282850df00000000000000000000000000000000000000000000000029a2241af62c0000"
        )
        
        let data2 = ERC20.generateData(with: address, amount: 0.25)
        XCTAssertEqual(
            data2.toHexString().addHexPrefix(),
            "0xa9059cbb00000000000000000000000088b44bc83add758a3642130619d61682282850df00000000000000000000000000000000000000000000000003782dace9d90000"
        )
        
        let data3 = ERC20.generateData(with: address, amount: 0.155555)
        XCTAssertEqual(
            data3.toHexString().addHexPrefix(),
            "0xa9059cbb00000000000000000000000088b44bc83add758a3642130619d61682282850df0000000000000000000000000000000000000000000000000228a472c6093000"
        )
    }
}
