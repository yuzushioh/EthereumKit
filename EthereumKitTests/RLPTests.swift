//
//  RLPTests.swift
//  EthereumKitTests
//
//  Created by yuzushioh on 2018/03/05.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import XCTest
import SMP
@testable import EthereumKit

class RLPTests: XCTestCase {
    func testEncodingString() {
        XCTAssertEqual(
            RLP.encode("")!.toHexString(),
            "80"
        )
        
        XCTAssertEqual(
            RLP.encode("dog")!.toHexString(),
            "83646f67"
        )
    }
    
    func testInteger() {
        XCTAssertEqual(
            RLP.encode(0)!.toHexString(),
            "80"
        )
        
        XCTAssertEqual(
            RLP.encode(127)!.toHexString(),
            "7f"
        )
        
        XCTAssertEqual(
            RLP.encode(128)!.toHexString(),
            "8180"
        )
        
        XCTAssertEqual(
            RLP.encode(256)!.toHexString(),
            "820100"
        )
        
        XCTAssertEqual(
            RLP.encode(1024)!.toHexString(),
            "820400"
        )
        
        XCTAssertEqual(
            RLP.encode(0xffffff)!.toHexString(),
            "83ffffff"
        )
        
        XCTAssertEqual(
            RLP.encode(0xffffffff)!.toHexString(),
            "84ffffffff"
        )
        
        XCTAssertEqual(
            RLP.encode(0xffffffffffffff)!.toHexString(),
            "87ffffffffffffff"
        )
    }
    
    func testList() {
        XCTAssertEqual(
            RLP.encode([])!.toHexString(),
            "c0"
        )
        
        XCTAssertEqual(
            RLP.encode([1, 2, 3])!.toHexString(),
            "c3010203"
        )
        
        XCTAssertEqual(
            RLP.encode(["cat", "dog"])!.toHexString(),
            "c88363617483646f67"
        )
        
        XCTAssertEqual(
            RLP.encode([ [], [[]], [ [], [[]] ] ])!.toHexString(),
            "c7c0c1c0c3c0c1c0"
        )
        
        XCTAssertEqual(
            RLP.encode([1, 0xffffff, [4, 5, 5], "abc"])!.toHexString(),
            "cd0183ffffffc304050583616263"
        )
        
        XCTAssert(RLP.encode(Array<Int>(repeating: 0, count: 1024))!.toHexString().hasPrefix("f90400"))
    }
    
    func testBInt() {
        XCTAssertEqual(
            RLP.encode(BInt(0))!.toHexString(),
            "80"
        )
        
        XCTAssertEqual(
            RLP.encode(BInt(1))!.toHexString(),
            "01"
        )
        
        XCTAssertEqual(
            RLP.encode(BInt(127))!.toHexString(),
            "7f"
        )
        
        XCTAssertEqual(
            RLP.encode(BInt(128))!.toHexString(),
            "8180"
        )
        
        XCTAssertEqual(
            RLP.encode(BInt(256))!.toHexString(),
            "820100"
        )
        
        XCTAssertEqual(
            RLP.encode(BInt(1024))!.toHexString(),
            "820400"
        )
        
        XCTAssertEqual(
            RLP.encode(BInt(0xffffff))!.toHexString(),
            "83ffffff"
        )
        
        XCTAssertEqual(
            RLP.encode(BInt(0xffffffff))!.toHexString(),
            "84ffffffff"
        )
        
        XCTAssertEqual(
            RLP.encode(BInt(0xffffffffffffff))!.toHexString(),
            "87ffffffffffffff"
        )
        
        XCTAssertEqual(
            RLP.encode(BInt(str: "102030405060708090a0b0c0d0e0f2", radix: 16)!)!.toHexString(),
            "8f102030405060708090a0b0c0d0e0f2"
        )
        
        XCTAssertEqual(
            RLP.encode(BInt(str: "0100020003000400050006000700080009000a000b000c000d000e01", radix: 16)!)!.toHexString(),
            "9c0100020003000400050006000700080009000a000b000c000d000e01"
        )
        
        XCTAssertEqual(
            RLP.encode(BInt(str: "010000000000000000000000000000000000000000000000000000000000000000", radix: 16)!)!.toHexString(),
            "a1010000000000000000000000000000000000000000000000000000000000000000"
        )
    }
}
