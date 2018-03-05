//
//  AddressTests.swift
//  EthereumKitTests
//
//  Created by yuzushioh on 2018/03/05.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import XCTest
@testable import EthereumKit

class AddressTests: XCTestCase {
    func testAddressInitialization() {
        let string = "0x88b44BC83add758A3642130619D61682282850Df"
        let hex = "88b44bc83add758a3642130619d61682282850df"
        XCTAssert(Address(data: Data(hex: hex)).string == string)
        XCTAssert(Address(string: string).data.toHexString() == hex)
    }
    
    func testAddressGeneration() {
        let entropy = Data(hex: "000102030405060708090a0b0c0d0e0f")
        let mnemonic = Mnemonic.create(entropy: entropy)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = Wallet(seed: seed, network: .main)
        
        let firstAddress = wallet.receiveAddress(at: 0)
        XCTAssertEqual(firstAddress, "0x72AAb5461F9bE958E1c375285CC2aA7De89D02A1")
        
        let secondAddress = wallet.receiveAddress(at: 1)
        XCTAssertEqual(secondAddress, "0x8eFBe08d042c647E9879D83082dD91a86383F41A")
        
        let thirdAddress = wallet.receiveAddress(at: 2)
        XCTAssertEqual(thirdAddress, "0x2E158F579F10C6c3E3C8bF12BC5D795678b512C3")
        
        let forthAddress = wallet.receiveAddress(at: 3)
        XCTAssertEqual(forthAddress, "0xC8d080e57A79960b92514678C2eF0528e08900A3")
        
    }
}
