import XCTest
@testable import EthereumKit

class RLPTests: XCTestCase {
    func testEncodingString() {
        XCTAssertEqual(
            try! RLP.encode("").toHexString(),
            "80"
        )
        
        XCTAssertEqual(
            try! RLP.encode("dog").toHexString(),
            "83646f67"
        )
    }
    
    func testInteger() {
        XCTAssertEqual(
            try! RLP.encode(0).toHexString(),
            "80"
        )
        
        XCTAssertEqual(
            try! RLP.encode(127).toHexString(),
            "7f"
        )
        
        XCTAssertEqual(
            try! RLP.encode(128).toHexString(),
            "8180"
        )
        
        XCTAssertEqual(
            try! RLP.encode(256).toHexString(),
            "820100"
        )
        
        XCTAssertEqual(
            try! RLP.encode(1024).toHexString(),
            "820400"
        )
        
        XCTAssertEqual(
            try! RLP.encode(0xffffff).toHexString(),
            "83ffffff"
        )
        
        XCTAssertEqual(
            try! RLP.encode(0xffffffff).toHexString(),
            "84ffffffff"
        )
        
        XCTAssertEqual(
            try! RLP.encode(0xffffffffffffff).toHexString(),
            "87ffffffffffffff"
        )
    }
    
    func testList() {
        XCTAssertEqual(
            try! RLP.encode([]).toHexString(),
            "c0"
        )
        
        XCTAssertEqual(
            try! RLP.encode([1, 2, 3]).toHexString(),
            "c3010203"
        )
        
        XCTAssertEqual(
            try! RLP.encode(["cat", "dog"]).toHexString(),
            "c88363617483646f67"
        )
        
        XCTAssertEqual(
            try! RLP.encode([ [], [[]], [ [], [[]] ] ]).toHexString(),
            "c7c0c1c0c3c0c1c0"
        )
        
        XCTAssertEqual(
            try! RLP.encode([1, 0xffffff, [4, 5, 5], "abc"]).toHexString(),
            "cd0183ffffffc304050583616263"
        )
        
        XCTAssert(try! RLP.encode(Array<Int>(repeating: 0, count: 1024)).toHexString().hasPrefix("f90400"))
    }
    
    func testData() {
        XCTAssertEqual(
            try! RLP.encode(Data(hex: "28ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa636276")).toHexString(),
            "a028ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa636276"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt("18515461264373351373200002665853028612451056578545711640558177340181847433846")!.serialize()).toHexString(),
            "a028ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa636276"
        )
        
        XCTAssertEqual(
            try! RLP.encode(Data(hex: "67cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d83")).toHexString(),
            "a067cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d83"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt("46948507304638947509940763649030358759909902576025900602547168820602576006531")!.serialize()).toHexString(),
            "a067cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d83"
        )
        
        XCTAssertEqual(
            try! RLP.encode(Data(hex: "29")).toHexString(),
            "29"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(41).serialize()).toHexString(),
            "29"
        )
    }
    
    func testBInt() {
        XCTAssertEqual(
            try! RLP.encode(BInt(0)).toHexString(),
            "80"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(1)).toHexString(),
            "01"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(127)).toHexString(),
            "7f"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(128)).toHexString(),
            "8180"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(256)).toHexString(),
            "820100"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(1024)).toHexString(),
            "820400"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt("10000000000000000")!).toHexString(),
            "872386f26fc10000"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt("100000000000000000")!).toHexString(),
            "88016345785d8a0000"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt("1000000000000000000")!).toHexString(),
            "880de0b6b3a7640000"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt("10000000000000000000")!).toHexString(),
            "888ac7230489e80000"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt("12371637000000000")!).toHexString(),
            "872bf3f034acd200"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt("123716370000000000")!).toHexString(),
            "8801b787620ec03400"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt("1237163700000000000")!).toHexString(),
            "88112b49d493820800"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt("12371637000000000000")!).toHexString(),
            "88abb0e24dc3145000"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(0xffffff)).toHexString(),
            "83ffffff"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(0xffffffff)).toHexString(),
            "84ffffffff"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(0xffffffffffffff)).toHexString(),
            "87ffffffffffffff"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(str: "102030405060708090a0b0c0d0e0f2", radix: 16)!).toHexString(),
            "8f102030405060708090a0b0c0d0e0f2"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(str: "0100020003000400050006000700080009000a000b000c000d000e01", radix: 16)!).toHexString(),
            "9c0100020003000400050006000700080009000a000b000c000d000e01"
        )
        
        XCTAssertEqual(
            try! RLP.encode(BInt(str: "010000000000000000000000000000000000000000000000000000000000000000", radix: 16)!).toHexString(),
            "a1010000000000000000000000000000000000000000000000000000000000000000"
        )
    }
}
