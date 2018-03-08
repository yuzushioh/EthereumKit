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
        XCTAssertEqual(Gas.limit.value, Gas.GasLimit.default.value)
        XCTAssertEqual(Gas.price.value, Gas.GasPrice.default.value)
        
        Gas.setGasLimit(.high)
        Gas.setGasPirce(.high)
        
        XCTAssertEqual(Gas.limit.value, Gas.GasLimit.high.value)
        XCTAssertEqual(Gas.price.value, Gas.GasPrice.high.value)
        
        Gas.setGasLimit(.low)
        Gas.setGasPirce(.custom(GWei: 9))
        
        XCTAssertEqual(Gas.limit.value, Gas.GasLimit.low.value)
        XCTAssertEqual(Gas.price.value, 9)
    }
}
