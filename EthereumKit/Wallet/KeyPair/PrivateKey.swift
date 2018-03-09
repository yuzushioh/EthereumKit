//
//  PrivateKey.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh.
//

import Foundation
import EthereumKit.Private

public struct PrivateKey {
    public let raw: Data
    public let chainCode: Data
    private let depth: UInt8
    private let fingerprint: UInt32
    private let childIndex: UInt32
    private let network: Network
    
    public init(seed: Data, network: Network) {
        let output = Crypto.HMACSHA512(key: "Bitcoin seed".data(using: .ascii)!, data: seed)
        self.raw = Data(hex: "0x") + output[0..<32]
        self.chainCode = output[32..<64]
        self.depth = 0
        self.fingerprint = 0
        self.childIndex = 0
        self.network = network
    }
    
    private init(privateKey: Data, chainCode: Data, depth: UInt8, fingerprint: UInt32, index: UInt32, network: Network) {
        self.raw = privateKey
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.childIndex = index
        self.network = network
    }
    
    public var publicKey: PublicKey {
        return PublicKey(privateKey: self, chainCode: chainCode, network: network, depth: depth, fingerprint: fingerprint, index: childIndex)
    }
    
    public var extended: String {
        var extendedPrivateKeyData = Data()
        extendedPrivateKeyData += network.privateKeyPrefix.bigEndian
        extendedPrivateKeyData += depth.littleEndian
        extendedPrivateKeyData += fingerprint.littleEndian
        extendedPrivateKeyData += childIndex.littleEndian
        extendedPrivateKeyData += chainCode
        extendedPrivateKeyData += UInt8(0)
        extendedPrivateKeyData += raw
        return Base58.encode(extendedPrivateKeyData)
    }
    
    public func sign(hash: Data) throws -> Data {
        return try Crypto.sign(hash, privateKey: raw)
    }
    
    public func generateAddress() -> String {
        return publicKey.address.string
    }
    
    public func derived(at index: UInt32, hardens: Bool = false) throws -> PrivateKey {
        guard (0x80000000 & index) == 0 else {
            fatalError("Invalid index \(index)")
        }
        
        let keyDeriver = KeyDerivation(
            privateKey: raw,
            publicKey: publicKey.raw,
            chainCode: chainCode,
            depth: depth,
            fingerprint: fingerprint,
            childIndex: childIndex
        )
        
        guard let derivedKey = keyDeriver.derived(at: index, hardened: hardens) else {
            throw DerivationError.derivateionFailed
        }
        
        return PrivateKey(
            privateKey: derivedKey.privateKey!,
            chainCode: derivedKey.chainCode,
            depth: derivedKey.depth,
            fingerprint: derivedKey.fingerprint,
            index: derivedKey.childIndex,
            network: network
        )
    }
}

public enum DerivationError : Error {
    case derivateionFailed
}
