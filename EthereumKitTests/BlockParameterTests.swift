import XCTest
@testable import EthereumKit

final class BlockParameterTests: XCTestCase {
    
    func testBlockParameter() {
        let latest = BlockParameter(rawValue: "latest")
        XCTAssertNotNil(latest)
        XCTAssertEqual(latest, BlockParameter.latest)
        
        let earliest = BlockParameter(rawValue: "earliest")
        XCTAssertNotNil(earliest)
        XCTAssertEqual(earliest, BlockParameter.earliest)
        
        let pending = BlockParameter(rawValue: "pending")
        XCTAssertNotNil(pending)
        XCTAssertEqual(pending, BlockParameter.pending)
    }
}
