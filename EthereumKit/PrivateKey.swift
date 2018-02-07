//
//  PrivateKey.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh.
//

import CryptoSwift

public struct PrivateKey {
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let network: Network
    
    public let raw: Data
    public let chainCode: Data
    
    init(seed: Data, network: Network) {
        self.depth = 0
        self.fingerprint = 0
        self.index = 0
        self.network = network
        
        let output = Crypto.HMACSHA512(key: "Bitcoin seed".data(using: .ascii)!, data: seed)
        self.raw = output[0..<32]
        self.chainCode = output[32..<64]
    }
    
    init(privateKey: Data, chainCode: Data, depth: UInt8, fingerprint: UInt32, index: UInt32, network: Network) {
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
        self.raw = privateKey
        self.chainCode = chainCode
    }
    
    public var publicKey: PublicKey {
        return PublicKey(privateKey: self, chainCode: chainCode, network: network, depth: depth, fingerprint: fingerprint, index: index)
    }
    
    public func derived(at index: UInt32, hardens: Bool = false) -> PrivateKey {
        let edge: UInt32 = 0x80000000
        guard (edge & index) == 0 else { fatalError("Invalid child index") }
        
        var data = Data()
        if hardens {
            data += UInt8(0).toHexData
            data += raw
        } else {
            data += publicKey.raw
        }
        
        let derivingIndex = hardens ? (edge + index) : index
        data += derivingIndex.toHexData
        
        let digest = Crypto.HMACSHA512(key: chainCode, data: data)
        let factor = BInt(data: digest[0..<32])
        
        let curveOrder = BInt(hex: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141")!
        let derivedPrivateKey = ((BInt(data: raw) + factor) % curveOrder).data
        
        let derivedChainCode = digest[32..<64]
        let fingurePrint = UInt32(bytes: publicKey.raw.hash160.prefix(4))
        
        return PrivateKey(
            privateKey: derivedPrivateKey,
            chainCode: derivedChainCode,
            depth: depth + 1,
            fingerprint: fingurePrint,
            index: derivingIndex,
            network: network
        )
    }
}
