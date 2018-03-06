//
//  Crypto.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/06.
//  Copyright © 2018 yuzushioh.
//

import EthereumKit.Private

final class Crypto {
    static func HMACSHA512(key: Data, data: Data) -> Data {
        return CryptoHash.hmacsha512(data, key: key)
    }
    
    static func PBKDF2SHA512(_ password: Data, salt: Data) -> Data {
        return PKCS5.pbkdf2(password, salt: salt, iterations: 2048, keyLength: 64)
    }
    
    static func hash160(_ data: Data) -> Data {
        return CryptoHash.ripemd160(CryptoHash.sha256(data))
    }
    
    static func generatePublicKey(data: Data, compressed: Bool) -> Data {
        return Secp256k1.generatePublicKey(withPrivateKey: data, compression: compressed)
    }
}
