//
//  EIP155Signer.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/03/02.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import SMP
import CryptoSwift

public struct EIP155Signer {
    public static func hash(signTransaction: SignTransaction) -> Data {
        guard let data = encode(signTransaction: signTransaction) else {
            fatalError("Failded to RLP hash \(signTransaction)")
        }
        return Data(bytes: SHA3(variant: .keccak256).calculate(for: data.bytes))
    }
    
    public static func encode(signTransaction: SignTransaction, rsv: (r: Data, s: Data, v: Data)? = nil) -> Data? {
        var elements: [Any] = [
            signTransaction.nonce,
            signTransaction.gasPrice,
            signTransaction.gasLimit,
            signTransaction.to.data,
            signTransaction.value,
            signTransaction.data,
            signTransaction.chainID, 0, 0 // EIP155
        ]
        
        if let rsvValue = rsv {
            elements.append(rsvValue.r)
            elements.append(rsvValue.s)
            elements.append(rsvValue.v)
        }
        
        return RLP.encode(elements)
    }
}
