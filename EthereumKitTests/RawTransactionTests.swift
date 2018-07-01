import XCTest
@testable import EthereumKit

final class RawTransactionTests: XCTestCase {
    
    func testRawTransaction() {
        let rawTransaction = RawTransaction(
            value: Wei(100),
            to: Address(string: "0x88b44BC83add758A3642130619D61682282850Df"),
            gasPrice: 10,
            gasLimit: 100,
            nonce: 1,
            data: Data()
        )
        
        XCTAssertEqual(rawTransaction.value, Wei(100))
        XCTAssertEqual(rawTransaction.to.string, "0x88b44BC83add758A3642130619D61682282850Df")
        XCTAssertEqual(rawTransaction.gasPrice, 10)
        XCTAssertEqual(rawTransaction.gasLimit, 100)
        XCTAssertEqual(rawTransaction.nonce, 1)
        XCTAssertEqual(rawTransaction.data, Data())
    }
}
