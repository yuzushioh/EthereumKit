//
//  GasTests.swift
//  EthereumKitTests
//
//  Created by yuzushioh on 2018/03/08.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import XCTest
@testable import EthereumKit

class GasTests: XCTestCase {
    func testGas() {
        XCTAssertEqual(Gas.limit.value, GasLimit.default.value)
        XCTAssertEqual(Gas.price.value, GasPrice.default.value)
        
        Gas.setGasLimit(.high)
        Gas.setGasPirce(.high)
        
        XCTAssertEqual(Gas.limit.value, GasLimit.high.value)
        XCTAssertEqual(Gas.price.value, GasPrice.high.value)
        
        Gas.setGasLimit(.low)
        Gas.setGasPirce(.custom(9000))
        
        XCTAssertEqual(Gas.limit.value, GasLimit.low.value)
        XCTAssertEqual(Gas.price.value, 9000)
    }
}
