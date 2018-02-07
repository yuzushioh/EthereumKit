//
//  Data+Extension.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh.
//

import Foundation
import CryptoSwift

extension Data {
    var toBits: [String] {
        var bitArray = [String]()
        for byte in bytes {
            bitArray.append(contentsOf: byte.bits)
        }
        return bitArray
    }
    
    var bytes: [UInt8] {
        return Array(self)
    }
}

// MARK: SHA256 of SHA256

extension Data {
    var doubleSHA256: Data {
        return sha256().sha256()
    }
    
    var hash160: Data {
        return RIPEMD160.hash(message: self.sha256())
    }
}

// MARK: Base56Encode

extension Data {
    var base58BaseEncodedString: String {
        return base58Encode()
    }
    
    private func base58Encode() -> String {
        let dec58 = BInt(58)
        let dec0 = BInt(0)
        let base58EncodeCharacters: [Character] = [
            "1", "2", "3", "4", "5", "6", "7", "8", "9",
            "A", "B", "C", "D", "E", "F", "G", "H", "J",
            "K", "L", "M", "N", "P", "Q", "R", "S", "T",
            "U", "V", "W", "X", "Y", "Z",
            "a", "b", "c", "d", "e", "f", "g", "h", "i",
            "j", "k", "m", "n", "o", "p", "q", "r", "s",
            "t", "u", "v", "w", "x", "y", "z"
        ]
        
        let checksum = self.doubleSHA256
        let tmp = self + checksum[0...3]
        
        guard var dec = BInt(hex: tmp.toHexString()) else {
            fatalError()
        }
        
        var characters = Array<String>()
        while dec > dec0 {
            let rem = dec % dec58
            dec = dec / dec58
            
            if let index = rem.toInt() {
                characters.insert(String(base58EncodeCharacters[index]), at: 0)
            }
        }
        
        // replace leading char '0' with '1'
        characters.forEach { character in
            guard character == "0" else {
                return
            }
            let index = characters.index(of: character)!
            characters.replaceSubrange(index...index + 1, with: ["1"])
        }
        
        return characters.joined()
    }
}
