//
//  PrivateKey.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh.
//

import CryptoSwift

public struct PrivateKey {
    public let raw: Data
    public let chainCode: Data
    public let depth: UInt8
    public let fingerprint: UInt32
    public let index: UInt32
    public let network: Network
    
    init(seed: Data, network: Network) {
        let output = Crypto.HMACSHA512(key: "Bitcoin seed".data(using: .ascii)!, data: seed)
        self.raw = Data(hex: "0x") + output[0..<32]
        self.chainCode = output[32..<64]
        self.depth = 0
        self.fingerprint = 0
        self.index = 0
        self.network = network
    }
    
    init(privateKey: Data, chainCode: Data, depth: UInt8, fingerprint: UInt32, index: UInt32, network: Network) {
        self.raw = privateKey
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
    }
    
    public var publicKey: PublicKey {
        return PublicKey(privateKey: self, chainCode: chainCode, network: network, depth: depth, fingerprint: fingerprint, index: index)
    }
    
    public var extended: String {
        var extendedPrivateKeyData = Data()
        extendedPrivateKeyData += network.privateKeyPrefix.bigEndian
        extendedPrivateKeyData += depth.littleEndian
        extendedPrivateKeyData += fingerprint.littleEndian
        extendedPrivateKeyData += index.littleEndian
        extendedPrivateKeyData += chainCode
        extendedPrivateKeyData += UInt8(0)
        extendedPrivateKeyData += raw
        return extendedPrivateKeyData.base58BaseEncodedString
    }
    
    public func derived(at index: UInt32, hardens: Bool = false) -> PrivateKey {
        let edge: UInt32 = 0x80000000
        guard (edge & index) == 0 else { fatalError("Invalid child index") }
        
        var data = Data()
        if hardens {
            data += UInt8(0)
            data += raw
        } else {
            data += publicKey.raw
        }
        
        let derivingIndex = hardens ? (edge + index) : index
        data += derivingIndex.bigEndian
        
        let digest = Crypto.HMACSHA512(key: chainCode, data: data)
        let factor = BInt(data: digest[0..<32])
        
        let curveOrder = BInt(hex: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141")!
        let derivedPrivateKey = ((BInt(data: raw) + factor) % curveOrder).data
        
        let derivedChainCode = digest[32..<64]
        let fingurePrint: UInt32 = publicKey.raw.hash160.withUnsafeBytes { $0.pointee }
        
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
