import XCTest
@testable import EthereumKit

final class TransactionTests: XCTestCase {
    
    func testTransaction() {
        let transaction = Transaction(
            blockHash: "hash",
            blockNumber: "100",
            hash: "hashhash",
            input: "aaa",
            confirmations: "10",
            nonce: "1",
            timeStamp: "100000000000",
            contractAddress: "0x88b44BC83add758A3642130619D61682282850Df",
            from: "0x88b44BC83add758A3642130619D61682282850Df",
            to: "0x88b44BC83add758A3642130619D61682282850Df",
            gas: "100",
            gasPrice: "10",
            gasUsed: "300",
            cumulativeGasUsed: "200",
            isError: "",
            transactionIndex: "800",
            txReceiptStatus: "status",
            value: "1000000000000000000"
        )
        
        XCTAssertEqual(transaction.blockHash, "hash")
        XCTAssertEqual(transaction.blockNumber, "100")
        XCTAssertEqual(transaction.hash, "hashhash")
        XCTAssertEqual(transaction.input, "aaa")
        XCTAssertEqual(transaction.confirmations, "10")
        XCTAssertEqual(transaction.nonce, "1")
        XCTAssertEqual(transaction.timeStamp, "100000000000")
        XCTAssertEqual(transaction.contractAddress, "0x88b44BC83add758A3642130619D61682282850Df")
        XCTAssertEqual(transaction.from, "0x88b44BC83add758A3642130619D61682282850Df")
        XCTAssertEqual(transaction.to, "0x88b44BC83add758A3642130619D61682282850Df")
        XCTAssertEqual(transaction.gas, "100")
        XCTAssertEqual(transaction.gasPrice, "10")
        XCTAssertEqual(transaction.gasUsed, "300")
        XCTAssertEqual(transaction.cumulativeGasUsed, "200")
        XCTAssertEqual(transaction.isError, "")
        XCTAssertEqual(transaction.transactionIndex, "800")
        XCTAssertEqual(transaction.txReceiptStatus, "status")
        XCTAssertEqual(transaction.value, "1000000000000000000")
        
        XCTAssertEqual(transaction.balance.wei, Wei("1000000000000000000")!)
        XCTAssertNoThrow(try transaction.balance.ether())
    }
}
