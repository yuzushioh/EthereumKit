//
//  PublicKey.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import ECDSA
import CryptoSwift

public struct PublicKey {
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let network: Network
    
    public let raw: Data
    public let chainCode: Data
    
    init(privateKey: PrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, index: UInt32) {
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
        self.raw = ECDSA.secp256k1.generatePublicKey(with: privateKey.raw, isCompressed: false)
        self.chainCode = chainCode
    }
    
    public var address: String {
        let publicKey = raw.dropFirst()
        let publicKeyHash = publicKey.sha3(.keccak256)
        return "0x" + publicKeyHash.suffix(20).toHexString()
    }
}
