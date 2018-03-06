//
//  TransactionSigningTests.swift
//  EthereumKitTests
//
//  Created by yuzushioh on 2018/03/07.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import XCTest
import SMP
@testable import EthereumKit

class TransactionSigningTests: XCTestCase {
    
    func testTransactionSigning() {
        let signTransaction = SignTransaction(
            value: BInt("1000000000000000000")!,
            to: Address(string: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F"),
            gasPrice: BInt("99000000000")!,
            gasLimit: BInt("21000")!,
            data: Data(),
            nonce: 5
        )
        
        let signer = EIP155Signer(chainID: 3)
        let signiture = Crypto.sign(
            signer.hash(signTransaction: signTransaction),
            privateKey: Data(hex: "db173e58671248b48d2494b63a99008be473268581ca1eb78ed0b92e03b13bbc")
        )
        
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        
        let data = RLP.encode([
            signTransaction.nonce,
            signTransaction.gasPrice,
            signTransaction.gasLimit,
            signTransaction.to.data,
            signTransaction.value,
            signTransaction.data,
            v, r, s,
        ])
        
        XCTAssertEqual(
            data!.toHexString().appending0xPrefix, "0xf86c0585170cdc1e008252089491c79f31de5208fadcbf83f0a7b0a9b6d8aba90f880de0b6b3a76400008029a076da637d6a2fa3197c0a1b7c9bc2a4326c9a1dbe94c4eb8449bf59919f89b762a00887bcdd883f2cc2c892e55665419fad6522d4e7e1f7c226282078de98f4069c"
        )
    }
    
    func testTransactionSigning2() {
        let signTransaction = SignTransaction(
            value: BInt("100000000000000000")!,
            to: Address(string: "0x3B958949EfCc8362Dd05179cCE8eB5e16BefeBdA"),
            gasPrice: BInt("99000000000")!,
            gasLimit: BInt("21000")!,
            data: Data(),
            nonce: 5
        )
        
        let signer = EIP155Signer(chainID: 3)
        let signiture = Crypto.sign(
            signer.hash(signTransaction: signTransaction),
            privateKey: Data(hex: "db173e58671248b48d2494b63a99008be473268581ca1eb78ed0b92e03b13bbc")
        )
        
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        
        let data = RLP.encode([
            signTransaction.nonce,
            signTransaction.gasPrice,
            signTransaction.gasLimit,
            signTransaction.to.data,
            signTransaction.value,
            signTransaction.data,
            v, r, s,
        ])
        
        XCTAssertEqual(
            data!.toHexString().appending0xPrefix, "0xf86c0585170cdc1e00825208943b958949efcc8362dd05179cce8eb5e16befebda88016345785d8a00008029a022ab35848cce6ddf0ef76ea6ab25cebe449d822073492c6e2b90a2707bd061d0a0414e6f152f66a62158a59a9ffe095bd1beacf0d2510b9204aec8a8cacbcbdf31"
        )
    }
    
    func testTransactionSigning3() {
        let signTransaction = SignTransaction(
            value: BInt("500000000000000000")!,
            to: Address(string: "0xfc9d3987f7fcd9181393084a94814385b28cEf81"),
            gasPrice: BInt("99000000000")!,
            gasLimit: BInt("200000")!,
            data: Data(),
            nonce: 5
        )
        
        let signer = EIP155Signer(chainID: 3)
        let signiture = Crypto.sign(
            signer.hash(signTransaction: signTransaction),
            privateKey: Data(hex: "db173e58671248b48d2494b63a99008be473268581ca1eb78ed0b92e03b13bbc")
        )
        
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        
        let data = RLP.encode([
            signTransaction.nonce,
            signTransaction.gasPrice,
            signTransaction.gasLimit,
            signTransaction.to.data,
            signTransaction.value,
            signTransaction.data,
            v, r, s,
        ])
        
        XCTAssertEqual(
            data!.toHexString().appending0xPrefix, "0xf86d0585170cdc1e0083030d4094fc9d3987f7fcd9181393084a94814385b28cef818806f05b59d3b200008029a096479bbc675f9ae3bdc23f6fa22adf5bc009c1661b6336bdeaa2959dce6d55dba0302981091abc6dc4736676b93c24fde68d11bad45741a2d8c5bfdfb633039863"
        )
    }
}
