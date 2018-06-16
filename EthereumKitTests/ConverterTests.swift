import XCTest
@testable import EthereumKit

class ConverterTests: XCTestCase {
    
    func testConverter() {
        XCTAssertEqual(try! Converter.toEther(wei: Wei("100000000000000")!), 0.0001)
        XCTAssertEqual(try! Converter.toEther(wei: Wei("1000000000000000")!), 0.001)
        XCTAssertEqual(try! Converter.toEther(wei: Wei("10000000000000000")!), 0.01)
        XCTAssertEqual(try! Converter.toEther(wei: Wei("100000000000000000")!), 0.1)
        XCTAssertEqual(try! Converter.toEther(wei: Wei("1000000000000000000")!), 1)
        XCTAssertEqual(try! Converter.toEther(wei: Wei("10000000000000000000")!), 10)
        XCTAssertEqual(try! Converter.toEther(wei: Wei("100000000000000000000")!), 100)
        XCTAssertEqual(try! Converter.toEther(wei: Wei("1000000000000000000000")!), 1000)
        
        XCTAssertEqual(try! Converter.toWei(ether: Ether(string: "0.0001")!).description, "100000000000000")
        XCTAssertEqual(try! Converter.toWei(ether: Ether(string: "0.001")!).description, "1000000000000000")
        XCTAssertEqual(try! Converter.toWei(ether: Ether(string: "0.01")!).description, "10000000000000000")
        XCTAssertEqual(try! Converter.toWei(ether: Ether(string: "0.1")!).description, "100000000000000000")
        XCTAssertEqual(try! Converter.toWei(ether: Ether(string: "1")!).description, "1000000000000000000")
        XCTAssertEqual(try! Converter.toWei(ether: Ether(string: "10")!).description, "10000000000000000000")
        XCTAssertEqual(try! Converter.toWei(ether: Ether(string: "100")!).description, "100000000000000000000")
        XCTAssertEqual(try! Converter.toWei(ether: Ether(string: "1000")!).description, "1000000000000000000000")
        
        XCTAssertEqual(Converter.toWei(GWei: 1), 1000000000)
        XCTAssertEqual(Converter.toWei(GWei: 10), 10000000000)
        XCTAssertEqual(Converter.toWei(GWei: 15), 15000000000)
        XCTAssertEqual(Converter.toWei(GWei: 30), 30000000000)
        XCTAssertEqual(Converter.toWei(GWei: 60), 60000000000)
        XCTAssertEqual(Converter.toWei(GWei: 99), 99000000000)
    }
}
