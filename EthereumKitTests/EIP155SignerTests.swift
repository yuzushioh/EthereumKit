//
//  EIP155SignerTests.swift
//  EthereumKitTests
//
//  Created by yuzushioh on 2018/03/05.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import XCTest
import SMP
@testable import EthereumKit

class EIP155SignerTests: XCTestCase {
    func testEIP155Signing() {
        let signTransaction1 = SignTransaction(
            value: BInt("10000000000000000")!,
            to: Address(string: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F"),
            gasPrice: BInt(99000000000),
            gasLimit: BInt(21000),
            data: Data(),
            nonce: 2,
            chainID: 3
        )
        
        XCTAssertEqual(
            EIP155Signer.hash(signTransaction: signTransaction1).toHexString(),
            "84df8756f832aa25f79fdeac98ae9adf83b1da0119dd3555807f890f09c3e1a7"
        )
        
        let signTransaction2 = SignTransaction(
            value: BInt("10000000000000000")!,
            to: Address(string: "0x88b44BC83add758A3642130619D61682282850Df"),
            gasPrice: BInt(99000000000),
            gasLimit: BInt(21000),
            data: Data(),
            nonce: 4,
            chainID: 3
        )
        
        XCTAssertEqual(
            EIP155Signer.hash(signTransaction: signTransaction2).toHexString(),
            "18f93470671a0db633e4346dfa5ecdc2568e2befdbf815ac205d9eef06a91350"
        )
        
        let signTransaction3 = SignTransaction(
            value: BInt("10000000000000000")!,
            to: Address(string: "0x72AAb5461F9bE958E1c375285CC2aA7De89D02A1"),
            gasPrice: BInt(99000000000),
            gasLimit: BInt(21000),
            data: Data(),
            nonce: 25,
            chainID: 3
        )
        
        XCTAssertEqual(
            EIP155Signer.hash(signTransaction: signTransaction3).toHexString(),
            "0af0867d4acb71dd0bd590b86aef78d7ccfdcdcf16e881e9f426e432a1603eaf"
        )
    }
}
