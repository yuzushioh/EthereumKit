import XCTest
@testable import EthereumKit

class ConverterTests: XCTestCase {
    
    func testConverter() {
        XCTAssertEqual(Converter.toEther(wei: Wei("100000000000000")!).decimalDescription, "0.0001")
        XCTAssertEqual(Converter.toEther(wei: Wei("1000000000000000")!).decimalDescription, "0.0010")
        XCTAssertEqual(Converter.toEther(wei: Wei("10000000000000000")!).decimalDescription, "0.0100")
        XCTAssertEqual(Converter.toEther(wei: Wei("100000000000000000")!).decimalDescription, "0.1000")
        XCTAssertEqual(Converter.toEther(wei: Wei("1000000000000000000")!).description, "1")
        XCTAssertEqual(Converter.toEther(wei: Wei("10000000000000000000")!).description, "10")
        XCTAssertEqual(Converter.toEther(wei: Wei("100000000000000000000")!).description, "100")
        XCTAssertEqual(Converter.toEther(wei: Wei("1000000000000000000000")!).description, "1000")
        
        XCTAssertEqual(Converter.toWei(ether: Ether("0.0001")!).description, "100000000000000")
        XCTAssertEqual(Converter.toWei(ether: Ether("0.001")!).description, "1000000000000000")
        XCTAssertEqual(Converter.toWei(ether: Ether("0.01")!).description, "10000000000000000")
        XCTAssertEqual(Converter.toWei(ether: Ether("0.1")!).description, "100000000000000000")
        XCTAssertEqual(Converter.toWei(ether: Ether("1")!).description, "1000000000000000000")
        XCTAssertEqual(Converter.toWei(ether: Ether("10")!).description, "10000000000000000000")
        XCTAssertEqual(Converter.toWei(ether: Ether("100")!).description, "100000000000000000000")
        XCTAssertEqual(Converter.toWei(ether: Ether("1000")!).description, "1000000000000000000000")
        
        XCTAssertEqual(Converter.toWei(GWei: 1), 1000000000)
        XCTAssertEqual(Converter.toWei(GWei: 10), 10000000000)
        XCTAssertEqual(Converter.toWei(GWei: 15), 15000000000)
        XCTAssertEqual(Converter.toWei(GWei: 30), 30000000000)
        XCTAssertEqual(Converter.toWei(GWei: 60), 60000000000)
        XCTAssertEqual(Converter.toWei(GWei: 99), 99000000000)
    }
}
