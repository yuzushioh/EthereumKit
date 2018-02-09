//
//  PublicKey.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh.
//

import ECDSA
import CryptoSwift

public struct PublicKey {
    public let raw: Data
    public let chainCode: Data
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let network: Network
    
    init(privateKey: PrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, index: UInt32) {
        let publicKey = ECDSA.secp256k1.generatePublicKey(with: privateKey.raw, isCompressed: true)
        self.raw = Data(hex: "0x") + publicKey
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
    }
    
    public var address: String {
        let publicKeyHash = raw.sha3(.keccak256)
        return "0x" + publicKeyHash.suffix(20).toHexString()
    }
}
