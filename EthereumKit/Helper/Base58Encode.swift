// Copied from https://github.com/kishikawakatsumi/BitcoinKit/blob/master/BitcoinKit/Encoding.swift
public struct Base58 {
    private static let alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    
    public static func encode(_ bytes: Data) -> String {
        var bytes = bytes
        var zerosCount = 0
        var length = 0
        
        for b in bytes {
            if b != 0 { break }
            zerosCount += 1
        }
        
        bytes.removeFirst(zerosCount)
        
        let size = bytes.count * 138 / 100 + 1
        
        var base58: [UInt8] = Array(repeating: 0, count: size)
        for b in bytes {
            var carry = Int(b)
            var i = 0
            
            for j in 0...base58.count - 1 where carry != 0 || i < length {
                carry += 256 * Int(base58[base58.count - j - 1])
                base58[base58.count - j - 1] = UInt8(carry % 58)
                carry /= 58
                i += 1
            }
            
            assert(carry == 0)
            
            length = i
        }
        
        // skip leading zeros
        var zerosToRemove = 0
        var str = ""
        for b in base58 {
            if b != 0 { break }
            zerosToRemove += 1
        }
        base58.removeFirst(zerosToRemove)
        
        while 0 < zerosCount {
            str = "\(str)1"
            zerosCount -= 1
        }
        
        for b in base58 {
            str = "\(str)\(alphabet[String.Index(encodedOffset: Int(b))])"
        }
        
        return str
    }
}
