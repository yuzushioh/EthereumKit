import XCTest
@testable import EthereumKit

final class ERC20Tests: XCTestCase {
    func testGenerateTransactionData() {
        let address = "0x88b44BC83add758A3642130619D61682282850Df"
        let data1 = try! ERC20.generateData(with: address, amount: "3", decimal: 18)
        XCTAssertEqual(
            data1.toHexString().addHexPrefix(),
            "0xa9059cbb00000000000000000000000088b44bc83add758a3642130619d61682282850df00000000000000000000000000000000000000000000000029a2241af62c0000"
        )
        
        let data2 = try! ERC20.generateData(with: address, amount: "0.25", decimal: 18)
        XCTAssertEqual(
            data2.toHexString().addHexPrefix(),
            "0xa9059cbb00000000000000000000000088b44bc83add758a3642130619d61682282850df00000000000000000000000000000000000000000000000003782dace9d90000"
        )
        
        let data3 = try! ERC20.generateData(with: address, amount: "0.155555", decimal: 18)
        XCTAssertEqual(
            data3.toHexString().addHexPrefix(),
            "0xa9059cbb00000000000000000000000088b44bc83add758a3642130619d61682282850df0000000000000000000000000000000000000000000000000228a472c6093000"
        )
        
        let data4 = try! ERC20.generateData(with: address, amount: "3000", decimal: 18)
        XCTAssertEqual(
            data4.toHexString().addHexPrefix(),
            "0xa9059cbb00000000000000000000000088b44bc83add758a3642130619d61682282850df0000000000000000000000000000000000000000000000a2a15d09519be00000"
        )
        
        let data5 = try! ERC20.generateData(with: address, amount: "9000", decimal: 18)
        XCTAssertEqual(
            data5.toHexString().addHexPrefix(),
            "0xa9059cbb00000000000000000000000088b44bc83add758a3642130619d61682282850df0000000000000000000000000000000000000000000001e7e4171bf4d3a00000"
        )
    }
}
