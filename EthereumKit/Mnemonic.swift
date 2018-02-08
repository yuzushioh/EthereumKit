//
//  Mnemonic.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/01/01.
//  Copyright © 2018 yuzushioh.
//

import Foundation

public final class Mnemonic {
    public enum Strength: Int {
        case normal = 128
        case hight = 256
    }
    
    public static func create(strength: Strength = .normal, language: WordList = .english) -> String {
        let byteCount = strength.rawValue / 8
        var bytes = Data(count: byteCount)
        _ = bytes.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, byteCount, $0) }
        return create(entropy: bytes, language: language)
    }
    
    public static func create(entropy: Data, language: WordList = .english) -> String {
        var bin = String(entropy.flatMap { ("00000000" + String($0, radix:2)).suffix(8) })
        
        let hash = entropy.sha256()
        let hashBits = String(hash.flatMap { ("00000000" + String($0, radix: 2).suffix(8) )})
        
        let cs = (entropy.count * 8) / 32
        let checkSum = String(hashBits.prefix(cs))
        bin += checkSum
        
        let interval = 11
        let words = language.words
        
        var mnemonic: [String] = []
        for index in 0..<(bin.count / interval) {
            let startIndex = bin.index(bin.startIndex, offsetBy: index * interval)
            let endIndex = bin.index(bin.startIndex, offsetBy: (index + 1) * interval)
            
            let wordIndex = Int(bin[startIndex..<endIndex], radix: 2)!
            mnemonic.append(String(words[wordIndex]))
        }
        
        return mnemonic.joined(separator: " ")
    }
    
    public static func createSeed(mnemonic: String, withPassphrase passphrase: String = "") -> Data {
        guard let password = mnemonic.decomposedStringWithCompatibilityMapping.data(using: .utf8) else {
            fatalError("Nomalizing password failed in \(self)")
        }
        
        guard let salt = ("mnemonic" + passphrase).decomposedStringWithCompatibilityMapping.data(using: .utf8) else {
            fatalError("Nomalizing salt failed in \(self)")
        }
        
        return Crypto.PBKDF2SHA512(password: password.bytes, salt: salt.bytes)
    }
}
