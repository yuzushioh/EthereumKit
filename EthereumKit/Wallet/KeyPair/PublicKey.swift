//
//  PublicKey.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh.
//

import Foundation

public struct PublicKey {
    public let raw: Data
    public let chainCode: Data
    private let depth: UInt8
    private let fingerprint: UInt32
    private let index: UInt32
    private let network: Network
    private let privateKey: PrivateKey
    
    init(privateKey: PrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, index: UInt32) {
        let compressed = Crypto.generatePublicKey(data: privateKey.raw, compressed: true)
        self.raw = Data(hex: "0x") + compressed
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
        self.privateKey = privateKey
    }
    
    public var address: String {
        return "0x" + EIP55.encode(addressData)
    }
    
    private var addressData: Data {
        let uncompressed = Crypto.generatePublicKey(data: privateKey.raw, compressed: false)
        let hash = uncompressed.dropFirst().sha3(.keccak256)
        return hash.suffix(20)
    }
}
