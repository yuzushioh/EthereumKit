//
//  Base58Encode.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/09.
//  Copyright © 2018 yuzushioh. All rights reserved.
//

import Foundation

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
